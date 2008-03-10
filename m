From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_time: fix failure to match on Sundays
Date: Mon, 10 Mar 2008 17:31:59 +0100
Message-ID: <47D5627F.30209@trash.net>
References: <Pine.LNX.4.64.0803061516300.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Andrew Schulman <andrex@alumni.utexas.net>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep31-int.chello.at ([62.179.121.49]:58555 "EHLO
	viefep31-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYCJQcW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:32:22 -0400
In-Reply-To: <Pine.LNX.4.64.0803061516300.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Should go in for 2.6.25, and 2.6.24-stable.
> 
> ===
> commit 4a0883a28ade0ce4837aa6f3f692f8180ad3a264
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Thu Mar 6 15:10:54 2008 +0100
> 
>     [NETFILTER]: xt_time: fix failure to match on Sundays

Applied, thanks.
