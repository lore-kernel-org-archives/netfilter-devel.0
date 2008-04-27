From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 2/4] Add label option (SQL part)
Date: Sun, 27 Apr 2008 09:42:41 +0200
Message-ID: <48142E71.7000802@netfilter.org>
References: <1208815106-3315-1-git-send-email-chifflier@inl.fr> <1208815106-3315-3-git-send-email-chifflier@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Eric Leblond <eric@inl.fr>
To: Pierre Chifflier <chifflier@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42851 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753074AbYD0Hmt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Apr 2008 03:42:49 -0400
In-Reply-To: <1208815106-3315-3-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pierre Chifflier wrote:
> This patch adds support for "label" option in the SQL schema. For example, it
> can be used by another module to determine if the packet has been dropped,
> rejected or accepted.

I have kept this back until we discuss if it would be better to have a
string instead of an integer.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
