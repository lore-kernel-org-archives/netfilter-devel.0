From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 5/6] Add destination mac_addr to database
Date: Mon, 23 Jun 2008 16:44:35 +0200
Message-ID: <485FB6D3.7020400@netfilter.org>
References: <1213878187-909-1-git-send-email-eric@inl.fr> <1213878187-909-6-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, chifflier@inl.fr
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46357 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754628AbYFWOov (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:44:51 -0400
In-Reply-To: <1213878187-909-6-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> From: Pierre Chifflier <chifflier@inl.fr>
> 
> This patch adds support for logging the destination mac address in
> the SQL databases.
> A tuple (mac_saddr,mac_daddr,mac_proto) is logged only once.

I have kept back this patch. BTW, please do not mix cleanups with the
supposed intention of the patch, I see several cleanups in this patch.
Better split it into two patches.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
