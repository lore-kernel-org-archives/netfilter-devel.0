From: Vasily Averin <vvs@parallels.com>
Subject: [PATCH RFC v3 0/2] per-netns sysctl for br_netfilter
Date: Mon, 12 May 2014 20:31:46 +0400
Message-ID: <5370F772.3050004@parallels.com>
References: <20140512140706.GA22082@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailhub.sw.ru ([195.214.232.25]:1566 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172AbaELQc6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2014 12:32:58 -0400
In-Reply-To: <20140512140706.GA22082@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Patrick,
thank you for feedback.
Frankly speaking I still badly understand how it's better to split this patch set.
Finally I've decided to combine v2 patches to 2 parts (1-8 and 9-11). 
Could you please explain how to it better?

This patch set enables per network namespace managemnt for br_netfiltes sysctls,
it allows to enable processing br-nf-call hooks in ones network namespaces 
and keep it disabled in another ones.

v3: patches are merged into more large chunks 
v2: removed extra overhead for CONFIG_SYSCTL=n

Vasily Averin (2):
  br_netfilter: common structure for sysctl flags
  br_netfilter: per-netns copy of structure for sysctl flags

 net/bridge/br_netfilter.c |  155 ++++++++++++++++++++++++++++++++++-----------
 net/bridge/br_private.h   |   13 ++++
 2 files changed, 130 insertions(+), 38 deletions(-)

-- 
1.7.5.4

