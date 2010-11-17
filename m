From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] libxt_conntrack: fix --ctdir save/dump output format
Date: Wed, 17 Nov 2010 15:55:18 +0100
Message-ID: <4CE3ECD6.5050002@trash.net>
References: <1290004032-7711-1-git-send-email-fwestphal@astaro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fwestphal@astaro.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46517 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932314Ab0KQOzU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:55:20 -0500
In-Reply-To: <1290004032-7711-1-git-send-email-fwestphal@astaro.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17.11.2010 15:27, Florian Westphal wrote:
> $ iptables-save | iptables-restore
> iptables-restore v1.4.6: conntrack: Bad value for "--ctdir" option: "ORIGINAL-j"

Amazing, nobody noticed for almost two years.

Applied, thanks Florian.
