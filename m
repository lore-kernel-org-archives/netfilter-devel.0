From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/8] [PATCH] use nf_conntrack_get instead of atomic_inc
Date: Mon, 17 Nov 2008 15:55:14 +0100
Message-ID: <492185D2.8050803@trash.net>
References: <20081117083924.11368.38741.stgit@Decadence>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45651 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYKQOzT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Nov 2008 09:55:19 -0500
In-Reply-To: <20081117083924.11368.38741.stgit@Decadence>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Use nf_conntrack_get instead of the direct call to atomic_inc.

Applied, thanks.

BTW, it would save me some work if you could already use the
same headline-format that I use. In this case this would have
been:

netfilter: ctnetlink: use nf_contrack_get ...
