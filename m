From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next v2 05/10] netfilter: ebt_ulog: add net namesapce
 support for ebt_ulog
Date: Fri, 5 Apr 2013 20:34:58 +0200
Message-ID: <20130405183458.GE4853@localhost>
References: <1364205048-32632-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1364205048-32632-5-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53171 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162402Ab3DESfH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:35:07 -0400
Content-Disposition: inline
In-Reply-To: <1364205048-32632-5-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 25, 2013 at 05:50:43PM +0800, Gao feng wrote:
> Add pernet_operations for ebt_ulog, in pernet_ops,
> we call nf_log_set/unset to set/unset nf_loggers
> of per net.
> 
> This patch also make ulog_buffers and netlink socket
> ebtulognl per netns.

Applied, thanks. In this patch the unroll in case
register_pernet_subsys is fine.
