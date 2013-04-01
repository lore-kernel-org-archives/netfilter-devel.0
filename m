From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: TRACE: use IS_ENABLE to replace if defined
Date: Tue, 2 Apr 2013 01:21:01 +0200
Message-ID: <20130401232101.GA8060@localhost>
References: <1363931322-2286-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1363931322-2286-2-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37479 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757870Ab3DAXVJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:21:09 -0400
Content-Disposition: inline
In-Reply-To: <1363931322-2286-2-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 22, 2013 at 01:48:42PM +0800, Gao feng wrote:
> Inder to reduce codes, Use IS_ENABLE to replace the
> if defined.

Applied, thanks.
