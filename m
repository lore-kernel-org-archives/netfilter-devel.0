From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] NFQUEUE: add v2 revision with --queue-bypass option
Date: Thu, 20 Jan 2011 11:28:27 +0100
Message-ID: <4D380E4B.7090301@trash.net>
References: <1295184561-13320-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33209 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755361Ab1ATK22 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:28:28 -0500
In-Reply-To: <1295184561-13320-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 16.01.2011 14:29, schrieb Florian Westphal:
> --queue-bypass: if no userpace program is listening on the queue, then
> allow packets to continue through the ruleset instead of dropping them.
> 

Applied, thanks Florian.
