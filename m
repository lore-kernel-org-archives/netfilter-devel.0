From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 06/10] netfilter: ipt_ulog: add net namespace
 support for ipt_ulog
Date: Fri, 5 Apr 2013 20:35:49 +0200
Message-ID: <20130405183549.GF4853@localhost>
References: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1364205048-32632-6-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53249 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162402Ab3DESf6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:35:58 -0400
Content-Disposition: inline
In-Reply-To: <1364205048-32632-6-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 25, 2013 at 05:50:44PM +0800, Gao feng wrote:
> Add pernet_operations for ipt_ulog, in pernet_ops,
> we call nf_log_set/unset to set/unset nf_loggers
> of per net.
> 
> This patch also make ulog_buffers and netlink socket
> nflognl per netns.

Applied, thanks.
