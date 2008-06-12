From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 1/5] Fix logic of propagation trough the stack.
Date: Thu, 12 Jun 2008 11:18:05 +0200
Message-ID: <4850E9CD.8050807@netfilter.org>
References: <> <1212758035-19538-1-git-send-email-eric@inl.fr> <1212758035-19538-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36340 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751188AbYFLJSM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:18:12 -0400
In-Reply-To: <1212758035-19538-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch fixes the implementation of the propagation through the
> stack. When a plugin returns ULOGD_IRET_STOP, the propagation should
> stop. This was not the case as break was used to do so but it was called
> inside a switch and thus apply to the switch instruction and not to
> the llist iteration.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
