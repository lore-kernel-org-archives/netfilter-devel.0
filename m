From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 08/11] netfilter: labels: move initial codes
 out of pernet_operations
Date: Wed, 23 Jan 2013 14:14:36 +0100
Message-ID: <20130123131436.GH13799@1984>
References: <1358842234-15005-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1358842234-15005-8-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	canqunzhang@gmail.com, ebiederm@xmission.com
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53382 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3AWNOk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:14:40 -0500
Content-Disposition: inline
In-Reply-To: <1358842234-15005-8-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 22, 2013 at 04:10:31PM +0800, Gao feng wrote:
> Move the global initial codes to the module_init/exit context.

Applied, thanks.
