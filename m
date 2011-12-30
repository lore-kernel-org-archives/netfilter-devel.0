From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables: build updates and fixes
Date: Fri, 30 Dec 2011 14:19:50 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112301413130.8225@frira.zrqbmnf.qr>
References: <1325208902-2014-1-git-send-email-jengelh@medozas.de> <20111230115849.GC12204@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:33915 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902Ab1L3NTw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Dec 2011 08:19:52 -0500
In-Reply-To: <20111230115849.GC12204@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2011-12-30 12:58, Pablo Neira Ayuso wrote:
>> Jan Engelhardt (6):
>>       Update .gitignore
>>       build: use AC_CONFIG_AUX_DIR and stash away tools
>>       Update .gitignore
>>       build: use delayed expansion on the user-settable variables
>>       extensions: link on libxtables and check symbols
>>       nfnl_osf: add missing libnfnetlink_CFLAGS to compile process
>
>No objections regarding this patchset.
>
>Only thing is that I'd like to reduce the changes on the -stable branch
>to the strictly neccessary.
>
>This is the only way to reduce the chances that someone comes and say
>that we have broken something in -stable.
>
>Would you be OK if this goes to master instead?

I will cherry out nfnl_osf: for stable, and move the other to master.
