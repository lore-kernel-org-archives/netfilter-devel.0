From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/3] netfilter: ipset: fix ip_set_flush return code
Date: Tue, 24 May 2011 16:46:24 +0200
Message-ID: <4DDBC4C0.3060101@trash.net>
References: <1306225219-1498-1-git-send-email-kadlec@blackhole.kfki.hu> <1306225219-1498-2-git-send-email-kadlec@blackhole.kfki.hu> <1306225219-1498-3-git-send-email-kadlec@blackhole.kfki.hu> <1306225219-1498-4-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55982 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932147Ab1EXOq7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 May 2011 10:46:59 -0400
In-Reply-To: <1306225219-1498-4-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.05.2011 10:20, Jozsef Kadlecsik wrote:
> ip_set_flush returned -EPROTO instead of -IPSET_ERR_PROTOCOL, fixed

Applied, thanks.
