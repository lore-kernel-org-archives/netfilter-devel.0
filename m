From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 3/4] Partially fill connection timestamp when hash
 is not used.
Date: Thu, 15 May 2008 16:00:37 +0200
Message-ID: <482C4205.4080907@netfilter.org>
References: <> <1210805679-11813-4-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59691 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752843AbYEOOBW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 May 2008 10:01:22 -0400
In-Reply-To: <1210805679-11813-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Ulogd2 maintain a hash table containing timestamp information on a connection.
> 
> This patch computes START or STOP timestamp depending on the type of
> the received message even if the has is not used.

No objections with 1/4 and 2/4. The fix included in 4/4 is already fixed
in the patchset that I just sent to the ML. We can rework 3/4 on top of
my patches as this is the easiest way to fix the patch clashing IMO.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
