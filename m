From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: fix - mistake to pass a pointer where
 array is required
Date: Thu, 18 Oct 2007 11:01:13 +0200
Message-ID: <471720D9.5030901@trash.net>
References: <470F09EF.9080606@cn.fujitsu.com> <47130392.60902@trash.net> <47133A5B.2020407@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: lizf <lizf@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64464 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814AbXJRJBh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:01:37 -0400
In-Reply-To: <47133A5B.2020407@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

lizf wrote:
> Sorry for the noise, I've configed my mailer according to a kernel doc,
> but i'm still not sure whether it works. So here's the attachment.
> 

Thanks, the attachment applies fine, but does not compile:


   CC [M]  net/netfilter/xt_sctp.o
net/netfilter/xt_sctp.c: In function 'match_packet':
net/netfilter/xt_sctp.c:60: error: 'chunkmap' undeclared (first use in 
this function)
net/netfilter/xt_sctp.c:60: error: (Each undeclared identifier is 
reported only once
net/netfilter/xt_sctp.c:60: error: for each function it appears in.)
make[1]: *** [net/netfilter/xt_sctp.o] Error 1
make: *** [net/netfilter/xt_sctp.o] Error 2

The SCTP_CHUNKMAP_COPY uses "chunkmap" internally. What tree did
you base this patch on?
