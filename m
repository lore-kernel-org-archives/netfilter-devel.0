From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Tue, 2 Jul 2002 10:48:31 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15649.59247.55523.824241@isis.cs3-inc.com>
References: <15643.31140.525551.843205@isis.cs3-inc.com>
	<20020628082339.I2890@oknodo.bof.de>
	<15644.41633.528107.723418@isis.cs3-inc.com>
	<20020628203624.A4136@oknodo.bof.de>
	<15644.45834.373409.220647@isis.cs3-inc.com>
	<20020702144048.GM18333@naboo.rchrd.phub.net.cable.rogers.com>
	<20020702183242.E7684@oknodo.bof.de>
	<20020702183547.F7684@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>,
	netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020702183547.F7684@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:
 > > Everybody, have a look at http://bei.bof.de/ex1/. There's a bunch of
 > > pictures, which may become legible together with reading my recent
 > > mails on this thread.

The only thing that looks really suspicious to me is the lump in
original for large table sizes.

I tried this myself:
 # time ./cttest -u -f ../ip_conntrack.2 -s 131073
 filename: ../ip_conntrack.2
 hash function: original
 number of buckets: 131073
 maximum bucket list length: 24
 total number of entries: 32866
 Count	Length	CT
 1	24	0.07%
 1	19	0.13%
 1	14	0.17%
 2	8	0.22%
 13	7	0.50%
 31	6	1.06%
 130	5	3.04%
 276	4	6.40%
 821	3	13.90%
 3392	2	34.54%
 21515	1	100.00%
 104890	0	100.00%

BTW 5 is already at the low end of the probability, as you see for the
other two hashes.

Then, as usual, show the data for the longest bucket, read it into my
lisp program and take differences ...
  > (loop for x in data do (print (loop for z in (first data) as y in x collect (- z y))))

  (0 0 0 0 0) 
  (0 0 0 2 2) 
  (0 0 0 4 4) 
  (0 0 0 6 6) 
  (0 0 0 8 8) 
  (0 0 0 10 10) 
  (0 0 0 12 12) 
  (0 0 0 14 14) 
  (0 -498354813 738840907 37187 38280) 
  (0 0 0 -6 -6) 
  (0 0 0 -20 -20) 
  (0 0 0 -27 -27) 
  (0 0 0 -2 -2) 
  (0 0 0 -16 -16) 
  (0 0 0 -37 -37) 
  (0 0 0 -12 -12) 
  (0 0 0 -33 -33) 
  (0 0 0 -8 -8) 
  (0 0 0 -29 -29) 
  (0 0 0 -18 -18) 
  (0 0 0 -25 -25) 
  (0 0 0 -4 -4) 
  (0 0 0 -35 -35) 
  (0 0 0 -31 -31) 

I also changed cttest to print hash data (all hex):
sip 100ce87 dip 100ce87 sport d995 dport d895 proto 6 result 3e4f98db
sip 100ce87 dip 100ce87 sport d795 dport d695 proto 6 result 3e4b98d9
sip 100ce87 dip 100ce87 sport d595 dport d495 proto 6 result 3e4798d7
sip 100ce87 dip 100ce87 sport d395 dport d295 proto 6 result 3e4398d5
sip 100ce87 dip 100ce87 sport d195 dport d095 proto 6 result 3e3f98d3
sip 100ce87 dip 100ce87 sport cf95 dport ce95 proto 6 result 3e3b98d1
sip 100ce87 dip 100ce87 sport cd95 dport cc95 proto 6 result 3e3798cf
sip 100ce87 dip 100ce87 sport cb95 dport ca95 proto 6 result 3e3398cd
sip 7e4a82a5 dip b62ec45b sport 9604 dport 5000 proto 6 result a2d7eca
sip 100ce87 dip 100ce87 sport df95 dport de95 proto 6 result 3e5b98e1
sip 100ce87 dip 100ce87 sport ed95 dport ec95 proto 6 result 3e7798ef
sip 100ce87 dip 100ce87 sport f495 dport f395 proto 6 result 3e8598f6
sip 100ce87 dip 100ce87 sport db95 dport da95 proto 6 result 3e5398dd
sip 100ce87 dip 100ce87 sport e995 dport e895 proto 6 result 3e6f98eb
sip 100ce87 dip 100ce87 sport fe95 dport fd95 proto 6 result 3e999900
sip 100ce87 dip 100ce87 sport e595 dport e495 proto 6 result 3e6798e7
sip 100ce87 dip 100ce87 sport fa95 dport f995 proto 6 result 3e9198fc
sip 100ce87 dip 100ce87 sport e195 dport e095 proto 6 result 3e5f98e3
sip 100ce87 dip 100ce87 sport f695 dport f595 proto 6 result 3e8998f8
sip 100ce87 dip 100ce87 sport eb95 dport ea95 proto 6 result 3e7398ed
sip 100ce87 dip 100ce87 sport f295 dport f195 proto 6 result 3e8198f4
sip 100ce87 dip 100ce87 sport dd95 dport dc95 proto 6 result 3e5798df
sip 100ce87 dip 100ce87 sport fc95 dport fb95 proto 6 result 3e9598fe
sip 100ce87 dip 100ce87 sport f895 dport f795 proto 6 result 3e8d98fa


It seems that adding n to the two ports (which is what happens almost
every time here) gives a difference in the hash function of n*131073 !!

static u32 hash_conntrack(struct ct_key *key)
{
  u32 ans;
  ans= ntohl(key->sip + key->dip
		+ key->sport + key->dport
		+ key->proto)
		+ ntohs(key->sport);
  printf("sip %x dip %x sport %x dport %x proto %x result %x\n", 
	 key->sip, key->dip, key->sport, key->dport, key->proto, ans);
  return ans;
}

I think this is related to the ntohl and ntohs.  If all the data were 0
the sum would be 0.  When you add 1 to sport and dport you get something
like 2^16 + 2 ?
which is 2 x our unlucky table size, right?
Or something like that.
And similar things happen with table size 2^n-1.
Basically the problem with this sort of hash function is that you get 
collisions when you have a lot of IP and port pairs that are close to
each other with the wrong sort of correlation.

Have you tried the ABCD suggestion I posted?
Just as a quick test:
static u32 hash_conntrack(struct ct_key *key)
{
 return
   0x47441DFB * key->sip
   + 0x57655A7D * key->dip
   + 0x1C7F1D2D * key->sport
   + 0xDF91D738 * key->dport
   + key->proto;

coefficients chosen at random from [0, 2^32)

# time ./cttest -u -f ../ip_conntrack.2 -s 131073
filename: ../ip_conntrack.2
hash function: original
number of buckets: 131073
maximum bucket list length: 5
total number of entries: 32866
Count	Length	CT
1	5	0.02%
15	4	0.20%
253	3	2.51%
3180	2	21.86%
25682	1	100.00%
101942	0	100.00%

Longest bucket with 131071 is also 5, with 131072 is 36 (as
advertised!).
