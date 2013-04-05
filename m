From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 07/10] netfilter: nfnetlink_log: add net
 namespace support for nfnetlink_log
Date: Fri, 5 Apr 2013 20:38:01 +0200
Message-ID: <20130405183801.GG4853@localhost>
References: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1364205048-32632-7-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53432 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162413Ab3DESiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:38:05 -0400
Content-Disposition: inline
In-Reply-To: <1364205048-32632-7-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 25, 2013 at 05:50:45PM +0800, Gao feng wrote:
> This patch makes /proc/net/netfilter/nfnetlink_log pernet,
> and netns has it's own instance table and lock.

Applied, thanks.
