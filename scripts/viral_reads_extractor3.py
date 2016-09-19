f = open('/data6/bio/metagenome_phages/IGC-viruses')
phages = f.readlines()
phages = [x.rstrip() for x in phages]
d = dict((key, 0) for key in phages)
with open('/data6/bio/metagenome_phages/pairs/Nielsenfilenames') as nif:
	nif = nif.readlines()
	for filename in nif:
		g = open('/data6/bio/metagenome_phages/pairs/Nielsen2014/%s'%filename.rstrip())
		mapped = g.readlines()
		newname = filename.rstrip()+'.viral'
		newnamefelse = filename.rstrip() + '.non-viral'		
		h = open('/data6/bio/metagenome_phages/pairs/pairs-with-viruses/Nielsen2014/%s'%newname,'w')
		elsegenes = open('/data6/bio/metagenome_phages/pairs/pairs-with-non-viruses/Nielsen2014/%s'%newnamefelse, 'w')
		for i in mapped:
			k = i.rstrip().split('\t')
			try:
				if k[1] in d: # if gene name is in viral reads list
					h.write(k[0])
					h.write('\t')
					h.write(k[1])
					h.write('\n')
				else:
					elsegenes.write(k[0])
					elsegenes.write('\t')
					elsegenes.write(k[1])
					elsegenes.write('\n')
			except IndexError:
				continue
		h.close()
		g.close()
		elsegenes.close()
f.close()
