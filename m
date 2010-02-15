From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/10] netfilter: ebtables: abort if next_offset is too
 small
Date: Mon, 15 Feb 2010 18:40:09 +0100
Message-ID: <4B7986F9.7000005@trash.net>
References: <1265897559-10610-1-git-send-email-fw@strlen.de> <1265897559-10610-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:65344 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab0BORkN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 12:40:13 -0500
In-Reply-To: <1265897559-10610-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal wrote:
> next_offset must be > 0, otherwise this loops forever.
> The offset also contains the size of the ebt_entry structure
> itself, so anything smaller is invalid.

Applied, thanks.
