From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ulog: add protection when remove ipt_ULOG
Date: Mon, 18 Feb 2013 17:52:30 +0100
Message-ID: <20130218165230.GA19791@localhost>
References: <1360029450-6673-1-git-send-email-gaofeng@cn.fujitsu.com>
 <20130207182708.GA18328@localhost>
 <5121A6B0.9090809@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:30791 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751839Ab3BRQwh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:52:37 -0500
Content-Disposition: inline
In-Reply-To: <5121A6B0.9090809@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 18, 2013 at 11:57:36AM +0800, Gao feng wrote:
[...]
> > I think this is very unlikely to happen. The removal of the module
> > happens in user-context and the entire path to build and deliver the
> > skb to user-space is protected is under spin_lock_bh, so scheduling
> > is not possible.
> 
> Doesn't spin_lock_bh only disable local cpu's bottom-half?
> the task that remove the modules can run on other cpus at the same time.
> I'm wrong?

That's right. But that will not happen since the removal of ipt_ULOG
is protected by the module refcount, which is bumped for each iptables
rule. So, you have to remove all rules using the ULOG target first to
be able to rmmod that module, but then there is no chance to race with
packets.
