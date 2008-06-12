From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 4/5] Use ULOGD_IRET_* as return for all interp functions.
Date: Thu, 12 Jun 2008 11:19:21 +0200
Message-ID: <4850EA19.9050105@netfilter.org>
References: <> <1212758035-19538-1-git-send-email-eric@inl.fr> <1212758035-19538-2-git-send-email-eric@inl.fr> <1212758035-19538-3-git-send-email-eric@inl.fr> <1212758035-19538-4-git-send-email-eric@inl.fr> <1212758035-19538-5-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34083 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753640AbYFLJT3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:19:29 -0400
In-Reply-To: <1212758035-19538-5-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modifies plugins to use the already defined but not used
> define. This also fixes some weird behaviours in error treatment (like
> not stopping after OOM).

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
