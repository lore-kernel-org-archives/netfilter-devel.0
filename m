From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: cttest-0.1
Date: Sat, 6 Jul 2002 23:14:51 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020706211451.GG3729@aaricia.hemmet.chalmers.se>
References: <20020705165354.GD3729@aaricia.hemmet.chalmers.se> <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com> <20020706091259.F13116@oknodo.bof.de> <20020706172342.H13116@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020706172342.H13116@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-07-06 17:23:42+0200, Patrick Schaaf <bof@bof.de> ->
> Hi all,
> 
> I have released http://bei.bof.de/cttest-0.2.tar.gz. It is now easier
> to modify the list of sizes and hashes that should be plotted, and
> there's timing code for the hash functions, together with average
> used list length analysis.
> 

Me and Martin Josefsson has tested the new cttest-0.2. Martin also took the
idea of using the hash-function that the routingcache uses in Linux:

res = ((key->dip & 0xF0F0F0F0) >> 4) | ((key->dip & 0x0F0F0F0F) << 4);
res ^= key->sip ^ key->tos;
res ^= (res >> 16);
res ^= (res >> 8););

Together we tried to make one that fitted for conntrack. Since we don't
understand completly why the things are done as they are, there might be
some more tuning where can be done to this function:

static u32 hash_rt(struct ct_key *key)
{
        u32 res;

        PER_HASH_TIMER_1(       
                res = ((key->dip & 0xF0F0F0F0) >> 4) | ((key->dip & 0x0F0F0F0F) << 4);
                res ^= key->sip ^ key->proto;
                res ^= key->dport ^ key->sport;
                res ^= (res >> 16);
                res ^= (res >> 8);
        );
        
        return res;
}

Also with this idea of using power of (^), we tested the abcd hash using
power of instead of just adding the values up:

static u32 hash_abcd_power(struct ct_key *key)
{
        u32 res;

        PER_HASH_TIMER_1(
                res = (0x47441DFB * key->sip)
                ^ (0x57655A7D * key->dip)
                ^ (0x1C7F1D2D * key->sport)
                ^ (0xDF91D738 * key->dport)
                ^ key->proto;
        );
        return res;
}

Results can be viewed at the following url with my 85K entry conntrack:
http://aaricia.hemmet.chalmers.se/~gozem/cttest-0.2/rt/

Conculsions are that the rt-hash is just as fast as abcd and has a good
distribusion, even on the 2^n hash-sizes. This concludes us and with the
fact that we are going to use prime-hashsizes that this rt-hash is the best
alternitive we have right now. rt uses about 21 cycles on my CPU and abcd
about 22. crc32 is up on 134.

The tests was computed on my (Dual) Athlon MP 1800+ (1533Mhz), with ECC/REG
DDR266 memory. Ofcouse only using one CPU.

For the test of your prime.c I can't say more than its not even measureable
on my computer. But I got a very fast CPU.

>time ./prime 3457675589
3457675579
0.000u 0.000s 0:00.00 0.0%	0+0k 0+0io 87pf+0w


-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
