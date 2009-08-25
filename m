From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/6] netfilter: xtables: consolidate table hook
 functions
Date: Tue, 25 Aug 2009 17:50:58 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0908241614370.6695@fbirervta.pbzchgretzou.qr>
References: <1249931992-18761-1-git-send-email-jengelh@medozas.de> <1249931992-18761-2-git-send-email-jengelh@medozas.de> <4A928D3A.1000502@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:41965 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830AbZHYPu5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Aug 2009 11:50:57 -0400
In-Reply-To: <4A928D3A.1000502@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-08-24 14:53, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> For a following patch in this series ("generate nf hook ops on
>> demand"), we will be requiring that a single hook entry function per
>> table does the processing. Would this not be done would I need to
>> pass multiple hook functions as arguments in that later patch, which
>> would have been not so nice.
>
>Removing duplicates is fine of course, but I don't like the
>"consolidation" of multiple different hook functions very much.
>You're trading more runtime overhead (admittedly not that much,
>but those functions are heavily used)

Heavily? Most systems run the initialization exactly once.

>The second problem is that your automatically generated hook ops
>can't even represent all the cases we have since some tables
>actually do use different priorities for the different hooks.

I never claimed it was a fits-it-all solution. The nat table
still has its original scheme.

>And I'm not sure where the memory savings you claim should come
>from, the hook ops are still required at runtime.

Hm, true. That's why someone is supposed to look over them :>
