From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: add -C to check for existing rules
Date: Tue, 8 Mar 2011 23:20:31 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1103082318020.23007@obet.zrqbmnf.qr>
References: <20110308214251.GA21681@zirkel.wertarbyte.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55695 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753976Ab1CHWUg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 17:20:36 -0500
In-Reply-To: <20110308214251.GA21681@zirkel.wertarbyte.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-03-08 22:42, Stefan Tomanek wrote:

>It is often useful to check whether a specific rule is already present
>in a chain without actually modifying the iptables config.
>
>Services like fail2ban usually employ techniques like grepping through
>the output of "iptables -L" which is quite error prone.
>
>This patch adds a new operation -C to the iptables command which mostly
>works like -D; it can detect and indicate the existence of the specified
>rule by modifying the exit code. The new operation TC_CHECK_ENTRY uses
>the same code as the -D operation, whose functions got a dry-run
>parameter appended.

I picked this up, sorted -C in and ironed out a few style issues.
Thanks.
