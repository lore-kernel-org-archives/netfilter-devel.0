From: gozem@aaricia.hemmet.chalmers.se (Joakim Axelsson)
Subject: Re: cttest-0.1
Date: Fri, 5 Jul 2002 18:53:54 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020705165354.GD3729@aaricia.hemmet.chalmers.se>
References: <15644.45834.373409.220647@isis.cs3-inc.com> <20020702144048.GM18333@naboo.rchrd.phub.net.cable.rogers.com> <20020702183242.E7684@oknodo.bof.de> <20020702183547.F7684@oknodo.bof.de> <15649.59247.55523.824241@isis.cs3-inc.com> <20020702203117.G7684@oknodo.bof.de> <20020702235206.H7684@oknodo.bof.de> <20020703041502.GH20570@aaricia.hemmet.chalmers.se> <20020705161028.GB3729@aaricia.hemmet.chalmers.se> <20020705185415.A13116@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
Content-Disposition: inline
In-Reply-To: <20020705185415.A13116@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

2002-07-05 18:54:15+0200, Patrick Schaaf <bof@bof.de> ->
> 
> - make the hash bucket count at least individible by 2. This should go
>   as a strong suggestion into the documentation, and should be implemented
>   in the default initialization code. Anybody volunteering for one or
>   the other? I'll do the code part, but I won't do the docs.

Well, I think we even can force people to use an odd count.

if (hashsize%2 == 0)
	hashsize--;


-- 
/Joakim Axelsson A.K.A Gozem@EFnet & OPN
