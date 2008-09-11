From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 2/4] Suppress unused configuration variable.
Date: Thu, 11 Sep 2008 13:12:58 +0200
Message-ID: <48C8FD3A.5090600@netfilter.org>
References: <> <1220473143-17957-1-git-send-email-eric@inl.fr> <1220473143-17957-2-git-send-email-eric@inl.fr> <1220473143-17957-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52439 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752015AbYIKLS6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 07:18:58 -0400
In-Reply-To: <1220473143-17957-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch suppresses the "rmem" configuration variable which was
> inherited from the original ULOG plugin and which is unused in the
> NFLOG plugin.

Thanks for noticing this. This was a initial work to make the netlink
buffer size tunable. Applied.

BTW, this is fine now because we're in beta stage but we have to think
of a way to deprecate options without breaking existing setups.
Something like "hey, this option is useless, I'm ignoring it, please,
update your configuration file". Anyhow, we can go back to this issue
later ;)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
