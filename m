From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 08/14] Add state option to NFLOG input plugin.
Date: Sat, 05 Apr 2008 17:10:59 +0200
Message-ID: <47F79683.8070801@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895233806-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47026 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752181AbYDEPLG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 11:11:06 -0400
In-Reply-To: <12062895233806-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds support for "state" option to the NFLOG plugin. For example, it
> can be used by another module to determine if the packet has been dropped,
> rejected or accepted.

What is the exact purpose of the "state" option? The use of the term
"state" for this seems to me a bit confusing as users may think that it
 is related with "stateful filtering". Please, develop the idea a bit more.

I have kept back patches 8/14 to 13/14 until we end discussing this.

> This patch also fixes a bug in definition of seq_global_ce macro.

Please, split this into two patches next time as they are not related.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
