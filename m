From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: ipt_ULOG: make spinlock per nlgroup
Date: Fri, 15 Mar 2013 12:51:29 +0100
Message-ID: <20130315115129.GB9530@localhost>
References: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1360032517-3785-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34667 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab3COLvf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:51:35 -0400
Content-Disposition: inline
In-Reply-To: <1360032517-3785-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 05, 2013 at 10:48:37AM +0800, Gao feng wrote:
> This patch uses the spin lock per group instead of
> global spin lock,just like ebt_ulog.

I'd prefer if we focus on NFLOG, that has been around since quite for
a while. ULOG should be scheduled for removal, we can add some printk
in the checkentry path to let people know.
