From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 3/6] Fix warning about unused variable if NFLOG_GID
 is not available.
Date: Mon, 23 Jun 2008 16:25:36 +0200
Message-ID: <485FB260.3020004@netfilter.org>
References: <1213878187-909-1-git-send-email-eric@inl.fr> <1213878187-909-4-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, chifflier@inl.fr
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38352 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753519AbYFWOZs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jun 2008 10:25:48 -0400
In-Reply-To: <1213878187-909-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch fixes a warning about an unused variable if NFLOG_GID is not available
> in libnetfilter_log.

AFAIK, this warning happens if we use an old version of the library, right?

As I'm about to conclude a massive release of libraries and the tools, I
think that forcing the use of a recent library version is better as it
also contains several bugfixes.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
