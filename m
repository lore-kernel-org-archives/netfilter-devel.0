From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] iptables-restore: move code to add_param_to_argv, cleanup
 (fix gcc-4.7)
Date: Mon, 23 Jul 2012 14:19:11 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207231418550.32073@frira.zrqbmnf.qr>
References: <1343039903-7230-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:43556 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab2GWMTO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jul 2012 08:19:14 -0400
In-Reply-To: <1343039903-7230-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2012-07-23 12:38, pablo@netfilter.org wrote:

>From: Pablo Neira Ayuso <pablo@netfilter.org>
>
>This patch seems to be a mere cleanup that moves the parameter parsing
>code to add_param_to_argv.
>
>But, in reality, it also fixes iptables whe compiled with gcc-4.7.

How does the problem manifest?
