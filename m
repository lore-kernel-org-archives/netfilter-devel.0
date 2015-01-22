From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Funny iptables -L output with 0.0.0.3 netmask
Date: Thu, 22 Jan 2015 13:31:33 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1501221301420.5184@nerf60.vanv.qr>
References: <5101724.aeQA8Siq95@rofl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Patrick Schaaf <netdev@bof.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares60.inai.de ([5.9.23.85]:36806 "EHLO ares60.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803AbbAVMbf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2015 07:31:35 -0500
In-Reply-To: <5101724.aeQA8Siq95@rofl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2015-01-22 12:14, Patrick Schaaf wrote:
>
>just noticed something funny with "iptables -L" - was always fine in the past, 
>e.g. with iptables 1.4.10, but now on a box with iptables 1.4.19 (opensuse 
>13.1) I see a funny thing.
>
>iptables -A somewhere -s 0.0.0.1/0.0.0.3 -j ACCEPT
>ACCEPT     all  --  0.0.0.1/-1           anywhere

>Sorry if this is known + maybe already fixed in newer iptables versions...


commit 03e227017cca4f6d62a434bbaacf07e2869775b9
Author: Phil Oester <kernel@linuxace.com>
Date:   Thu Sep 26 09:06:58 2013 -0700

    libxtables: xtables_ipmask_to_numeric incorrect with non-CIDR masks


Wonder if it's really worth sending an update to 13.1.
