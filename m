From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 03/11] netfilter: acct: move initial codes out
 of pernet_operations
Date: Wed, 23 Jan 2013 14:11:23 +0100
Message-ID: <20130123131123.GC13799@1984>
References: <1358842234-15005-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1358842234-15005-3-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	canqunzhang@gmail.com, ebiederm@xmission.com
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52494 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752702Ab3AWNL1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:11:27 -0500
Content-Disposition: inline
In-Reply-To: <1358842234-15005-3-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 22, 2013 at 04:10:26PM +0800, Gao feng wrote:
> Move the global initial codes to the module_init/exit context.

Applied, thanks.
