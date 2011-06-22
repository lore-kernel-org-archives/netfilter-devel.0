From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/8] iptables: Coverity: REVERSE_INULL
Date: Wed, 22 Jun 2011 15:58:41 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106221558290.14179@frira.zrqbmnf.qr>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com> <1307712362-17727-5-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:60875 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757967Ab1FVN6n (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:58:43 -0400
In-Reply-To: <1307712362-17727-5-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-06-10 15:25, Jiri Popelka wrote:

>ip6tables-restore.c:186: deref_ptr_in_call: Dereferencing pointer "in".
>ip6tables-restore.c:463: check_after_deref: Dereferencing "in" before a null check.

Verified/Taken.
