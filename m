From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH xt-addons] xt_psd: avoid crash due to curr->next
 corruption
Date: Wed, 18 Apr 2012 14:30:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204181430370.23312@frira.zrqbmnf.qr>
References: <1334751208-10387-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40046 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735Ab2DRMaq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:30:46 -0400
In-Reply-To: <1334751208-10387-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-04-18 14:13, Florian Westphal wrote:

>curr->ports[] is of size SCAN_MAX_COUNT - 1, so under certain
>conditions we wrote past end of array, corrupting ->next pointer
>of the adjacent host entry.

Processed.
