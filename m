From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter: nf_conntrack: show helper and class in
 /proc/net/nf_conntrack_expect
Date: Wed, 20 Jan 2010 20:37:15 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1001202037020.8723@obet.zrqbmnf.qr>
References: <20100120191824.25922.36663.sendpatchset@x2.localnet> <20100120191826.25922.78583.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, flo@degnet.de, madduck@debian.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52358 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab0ATThQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2010 14:37:16 -0500
In-Reply-To: <20100120191826.25922.78583.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-01-20 20:18, Patrick McHardy wrote:

>commit 8a96ae7fda648925254899ad997d5fe3984d3cf6
>Author: Patrick McHardy <kaber@trash.net>
>Date:   Wed Jan 20 17:38:16 2010 +0100
>
>    netfilter: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect
>    
>    Make the output a bit more informative by showing the helper an expectation
>    belongs to and the expectation class.
>    
>    Signed-off-by: Patrick McHardy <kaber@trash.net>

Should not we extend on conntrack(8) instead?

