From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 12/13] Add all necessary header files - compilation fix
 for various cases
Date: Sun, 13 Apr 2008 07:21:50 +0200
Message-ID: <4801986E.9070500@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <0b061f76d73e268a7dd95d036235812728b9c120.1207813085.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33379 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751007AbYDMFVz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:21:55 -0400
In-Reply-To: <0b061f76d73e268a7dd95d036235812728b9c120.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Allow iptables to compile without a kernel source tree. This
> implies fixing build for older kernels, such as 2.6.17 which
> lack xt_SECMARK.h.

Which version are these headers based on?

> --- /dev/null
> +++ b/include/linux/compiler.h
> @@ -0,0 +1,179 @@

> +#ifdef __KERNEL__

Sanitized headers please. compiler.h seems wrong to include in
iptables, which parts do we actually need?
