From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: conntrack hashing - ABCDEF
Date: Sat, 6 Jul 2002 14:13:24 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207062113.g66LDOV13922@isis.cs3-inc.com>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


No new theory, but some data collected with small modification
to cttest using originally posted data (no duplicates), -u.

 int A = 0x47441DFB,
   B = 0x57655A7D,
   C = 0x1C7F1D2D,
   D = 0xDF91D737,
   E = 0x2F6FE8DB,
   F = 0x39E5C2D7;

 static u32 hash_conntrack(struct ct_key *key)
 {
  return
    (A * key->sip
     + B * key->dip
     + C * key->sport
     + D * key->dport
     + E * key->proto) ^ F;

The columns 0-6 below correspond to left shifting A-F by that many
bits.  (Note they all start odd.)  Each entry in the table reports
the max bucket size for one run of cttest.

My conclusion from below is that it's probably fine to just
make the table size odd and choose A-F randomly.  


[total number of entries: 32866]
all table sizes approx 8K

For reference,
P(n) = probability that a given bucket is length n, 
E(n) = expected # buckets of length n
 n   P    E
 18 2e-7  .002
 17 1e-6  .008
 16 4e-6  .03
 15 2e-5  .14
 14 6e-5  .5
 13 2e-4  2


table size   A-F end with how many 0 bits        comment
             0     1     2    3    4    5    6

 -s 8192:    127   218   414			2^13

 -s 8160:    24    34    44   62   92		5 factors of 2

 -s 8176:    21    27    37   54		4 factors of 2

 -s 8184:    15    20    32   53		3 factors of 2
 -s 8200:    16    20

 -s 8188:    16    19    32   35		2 factors of 2
 -s 8196:    14    21

 -s 8190:    12    21    20			1 factor of 2
 -s 8194:    15    21    19

 -s 8189:    15    13    13   13   13   14   15 odd non-prime table sizes
 -s 8187:    14    12    14   15   15   14   15
 -s 8185:    13    12    14   13   15   14   15
 -s 8183:    13    13    12   12   13   14   16

 -s 8191:    13    14    14   16   12   13   14 prime table sizes
 -s 8179:    13    14    15   17   16   14   16
 -s 8171:    13    15    14   14   16   15   18
 -s 8209:    14    13    13   13   13   14   15  ... (see below) 38

E and F, btw do not much influence these numbers.
They're included to make it harder to attack.
A little more data with -s 8209:
If A-F are all left shifted 16, max bucket size is 38,
 only A-E are shifted 16 - 35
 only A-D are shifted 16 - 37
 only A-C are shifted 16 - 30
 only A-B are shifted 16 - 30
 only A shifted 16       - 20
