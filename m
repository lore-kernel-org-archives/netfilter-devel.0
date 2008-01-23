From: Max Kellermann <max@duempel.org>
Subject: Re: [conntrack-utils PATCH r7285 03/11] moved process function pointer to	struct local_server
Date: Wed, 23 Jan 2008 11:52:40 +0100
Message-ID: <20080123105240.GA9564@swift.blarg.de>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.17154.stgit@rabbit.intern.cm-ag> <47971AAD.8080805@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:35802 "HELO duempel.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753516AbYAWKxR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 05:53:17 -0500
Content-Disposition: inline
In-Reply-To: <47971AAD.8080805@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/23 11:45, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Max Kellermann wrote:
> >  include/local.h |   10 +++++++---
> >  src/local.c     |   11 +++++++----
> >  src/run.c       |    5 +++--
> >  3 files changed, 17 insertions(+), 9 deletions(-)
> 
> This makes local.c less flexible since it sticks the local socket to a
> given handler. With the current approach, you may call different
> handlers in do_local_server_step with the same socket. I know, we aren't
> using it in that way for now but perhaps in the near future. I have kept
> this patch back.

This is just the code which accepts connections from the unix socket.
I assumed that the daemon will not change its behaviour during its
lifetime, please explain your plan.  In the process function, you can
still choose what to do with the new client connection.  You could
also add a local_server_set_callback() or similar.

Max
