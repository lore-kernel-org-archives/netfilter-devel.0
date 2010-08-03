From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nfqueue
Date: Tue, 3 Aug 2010 19:55:18 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008031953580.32585@obet.zrqbmnf.qr>
References: <4C584B82.2090907@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: m <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:57818 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397Ab0HCRzT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Aug 2010 13:55:19 -0400
In-Reply-To: <4C584B82.2090907@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-08-03 19:01, m wrote:

> I have used both Snort and Suricata inline on my firewall.
> With snort I use ip_queue, and with Suricata I use nf_queue.
> Both seem to function in the same manner.
>
> example:
>
> iptables -t raw -I PREROUTING -j QUEUE
>
> or
>
> iptables -t raw -I PREROUTING -j NFQUEUE 1
>
> After that I never see any further traffic in the raw table, despite there
> might be a lot more rules to traverse. The -j never returns.

NFQUEUE is a terminating target.

> Either I am missing something very important, or this is an issue, AKA bug. Not
> sure what I need to work on to fix it.
