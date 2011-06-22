From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/8] iptables: Coverity: NEGATIVE_RETURNS
Date: Wed, 22 Jun 2011 15:55:46 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106221555420.14179@frira.zrqbmnf.qr>
References: <1307712362-17727-1-git-send-email-jpopelka@redhat.com> <1307712362-17727-4-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jiri Popelka <jpopelka@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:53153 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1FVNzr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2011 09:55:47 -0400
In-Reply-To: <1307712362-17727-4-git-send-email-jpopelka@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-06-10 15:25, Jiri Popelka wrote:

>libipq/libipq.c:232: var_tested_neg: Variable "h->fd" tests negative.
>libipq/libipq.c:234: negative_returns: "h->fd" is passed to a parameter that cannot be negative.

Picked up.
