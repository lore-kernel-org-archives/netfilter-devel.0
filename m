From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] netfilter: fix nf_log_packet message in icmpv6 conntrack.
Date: Mon, 09 Feb 2009 18:15:12 +0100
Message-ID: <499064A0.8040200@trash.net>
References: <1233261382-17030-1-git-send-email-eric@inl.fr> <1233261382-17030-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59746 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbZBIRPO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:15:14 -0500
In-Reply-To: <1233261382-17030-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch fixes a trivial typo that was adding a new line at end of
> the nf_log_packet() prefix. It also make the logging conditionnal by
> adding a LOG_INVALID test.

Applied, thanks Eric.

