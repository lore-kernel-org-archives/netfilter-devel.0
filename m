From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 02/14] Suppress ip_as_string configuration variable.
Date: Sat, 05 Apr 2008 17:05:16 +0200
Message-ID: <47F7952C.1030005@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895222096-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34160 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752150AbYDEPFZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 11:05:25 -0400
In-Reply-To: <12062895222096-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch suppress a now unused option. Each database module
> have now to be used with a defined IP storage type.

As far as I can remember, this parameter was introduced because some
sysadmins queried the sql database directly to look for certain IPs. I
know that this isn't good for performance but it has some clients in
ulogd 1.x.

Does mysql have something like the PgSQL's inet type? Looking at the
database definitions, we are storing the IPs in binary format in mysql
and in inet type in PgSQL. Does this mean that there's no replacement
for the ip_as_string in mysql?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
