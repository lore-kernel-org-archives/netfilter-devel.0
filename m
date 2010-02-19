From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons: make ipv6 optional for RAWNAT and SYSRQ
Date: Fri, 19 Feb 2010 14:14:38 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002191411280.17165@obet.zrqbmnf.qr>
References: <1266580375.26314.6.camel@tablet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Peter Volkov <peter.volkov@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36478 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752062Ab0BSNOl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Feb 2010 08:14:41 -0500
In-Reply-To: <1266580375.26314.6.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-02-19 12:52, Peter Volkov wrote:

>Hi, in case kernel was built without ipv6 support xt_RAWNAT and xt_SYSRQ
>fail to load with unknown symbols. Patches in attachment fix this issue.
>Please, apply.

For ip6table_rawpost, we could probably do this in the Kbuild file:

ifneq (${CONFIG_IPV6},)
obj-${build_RAWNAT} += ip6table_rawpost.o
endif

Can you test?


For the second patch, I would suggest to move around the structures in 
rawnat_tg_reg to reduce the number of #ifdefs needed.
