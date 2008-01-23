From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-utils PATCH r7285 03/11] moved process function pointer
 to	struct local_server
Date: Wed, 23 Jan 2008 11:45:01 +0100
Message-ID: <47971AAD.8080805@netfilter.org>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.17154.stgit@rabbit.intern.cm-ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Max Kellermann <max@duempel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44167 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750767AbYAWKqA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:46:00 -0500
In-Reply-To: <20080122141051.30077.17154.stgit@rabbit.intern.cm-ag>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Max Kellermann wrote:
>  include/local.h |   10 +++++++---
>  src/local.c     |   11 +++++++----
>  src/run.c       |    5 +++--
>  3 files changed, 17 insertions(+), 9 deletions(-)

This makes local.c less flexible since it sticks the local socket to a
given handler. With the current approach, you may call different
handlers in do_local_server_step with the same socket. I know, we aren't
using it in that way for now but perhaps in the near future. I have kept
this patch back.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
