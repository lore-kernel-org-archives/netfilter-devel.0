From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/8] [PATCH] use EOPNOTSUPP instead of EINVAL if the conntrack
 has no helper
Date: Mon, 17 Nov 2008 15:56:16 +0100
Message-ID: <49218610.1040305@trash.net>
References: <20081117083924.11368.38741.stgit@Decadence> <20081117083949.11368.37228.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45663 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYKQO4U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 09:56:20 -0500
In-Reply-To: <20081117083949.11368.37228.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> This patch changes the return value if the conntrack has no helper assigned.
> Instead of EINVAL, which is reserved for malformed messages, it returns
> EOPNOTSUPP.

Applied, thanks.
