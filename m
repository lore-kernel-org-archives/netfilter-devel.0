From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: cttest-0.1
Date: Sun, 7 Jul 2002 00:41:09 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020706224109.GH3729@aaricia.hemmet.chalmers.se>
References: <20020705165354.GD3729@aaricia.hemmet.chalmers.se> <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com> <20020706091259.F13116@oknodo.bof.de> <20020706172342.H13116@oknodo.bof.de> <20020706211451.GG3729@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020706211451.GG3729@aaricia.hemmet.chalmers.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-07-06 23:14:51+0200, Joakim Axelsson <gozem@aaricia.hemmet.chalmers.se> ->
>
> Me and Martin Josefsson has tested the new cttest-0.2. Martin also took the
> idea of using the hash-function that the routingcache uses in Linux:
> 

Some more on this issue. Martin discovered that changing "res ^= (res >>
16);" into "res ^= (res >> 24);" gave a much better result. Actually better
than any of the hash-functions we have. To the smalest calculation price.
The somewhat bad distribution on 2^n hashsizes has now vanished.

Now to make it even more impossible to attack I added a A,B factor to it:
"res ^= A ^ B;" Same A and B as in abcd*

static u32 hash_rt_ab(struct ct_key *key)
{
 	u32 res;

 	PER_HASH_TIMER_1(       
 	  	res = ((key->dip & 0xF0F0F0F0) >> 4) | ((key->dip & 0x0F0F0F0F) << 4);
 	  	res ^= key->sip ^ key->proto;  
 	  	res ^= key->dport ^ key->sport;
 	  	res ^= 0x47441DFB ^ 0x57655A7D;
 	  	res ^= (res >> 24);
 	  	res ^= (res >> 8);
 	);
 	
 	return res;
}

This addition of A,B only adds 2 more cycles on my CPU (from about 20 to
about 22). In my believe is this hashfunction what we are looking for. Two
random constanst makes sure that a studied attack can't fill just any
bucket, not knowing which one as might be possible with only one random
constant.

I also tested Don's abcdef. Conclusion is that abcdef is about the same as
abcd or worse and takes longer time to caluclate. From about 22 to about 25. On my
test-data. It still has a bad distribution on 2^n hashsizes.


Results are from my calculations:
http://aaricia.hemmet.chalmers.se/~gozem/cttest-0.2/rt_ab/


And from Martin who did test alot of attacking tools against his lab-router:
Look at each index.html to what type of attack it was.

http://gandalf.hjorten.nu/cttest/kna-gw-rt24-rt_ab-abcdef/
http://gandalf.hjorten.nu/cttest/labbrouter-172000-randip-randport-rt24-rt_ab-abcdef/
http://gandalf.hjorten.nu/cttest/labbrouter-172000-same-rt24-rt_ab-abcdef/


The modified cttest.c we have used can be found at:
http://aaricia.hemmet.chalmers.se/~gozem/cttest-0.2/cttest.c

-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
