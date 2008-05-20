From: David Miller <davem@davemloft.net>
Subject: Re: include/linux/netfilter.h after make headers_install is
 incomplete
Date: Tue, 20 May 2008 14:21:21 -0700 (PDT)
Message-ID: <20080520.142121.15017166.davem@davemloft.net>
References: <a27c0c970805161521k332fba8cg808d52396b5cdce5@mail.gmail.com>
	<a27c0c970805201139i38e12d15ue807fc0239b1c10e@mail.gmail.com>
	<a27c0c970805201144j12189201g9567460d4d3d8361@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org
To: greg@nest.cx
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57006
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756729AbYETVVZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 20 May 2008 17:21:25 -0400
In-Reply-To: <a27c0c970805201144j12189201g9567460d4d3d8361@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: "Greg Steuck" <greg@nest.cx>
Date: Tue, 20 May 2008 11:44:56 -0700

> I asked this on netfilter list, but it doesn't seem to be generating any
> interest there. Maybe the question belongs on this list?

No, it does not.  netfilter-devel@vger.kernel.org is the correct place
to discuss this, added to CC:.

Perhaps you sent this to plain "netfilter@vger.kernel.org" or the
older lists which are no longer in use.

> I ran make headers_install in 2.6.25 tree and the installed netfilter.h is
> not complete. Namely, it declares
> union nf_inet_addr {
>       __u32           all[4];
>       __be32          ip;
>       __be32          ip6[4];
> ...
> }
> 
> The __u32, __be32 types are declared in <linux/types.h> and the #include
> directive is removed by the installation process. This in turn makes some
> applications unbuildable against such an exported tree, e.g.
> 
> busybox-1.10.1/networking/tcpudp.c:#include <linux/netfilter_ipv4.h>
> 
> If I correctly understand the purpose of make headers_install, it is
> supposed to generate an API for applications. I could certainly
> make tcpudp.c include linux/types.h, but given that the application
> does not even use nf_inet_addr, this would be the wrong place for
> the fix.
> 
> Is kernel the right place then?
> 
> Thanks
> Greg
> --
> nest.cx is Gmail hosted, use PGP for anything private. Key:
> http://tinyurl.com/ho8qg
> Fingerprint: 5E2B 2D0E 1E03 2046 BEC3  4D50 0B15 42BD 8DF5 A1B0
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
