From: Patrick McHardy <kaber@trash.net>
Subject: Re: src: remove inclusion of iptables.h
Date: Thu, 20 Nov 2008 10:16:37 +0100
Message-ID: <49252AF5.2050706@trash.net>
References: <alpine.LNX.1.10.0811181931161.2316@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53654 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYKTJQo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:16:44 -0500
In-Reply-To: <alpine.LNX.1.10.0811181931161.2316@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> commit 4ea9c024eee8b8bf7167b450ce2317ce7c620d08
> Author: Jan Engelhardt <jengelh@medozas.de>
> Date:   Tue Nov 18 19:28:53 2008 +0100
> 
> src: remove inclusion of iptables.h
> 
> iptables.h and ip6tables.h only include declarations internal to
> iptables (specifically iptables.c and ip6tables.c), as most of the
> public API has been moved to xtables.h a few months ago.

Applied, thanks Jan.
