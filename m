From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libnetfilter_conntrack: conntrack/objopt: NO_EFFECT
Date: Mon, 13 Jun 2011 19:51:55 +0200
Message-ID: <4DF64E3B.6020000@netfilter.org>
References: <1307697135-6693-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36816 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753357Ab1FMRwD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jun 2011 13:52:03 -0400
In-Reply-To: <1307697135-6693-1-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/06/11 11:12, Jiri Popelka wrote:
> static analysis (analysis based only on compiling of sources, not based
> on running of binary) of the code revealed the following problem:
> 
> conntrack/objopt.c:63: self_assign: Assignment operation
>                        "ct->snat.l4max.all = ct->snat.l4max.all"
>                        has no effect.

Applied, thanks Jiri.
