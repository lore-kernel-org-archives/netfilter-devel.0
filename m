From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipv4: netfilter: arp_tables: fix information leak to
 userland
Date: Wed, 03 Nov 2010 08:44:34 +0100
Message-ID: <4CD112E2.3040800@trash.net>
References: <1288448806-6470-1-git-send-email-segooon@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: kernel-janitors@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	"Pekka Savola (ipv6)" <pekkas@netcore.fi>,
	James Morris <jmorris@namei.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Vasiliy Kulikov <segooon@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44500 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab0KCHog (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 3 Nov 2010 03:44:36 -0400
In-Reply-To: <1288448806-6470-1-git-send-email-segooon@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 30.10.2010 16:26, Vasiliy Kulikov wrote:
> Structure arpt_getinfo is copied to userland with the field "name"
> that has the last elements unitialized.  It leads to leaking of
> contents of kernel stack memory.

Applied, thanks.
