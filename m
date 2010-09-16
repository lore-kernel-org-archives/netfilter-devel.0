From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2 v2] netfilter: fix the hash random initializing race
Date: Thu, 16 Sep 2010 19:56:42 +0200
Message-ID: <4C925A5A.2090503@trash.net>
References: <1282344496-5270-1-git-send-email-xiaosuo@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
	Jan Engelhardt <jengelh@medozas.de>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:49424 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab0IPR4n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 16 Sep 2010 13:56:43 -0400
In-Reply-To: <1282344496-5270-1-git-send-email-xiaosuo@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21.08.2010 00:48, Changli Gao wrote:
> nf_conntrack_alloc() isn't called with nf_conntrack_lock locked, so hash
> random initializing code maybe executed more than once on different CPUs.
> 

Applied, thanks. However please remember to use proper subject lines,
we have lots of hashes in netfilter, so without stating that its about
nf_conntrack, its hard to relate this to something without reading the
full changelog.
