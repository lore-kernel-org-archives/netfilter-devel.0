From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 06/14] MAC address handling in MySQL output plugin.
Date: Sat, 05 Apr 2008 16:51:47 +0200
Message-ID: <47F79203.2040301@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895234125-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37416 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752079AbYDEOvy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 10:51:54 -0400
In-Reply-To: <12062895234125-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch adds MAC address handling to the MySQL output plugin.

Applied. Thanks. Please, next time also include in the description that
you have deleted the mac_saddr field (I assume that it makes sense since
it does not provide any useful information for the logging purposes)

BTW, we have to freeze changes in the databases before the final
release, otherwise we'll have to include upgrade scripts to convert the
database from version X to Y as it happens to other apps (like
bugzilla). I know that this would happen sooner or later if we have to
add features but still introducing such kind of scripts would be really
a pain. I don't think that we should go that way.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
