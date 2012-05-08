From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] libxt_hashlimit: add support for byte-based operation
Date: Tue, 8 May 2012 15:31:30 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1205081523540.6920@frira.vanv.qr>
References: <1336483012-12169-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:49358 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753991Ab2EHNbd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 May 2012 09:31:33 -0400
In-Reply-To: <1336483012-12169-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-05-08 15:16, Florian Westphal wrote:

> I've re-used the existing options. For example,
> --hashlimit-mode srcip,dstip,srcport,dstport --hashlimit\-above 512kb/s would
> match when the flow exceeded 512kbytes per second.
>
> Similarily, the --hashlimit-burst parameter now either a number (packetcount)
> number, or a "byte" suffix, e.g. "--hashlimit-burst 1mb".
>
> If you believe that we should introduce new options instead, please
> let me know and I'll re-spin the patch.

libxt_rateest also deals with rate suffixes, so it would seem to be 
worthwhile to investigate a new option type.
