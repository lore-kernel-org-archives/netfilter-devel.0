From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 05/11] added missing ntohs()
Date: Wed, 23 Jan 2008 12:07:39 +0100
Message-ID: <47971FFB.5050303@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.23200.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46515 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750967AbYAWLHy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 06:07:54 -0500
In-Reply-To: <20080122141051.30077.23200.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
>  src/sync-mode.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)

handle_msg() sanity checks and converts nethdr from network to host byte
order.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
