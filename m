From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables-restore: fix segmentation fault with -tanything
Date: Mon, 04 Aug 2008 12:51:50 +0200
Message-ID: <4896DF46.9070605@trash.net>
References: <alpine.LNX.1.10.0808031501080.27230@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51416 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648AbYHDKvv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 06:51:51 -0400
In-Reply-To: <alpine.LNX.1.10.0808031501080.27230@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit e075edd231346496d9e93477704a74c9c664bfc7
> Author: Michael Spang <mspang@uwaterloo.ca>
> Date:   Sun Aug 3 15:00:26 2008 -0400
> 
> iptables-restore: fix segmentation fault with -tanything
> 
> Reference: Debian bug #458042
> 
> iptables-restore must not pass a table into do_command. It checks for
> "-t arg" and "--table arg", but not "-targ". (On a related note,
> using -targ does not work as expected).
> 
> This should fail gracefully, but crashes:
> 
> 	iptables-restore <(echo -e '*filter\n-A INPUT -tx\nCOMMIT')
> 
> And this should use table "filter", or perhaps raise an error, but
> instead sets the table to (literally) "-tfilter":
> 
> 	iptables -tfilter -A INPUT


Applied, thanks.
