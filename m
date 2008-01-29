From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/5][IPTABLES]: Import netfilter.h
Date: Tue, 29 Jan 2008 15:31:01 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801291528180.1185@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr>
 <479F25DF.6080204@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35386 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763543AbYA2ObE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:31:04 -0500
In-Reply-To: <479F25DF.6080204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 29 2008 14:10, Patrick McHardy wrote:
>Subject: Re: [PATCH 1/5][IPTABLES]: Import netfilter.h
>
> Jan Engelhardt wrote:
>> Import netfilter.h from kernel to get hold of union nf_inet_addr
>> and fix a compile error in current iptable tarball releases when
>> used with non-development kernels.
>
> We already have this exact file in the current sources, without
> the #ifdef __KERNEL__ parts.
>

Where? If you mean the sanitized headers in 
/usr/include/linux/netfilter.h -- this file is outdated and does not 
ship the nf_inet_addr definition.

Since we copy all xt_{match,target}*.h header files too, I thought doing 
the same for netfilter.h is ok.

I do believe it is, because the sanitized headers in 
/usr/include/linux/netfilter/ are _also_ out-of-date.
BTW, could we, perhaps, remove headers-y for 
/usr/include/linux/netfilter/, since iptables ships it anyway?
