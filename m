From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: cttest-0.1
Date: Sun, 7 Jul 2002 01:16:28 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020706231628.GJ3729@aaricia.hemmet.chalmers.se>
References: <20020705165354.GD3729@aaricia.hemmet.chalmers.se> <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com> <20020706091259.F13116@oknodo.bof.de> <20020706172342.H13116@oknodo.bof.de> <20020706211451.GG3729@aaricia.hemmet.chalmers.se> <20020706224109.GH3729@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020706224109.GH3729@aaricia.hemmet.chalmers.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-07-07 00:41:09+0200, Joakim Axelsson <gozem@aaricia.hemmet.chalmers.se> ->
> 
> Now to make it even more impossible to attack I added a A,B factor to it:
> "res ^= A ^ B;" Same A and B as in abcd*
> 
> static u32 hash_rt_ab(struct ct_key *key)
> {
>  	u32 res;
> 
>  	PER_HASH_TIMER_1(       
>  	  	res = ((key->dip & 0xF0F0F0F0) >> 4) | ((key->dip & 0x0F0F0F0F) << 4);
>  	  	res ^= key->sip ^ key->proto;  
>  	  	res ^= key->dport ^ key->sport;
>  	  	res ^= 0x47441DFB ^ 0x57655A7D;
>  	  	res ^= (res >> 24);
>  	  	res ^= (res >> 8);
>  	);
>  	
>  	return res;
> }
> 

I guess you all are begining to get a little tired of my mails :-). Anyhow
on our little misstake what ^ really does in C (should have known better
:-). I guess I seldom use xor in my c-code.) res ^= 0x47441DFB ^ 0x57655A7D
is kinda of useless then. So I changed it into:

res = ((key->dip & 0xF0F0F0F0) >> 4) | ((key->dip & 0x0F0F0F0F) << 4);
res ^= key->sip ^ key->proto;
res ^= key->dport ^ key->sport;
res ^= 0x47441DFB;
res ^= (res >> 24);
res ^= (res >> 8);
res ^= 0x57655A7D;

Results:
http://aaricia.hemmet.chalmers.se/~gozem/cttest-0.2/rt_ab_xor/

New cttest.c (same url as before):
http://aaricia.hemmet.chalmers.se/~gozem/cttest-0.2/cttest.c

-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
