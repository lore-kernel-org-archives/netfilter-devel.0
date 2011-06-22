From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 6/8] iptables: Coverity: VARARGS
Date: Wed, 22 Jun 2011 15:59:50 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106221559440.14179@frira.zrqbmnf.qr>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com> <1307712362-17727-7-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60884 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967Ab1FVN7v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:59:51 -0400
In-Reply-To: <1307712362-17727-7-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-06-10 15:26, Jiri Popelka wrote:

>xtables.c:931: va_init: Initializing va_list "args".
>xtables.c:938: missing_va_end: va_end was not called for "args".
>xtables.c:947: missing_va_end: va_end was not called for "args".
>xtables.c:961: missing_va_end: va_end was not called for "args".

Taken.
