From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnfnetlink] Suppress iftable_up function which is no used.
Date: Mon, 22 Dec 2008 23:11:36 +0100
Message-ID: <49501098.2040100@netfilter.org>
References: <alpine.LNX.1.10.0812221909100.26910@fbirervta.pbzchgretzou.qr> <1229983675-5025-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: jengelh@medozas.de, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48157 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760253AbYLVWLq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:11:46 -0500
In-Reply-To: <1229983675-5025-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Following compilation warning pointed out by Jan Engelhardt, this patch
> suppresses the iftable_up function which is of no use in this part of
> libnfnetlink library whom goal is to do ifindex to name resolution.

Please, apply it yourself. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
