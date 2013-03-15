From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ulog: add protection when remove ipt_ULOG
Date: Fri, 15 Mar 2013 12:49:36 +0100
Message-ID: <20130315114936.GA9530@localhost>
References: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34206 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab3COLtr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:49:47 -0400
Content-Disposition: inline
In-Reply-To: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 05, 2013 at 09:57:30AM +0800, Gao feng wrote:
> We should add a lock protection when we free the skb,
> because it maybe used by ipt_ulog_packet right now.

applied, thanks.
