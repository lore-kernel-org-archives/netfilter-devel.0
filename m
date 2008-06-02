From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH] Fix IPv6 packet parsing.
Date: Mon, 02 Jun 2008 02:04:14 +0200
Message-ID: <484338FE.8070507@netfilter.org>
References: <> <1211574847-14768-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57167 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751521AbYFBAES (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2008 20:04:18 -0400
In-Reply-To: <1211574847-14768-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Source and destination addresses were put in ptr field of the target structure
> instead of being put in the new type ui128. The result was an improper value
> of the IPv6 source add destination addresses.

Applied. Thanks.

I'll test this a bit along this week, any help appreciated. We can
prepare the first release of 2.0.0-rc series soon. If my mind serves
well, configuration file reload is still pending.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
