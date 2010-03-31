From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] netfilter: xtables: merge registration structure to
 NFPROTO_UNSPEC
Date: Wed, 31 Mar 2010 12:11:44 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1003311157050.11710@obet.zrqbmnf.qr>
References: <1270022629-2494-1-git-send-email-jengelh@medozas.de> <1270022629-2494-5-git-send-email-jengelh@medozas.de> <4BB30861.3060101@trash.net> <alpine.LSU.2.01.1003311036110.4527@obet.zrqbmnf.qr> <4BB30AA0.9000904@trash.net>
 <alpine.LSU.2.01.1003311052490.6475@obet.zrqbmnf.qr> <4BB30F63.2030509@trash.net> <alpine.LSU.2.01.1003311105290.7837@obet.zrqbmnf.qr> <4BB31127.7010409@trash.net> <alpine.LSU.2.01.1003311109310.7837@obet.zrqbmnf.qr> <4BB319AB.8060306@trash.net>
 <alpine.LSU.2.01.1003311146590.11133@obet.zrqbmnf.qr> <4BB31C4A.2070209@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38620 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933172Ab0CaKLq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:11:46 -0400
In-Reply-To: <4BB31C4A.2070209@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-31 11:56, Patrick McHardy wrote:
>
>What I'd like a lot more would be if ebtables could run
>conntrack/NAT and other useful modules directly so we could get rid
>of most of "integration" mess. Not sure if that's really possible
>though.

I do belive that it is possible. To that end, I had already posted a
patchset last October (and that is now slowly being poured into
nf-next) that would provide us with protocol-agnostic tables, a
welcome (and perhaps even necessary) prerequisite. From there on, it
should only be a small step in ensuring that same hooks don't get
called multiple times anymore.
