From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: pass netns to ->match or to not pass
Date: Fri, 24 Oct 2008 03:16:11 +0400
Message-ID: <20081023231611.GA19245@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:30157 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759420AbYJWXM6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:12:58 -0400
Received: by ey-out-2122.google.com with SMTP id 6so197092eyi.37
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Oct 2008 16:12:56 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

xt_recent wants netns inside ->match hook (and xt_hashlimit probably,
haven't looked closely):

	recent_mt
	recent_table_lookup
	[use per-netns tables list]

Now, I can drag netns through struct xt_match_param, or use
dev_net(skb->dev ? skb->dev : skb->dst->dev) trick.

And the latter should be better, because only xt_recent module will be
affected.

Comments?
