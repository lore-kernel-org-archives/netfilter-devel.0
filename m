From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter 23/29: ip{,6}t_policy.h should include xp_policy.h
Date: Thu, 27 Nov 2008 19:33:39 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811271932560.21626@fbirervta.pbzchgretzou.qr>
References: <20081127161503.13891.62766.sendpatchset@x2.localnet> <20081127161534.13891.33306.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, apw@canonical.com
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33131 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYK0Sdl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:33:41 -0500
In-Reply-To: <20081127161534.13891.33306.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-11-27 17:15, Patrick McHardy wrote:

>commit 018a7bf1e55000dd792194238c9043918d24d3dd
>Author: Andy Whitcroft <apw@canonical.com>
>Date:   Thu Nov 20 15:59:56 2008 +0100
>
>    netfilter: ip{,6}t_policy.h should include xp_policy.h

Still trying to fix Bug #1? It's xt_policy, not XP ;-)
