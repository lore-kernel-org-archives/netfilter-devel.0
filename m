From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 01/11] netfilter: move nf_conntrack initialize
 out of pernet operations
Date: Wed, 23 Jan 2013 14:11:03 +0100
Message-ID: <20130123131103.GA13799@1984>
References: <1358842234-15005-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	canqunzhang@gmail.com, ebiederm@xmission.com
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52321 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600Ab3AWNLL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:11:11 -0500
Content-Disposition: inline
In-Reply-To: <1358842234-15005-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 22, 2013 at 04:10:24PM +0800, Gao feng wrote:
> Right now,the netfilter initialize and cleanup codes are
> in pernet operations function.
> This job should be done in module_init/exit.We can't use
> init_net to identify if it's the right time to initialize
> or cleanup.

Applied, thanks.
