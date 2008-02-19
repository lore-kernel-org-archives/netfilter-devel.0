From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 1/3] xt_sctp: simplify xt_sctp.h
Date: Tue, 19 Feb 2008 13:48:01 +0100
Message-ID: <47BAD001.9050807@trash.net>
References: <Pine.LNX.4.64.0802061453480.23855@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0802061456450.23855@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:47064 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752661AbYBSMsX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:48:23 -0500
In-Reply-To: <Pine.LNX.4.64.0802061456450.23855@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit be0be37421ec037ffcffa9feaf5c561f405ee3dd
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Tue Jan 29 16:53:31 2008 +0100
> 
>     [NETFILTER]: xt_sctp: simplify xt_sctp.h
>     
>     The use of xt_sctp.h flagged up -Wshadow warnings in userspace, which
>     prompted me to look at it and clean it up. Basic operations have been
>     directly replaced by library calls (memcpy, memset is both available
>     in the kernel and userspace, and usually faster than a self-made
>     loop). The is_set and is_clear functions now use a processing time
>     shortcut, too.


Please resend this once I open my 2.6.26 tree, we're too late
in 2.6.25 for cleanups.
