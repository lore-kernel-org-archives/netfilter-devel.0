From: Patrick Schaaf <bof@bof.de>
Subject: Re: cttest-0.3 (conntrack hashing)
Date: Mon, 8 Jul 2002 22:05:24 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020708220524.V13116@oknodo.bof.de>
References: <20020708114504.CAF79473F@lists.samba.org> <15657.50484.842528.683308@isis.cs3-inc.com> <20020708192400.GA30970@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020708192400.GA30970@aaricia.hemmet.chalmers.se>; from gozem@aaricia.hemmet.chalmers.se on Mon, Jul 08, 2002 at 09:24:00PM +0200
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> big-endian machine:
> #uname -a 
> SunOS licia.dtek.chalmers.se 5.8 Generic_108528-14 sun4u sparc SUNW,Sun-Fire-280
> 
> http://www.dtek.chalmers.se/~d97gozem/cttest/0.4/
> 
> All graphs here look about equally good. I dont know if there is a bug
> somewhere in cttest that might do this. 

I don't think so. Thanks for the run. It seems like abcd does not show
detoriation at even table sizes, on big endian systems. To confirm
this, I just added ntohl/ntohs to the abcd hash, and it really comes
out nicely.

Don, hope this helps your analysis.

static u32 hash_abcd_host(struct ct_key *key)
{
        u32 res;
PER_HASH_TIMER_1(
        res = 0x47441DFB * ntohl(key->sip)
        + 0x57655A7D * ntohl(key->dip)
        + 0x1C7F1D2D * ntohs(key->sport)
        + 0xDF91D738 * ntohs(key->dport)
        + key->proto;
);
        return res;
}

Slightly surprising, this code runs about half as fast as the normal abcd,
on my little endian box.

best regards
  Patrick
