From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 8/8] iptables: Coverity: RESOURCE_LEAK
Date: Wed, 22 Jun 2011 18:09:05 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106221808570.25446@frira.zrqbmnf.qr>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com> <1307712362-17727-9-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33075 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932210Ab1FVQJH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:09:07 -0400
In-Reply-To: <1307712362-17727-9-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-06-10 15:26, Jiri Popelka wrote:

>xtables.c:320: alloc_fn: Calling allocation function "get_modprobe".
>xtables.c:294: alloc_fn: Storage is returned from allocation function "malloc".
>xtables.c:294: var_assign: Assigning: "ret" = "malloc(1024UL)".

Taken.
