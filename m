From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 08/11] check if the received packet
 is	large enough
Date: Wed, 23 Jan 2008 12:46:50 +0100
Message-ID: <4797292A.6040506@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.39415.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59029 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750855AbYAWLrY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:47:24 -0500
In-Reply-To: <20080122141051.30077.39415.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
> ---
> 
>  src/sync-mode.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)

Applied. Thanks. I like this sort of packet sanity catch ups a lot.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
