From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC PATCH 0/5] netlink: mmap kernel panic and some issues
Date: Wed, 22 Jul 2015 14:50:59 +0200
Message-ID: <20150722125059.GA8441@breakpoint.cc>
References: <20150722010938.GA30012@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:39412 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756570AbbGVMvB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jul 2015 08:51:01 -0400
Content-Disposition: inline
In-Reply-To: <20150722010938.GA30012@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ken-ichirou MATSUZAWA <chamaken@gmail.com> wrote:
> I got a kernel panic below when I dumped using mmaped netlink socket
> while monitoring it by nlmon tap device. I realized it is because
> mmaped netlink skb does not have skb_shared_info but don't know how
> to fix it in sane. This patch series seems to work fine for me but
> I'm not sure it's right or not.

Could you submit this series to netdev@ver.kernel.org ?
