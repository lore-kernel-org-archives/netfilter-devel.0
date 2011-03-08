From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: add -C to check for existing rules
Date: Tue, 08 Mar 2011 15:57:45 +0100
Message-ID: <4D7643E9.4050801@trash.net>
References: <20110308115639.GA30013@zirkel.wertarbyte.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Stefan Tomanek <stefan.tomanek@wertarbyte.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60012 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754767Ab1CHO5r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Mar 2011 09:57:47 -0500
In-Reply-To: <20110308115639.GA30013@zirkel.wertarbyte.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 08.03.2011 12:56, schrieb Stefan Tomanek:
> It is often useful to check whether a specific rule is already present
> in a chain without actually modifying the iptables config.
> 
> Services like fail2ban usually employ techniques like grepping through
> the output of "iptables -L" which is quite error prone.
> 
> This patch adds a new operation -C to the iptables command which mostly
> works like -D; it can detect and indicate the existence of the specified
> rule by modifying the exit code. The new operation TC_CHECK_ENTRY uses
> the same code as the -D operation, whose functions got a dry-run
> parameter appended.

Looks fine to me. I'll apply this if nobody else objects.
