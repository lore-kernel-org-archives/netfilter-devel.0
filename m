From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [xtables-addons-1.47.1] compilation failed - compat_xtables.c:633:
 error: too few arguments to function ipv6_find_hdr
Date: Thu, 26 Dec 2013 22:33:31 +0100 (CET)
Message-ID: <alpine.LSU.2.11.1312262204160.20434@nerf08.vanv.qr>
References: <41F4D5ABA9054FE4A2A4ED721C046297@torbaf407ff5ef>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: remoteshaman.com@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:41949 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751525Ab3LZVka (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Dec 2013 16:40:30 -0500
In-Reply-To: <41F4D5ABA9054FE4A2A4ED721C046297@torbaf407ff5ef>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2013-12-24 06:35, remoteshaman.com@gmail.com wrote:

> Hello!
>
> compilation failed in CentOS: 2.6.32-431.1.2.0.1.el6.x86_64 -
> compat_xtables.c:633: error: too few arguments to function ipv6_find_hdr

Redhat kernels have a different, incompatible API that does
not match.

