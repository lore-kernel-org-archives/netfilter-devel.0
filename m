From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: cttest-0.1
Date: Sun, 7 Jul 2002 07:46:07 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020707054607.GL3729@aaricia.hemmet.chalmers.se>
References: <20020706224109.GH3729@aaricia.hemmet.chalmers.se> <20020705165354.GD3729@aaricia.hemmet.chalmers.se> <53889.203.134.158.15.1025935801.squirrel@iw.k1k2.com> <20020706091259.F13116@oknodo.bof.de> <20020706172342.H13116@oknodo.bof.de> <20020706211451.GG3729@aaricia.hemmet.chalmers.se> <20020706224109.GH3729@aaricia.hemmet.chalmers.se> <5.1.0.14.0.20020707013649.00bfce68@sss.dnsalias.net> <20020707042341.GK3729@aaricia.hemmet.chalmers.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Svenning Sorensen <sss@sss.dnsalias.net>,
	Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Content-Disposition: inline
In-Reply-To: <20020707042341.GK3729@aaricia.hemmet.chalmers.se>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-07-07 06:23:41+0200, Joakim Axelsson <gozem@aaricia.hemmet.chalmers.se> ->
> 
> res = ((key->sip & 0xF0F0F0F0) >> 4) | ((key->sip & 0x0F0F0F0F) << 4);
> res *= 0x47441DFB;
> res ^= key->dip ^ key->proto;
> res ^= (key->dport << 16) ^ key->sport;
> res *= 0x57655A7D;
> res ^= (res >> 24);
> res ^= (res >> 8);
> 
> I think this solution will make the two random constanst enough independent
> to make it impossible to attack one, any, bucket. Better solutions on the
> two constants are welcome.
> 

It can still be calculated backwards to attack i think. However leting one
constant multiply (the first) and one xor should make it harder to attack
one any bucket. It even gives a slightly better distribution and removing
one muliplication is good. I also made an or of the ports. Makes no
difference but in reading.

res = ((key->sip & 0xF0F0F0F0) >> 4) | ((key->sip & 0x0F0F0F0F) << 4);
res *= 0x47441DFB;
res ^= key->dip ^ key->proto;
res ^= ((key->dport << 16) | key->sport);
res ^= 0x57655A7D;
res ^= (res >> 24);
res ^= (res >> 8); 

Now someone else have to take a look at it. I digged my head into a corner.

-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
