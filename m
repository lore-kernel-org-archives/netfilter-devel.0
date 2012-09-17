From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 05/11] xt_psd: remove unneeded variables
Date: Mon, 17 Sep 2012 04:57:35 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209170453550.13524@nerf07.vanv.qr>
References: <1347830995-19226-1-git-send-email-fw@strlen.de> <1347830995-19226-6-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34725 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752806Ab2IQC5i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 22:57:38 -0400
In-Reply-To: <1347830995-19226-6-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2012-09-16 23:29, Florian Westphal wrote:
>
>- dest port and dest address were only written, never read
>- struct inaddr isn't needed either, just look at iph->saddr


I have applied 01..04, with some redactional changes (diff 
975f017..093f3b0).


>-static inline int hashfunc(struct in_addr addr)
>+static unsigned int hashfunc(__be32 addr)

You are changing the type of hash here. While I concur with using an 
unsigned quantity for a hash value, this is not done consistenly - there 
are some (signed) "int hash"s left in the code. Can I get a patch that 
rectifies this consistently across the entire .c file as well?


BTW, does the _10 in your branch name have any significance? :)
