From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/6] netfilter: kconfig: NFQUEUE is useless without NETFILTER_NETLINK_QUEUE
Date: Tue, 18 Jan 2011 15:18:38 +0100
Message-ID: <4D35A13E.5000808@trash.net>
References: <1295183947-12786-1-git-send-email-fw@strlen.de> <1295183947-12786-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56489 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751229Ab1AROSi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Jan 2011 09:18:38 -0500
In-Reply-To: <1295183947-12786-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16.01.2011 14:19, Florian Westphal wrote:
> NFLOG already does the same thing for NETFILTER_NETLINK_LOG.

Applied, thanks.
