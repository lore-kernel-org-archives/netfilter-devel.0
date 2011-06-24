From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 1/2] Use %pI4/%pI6c instead of NIPQUAD_FMT/NIP6_FMT and
 make IPv6 work
Date: Fri, 24 Jun 2011 23:40:21 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1106242337350.16290@frira.zrqbmnf.qr>
References: <cover.1308920081.git.john.haxby@oracle.com> <ecfd8eafa3450afcd9f0fec1413b9dd725e757e2.1308920081.git.john.haxby@oracle.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, prarit@redhat.com
To: John Haxby <john.haxby@oracle.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50802 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab1FXVkW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:40:22 -0400
In-Reply-To: <ecfd8eafa3450afcd9f0fec1413b9dd725e757e2.1308920081.git.john.haxby@oracle.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2011-06-24 15:14, John Haxby wrote:

>IPv6 sysrq never worked because of bad pointer arithmetic.  The
>debug output now uses %pI4 nd %pI6c and also records the destination
>address as well as the source.

Xt-a supports >= 2.6.29, but %pI was only introduced in 2.6.32.
So the format subchange will not go into Xt-a. (Though the kernel patch 
I shall produce shall use them then.)
