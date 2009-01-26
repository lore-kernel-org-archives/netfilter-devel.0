From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: fix tuple inversion for Node information request.
Date: Mon, 26 Jan 2009 14:43:04 +0100
Message-ID: <497DBDE8.4040704@trash.net>
References: <1232403612-32301-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: yasuyuki.kozakai@toshiba.co.jp, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44161 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbZAZNnK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:43:10 -0500
In-Reply-To: <1232403612-32301-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> The patch fixes a typo in the inverse mapping of Node Information
> request. Following draft-ietf-ipngwg-icmp-name-lookups-09, "Querier"
> sends a type 139 (ICMPV6_NI_QUERY) packet to "Responder" which answer
> with a type 140 (ICMPV6_NI_REPLY) packet.

Looks good, applied. Thanks.
