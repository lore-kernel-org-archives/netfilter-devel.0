From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 13/27] xt_helper: Do not bypass RCU
Date: Fri, 04 Jan 2008 16:01:42 +0100
Message-ID: <477E4A56.20601@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022128550.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48919 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYADPEo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 10:04:44 -0500
In-Reply-To: <Pine.LNX.4.64.0801022128550.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 6c922317906546b99afe859faa0c15d46d79dd37
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Wed Jan 2 18:00:29 2008 +0100
> 
>     [NETFILTER]: xt_helper: Do not bypass RCU
>     
>     Use the @helper variable that was just obtained.

Applied for 2.6.24, I hope that doesn't cause clashes with the
following patches.
