From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: cttest-0.1
Date: Sun, 7 Jul 2002 00:54:56 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020706225456.GI3729@aaricia.hemmet.chalmers.se>
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
> Also with this idea of using power of (^), we tested the abcd hash using
> power of instead of just adding the values up:
> 
> static u32 hash_abcd_power(struct ct_key *key)
> {
>         u32 res;
> 
>         PER_HASH_TIMER_1(
>                 res = (0x47441DFB * key->sip)
>                 ^ (0x57655A7D * key->dip)
>                 ^ (0x1C7F1D2D * key->sport)
>                 ^ (0xDF91D738 * key->dport)
>                 ^ key->proto;
>         );
>         return res;
> }
> 

Oops. ^ is xor in C, not "power of". Hehe, thinking in too much mathemaical
terms here. Guess that tells you that we really dont know what we're doing.
Anyhow. Our rt_ab seams to be very good, thats what matters :-)

-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
