From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: cttest-0.3 (conntrack hashing)
Date: Mon, 8 Jul 2002 21:24:00 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020708192400.GA30970@aaricia.hemmet.chalmers.se>
References: <20020708114504.CAF79473F@lists.samba.org> <15657.50484.842528.683308@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <15657.50484.842528.683308@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I analyzed the part res ^= (res >> 24); res ^= (res >> 8); a little more in
the rt_hash. What it really does is that it applies the hi bits in the 32bit
integer on the low ones. This means that we wont just throw them away when
we apply the %-operation on it. This is what keeps the good distribution. So
i just added those two line to abcd (and got abcd_rt). Showed up to be very
good:

http://aaricia.hemmet.chalmers.se/~gozem/cttest/0.4/

And specially:
http://aaricia.hemmet.chalmers.se/~gozem/cttest/0.4/1abcd/sizes.262143.html

The hashfunction:
static u32 hash_abcd_rt(struct ct_key *key)
{
        u32 res;
PER_HASH_TIMER_1(
        res = 0x47441DFB * key->sip
        + 0x57655A7D * key->dip
        + 0x1C7F1D2D * key->sport
        + 0xDF91D738 * key->dport
        + key->proto;
        res ^= (res >> 24);
        res ^= (res >> 8);
                
);
        return res;
}



Since we wanted to try other architectures than x86 i tried to run the
calculations on my school that has SUN and solaris. After much trixing with
the cttest-0.4 scripts and program (since they were clearly not Solaris
compatible) i managed to get some results. Without the timing of the
function since that part was Linux specific. Atleast this is a test on a
big-endian machine:

#uname -a 
SunOS licia.dtek.chalmers.se 5.8 Generic_108528-14 sun4u sparc SUNW,Sun-Fire-280

http://www.dtek.chalmers.se/~d97gozem/cttest/0.4/

All graphs here look about equally good. I dont know if there is a bug
somewhere in cttest that might do this. 



                


-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
