From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ip_tables: limit match: invalid size 40 != 48
Date: Fri, 18 Apr 2014 14:55:58 +0200 (CEST)
Message-ID: <alpine.LSU.2.11.1404181444250.27921@nerf08.vanv.qr>
References: <CAJsRc6irAg4WeP8EpY1Vk3ZVWnKPee1ab6j1-8jgy0cZyF21Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Ronny Janssen <ronny.janssen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:33343 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaDRMz7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 18 Apr 2014 08:55:59 -0400
In-Reply-To: <CAJsRc6irAg4WeP8EpY1Vk3ZVWnKPee1ab6j1-8jgy0cZyF21Ww@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2014-04-04 11:13, Ronny Janssen wrote:

>Hi,
>
>I'm running Linux 2.6.32.2 mips64 with 32bit userland iptables-1.4.18.

The iptables kernel code supports one native layout and, for 64-bit 
kernels, one compat layout. However, there are multiple ABIs one can use 
in userspace, and these ABIs make for a different layout, such as "OABI" 
vs "EABI" on ARM. There is something similar for MIPS.
The x32 ABI for x86(_64) might fall under it, too.
