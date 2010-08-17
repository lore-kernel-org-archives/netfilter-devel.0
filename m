From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] netfilter: don't disable BH again in BH disabled
 context
Date: Tue, 17 Aug 2010 10:29:05 +0200 (CEST)
Message-ID: <alpine.LSU.2.01.1008171028530.28106@obet.zrqbmnf.qr>
References: <1282027297-9998-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34441 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751468Ab0HQI3K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Aug 2010 04:29:10 -0400
In-Reply-To: <1282027297-9998-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-08-17 08:41, Changli Gao wrote:

>All the matches and targets of iptables, ip6tables are in BH disabled
>context, since xt_info_rdlock_bh() disables BH.

Does it not nest automatically?

