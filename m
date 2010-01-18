From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: simplify warning message
Date: Mon, 18 Jan 2010 09:45:40 +0100
Message-ID: <4B541FB4.8030305@trash.net>
References: <4B541397.6010708@trash.net> <1263804142-6318-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49627 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab0ARIpn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jan 2010 03:45:43 -0500
In-Reply-To: <1263804142-6318-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch remove variable part from a debug message to have
> message concatenation from syslog.
> 
> Signed-off-by: Eric Leblond <eric@inl.fr>

Applied, thanks Eric.
