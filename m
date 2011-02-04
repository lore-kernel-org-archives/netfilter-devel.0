From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] bridge: add new target NFQUEUE for ebtables
Date: Fri, 04 Feb 2011 14:25:16 +0100
Message-ID: <4D4BFE3C.3060407@trash.net>
References: <4D49E1E0.50304@trash.net> <1296743540-8148-4-git-send-email-chifflier@edenwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pierre Chifflier <chifflier@edenwall.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46615 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752423Ab1BDNZb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:25:31 -0500
In-Reply-To: <1296743540-8148-4-git-send-email-chifflier@edenwall.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 03.02.2011 15:32, Pierre Chifflier wrote:
> This adds support for sending bridge packets to userspace using
> the NFQUEUE target with ebtables.

I don't think we need a new target for this (and the EBT_QUEUE
definition), just using xt_NFQUEUE should work fine.
