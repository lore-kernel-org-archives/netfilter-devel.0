From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf-next: TEE/reentrancy 20100407
Date: Fri, 9 Apr 2010 11:39:50 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1004091139330.17365@obet.zrqbmnf.qr>
References: <1270666217-27670-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:37682 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757296Ab0DIJjw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:39:52 -0400
In-Reply-To: <1270666217-27670-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-04-07 20:50, Jan Engelhardt wrote:
>
>Jan Engelhardt (6):
>      netfilter: ipv6: move POSTROUTING invocation before fragmentation
>      netfilter: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
>      netfilter: xtables: inclusion of xt_TEE
>      netfilter: xtables2: make ip_tables reentrant
>      netfilter: xt_TEE: have cloned packet travel through Xtables too
>      netfilter: xtables: remove old comments about reentrancy

Is this submission ok?
