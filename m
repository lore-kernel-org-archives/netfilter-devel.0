From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: hooks
Date: Thu, 18 Dec 2008 01:27:57 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812180125510.7014@fbirervta.pbzchgretzou.qr>
References: <379e30200812171531v506beaccsdfb5c103ec0671d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tobias Koeck <tobias.koeck@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:56907 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYLRA2A (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2008 19:28:00 -0500
In-Reply-To: <379e30200812171531v506beaccsdfb5c103ec0671d3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-12-18 00:31, Tobias Koeck wrote:
>
>I'm programing  module and in the register function I've included
>
>	.hooks		= (1 << NF_INET_FORWARD),
>
>If I want to append a rule with iptables I get the following error
>message in /var/log/syslog:
>
>tron kernel: ip_tables: RARQOS target: bad hook_mask 4/16
>What could be the problem?

In the invocation of the iptables command.
You are trying to use your target in the POSTROUTING chain (16)
but you only allow it to be used in FORWARD (4).
