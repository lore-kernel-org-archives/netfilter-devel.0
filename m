From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 1/2] nf_nat: make unique_tuple return void
Date: Mon, 02 Aug 2010 17:21:55 +0200
Message-ID: <4C56E293.2090406@trash.net>
References: <1280560117-30747-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:61961 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab0HBPV4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:21:56 -0400
In-Reply-To: <1280560117-30747-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 31.07.2010 09:08, Changli Gao wrote:
> the only user of unique_tuple() get_unique_tuple() doesn't care about the
> return value of unique_tuple(), so make unique_tuple() return void (nothing).

Applied, thanks.
