From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: xt_AUDIT: only generate audit log when audit
 enabled
Date: Mon, 4 Mar 2013 16:54:53 +0100
Message-ID: <20130304155453.GA25931@localhost>
References: <1362392952-11268-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tgraf@redhat.com
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47916 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758430Ab3CDPzE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Mar 2013 10:55:04 -0500
Content-Disposition: inline
In-Reply-To: <1362392952-11268-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 04, 2013 at 06:29:12PM +0800, Gao feng wrote:
> We should stop generting audit log if audit is disabled.

Applied, thanks Gao and Thomas.
