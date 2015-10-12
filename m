From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nfnetlink_log: autoload
 nf_conntrack_netlink module NFQA_CFG_F_CONNTRACK config flag
Date: Mon, 12 Oct 2015 22:10:46 +0200
Message-ID: <20151012201046.GA10550@salvia>
References: <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
 <20151006021001.GA30037@gmail.com>
 <20151006021246.GB30037@gmail.com>
 <20151006100728.GA2429@salvia>
 <20151007042016.GA23203@gmail.com>
 <20151007042550.GC23203@gmail.com>
 <20151012171352.GA2708@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57914 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbbJLUEA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Oct 2015 16:04:00 -0400
Content-Disposition: inline
In-Reply-To: <20151012171352.GA2708@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 12, 2015 at 07:13:52PM +0200, Pablo Neira Ayuso wrote:
> On Wed, Oct 07, 2015 at 01:25:50PM +0900, Ken-ichirou MATSUZAWA wrote:
> > This patch enables to load nf_conntrack_netlink module if
> > NFULNL_CFG_F_CONNTRACK config flag is specified.
> 
> Applied, thanks.

I just noticed we're breaking atomicity when configuring things.

I mean, if we fail to configure the flags, we return an error but it's
too late, we just create the instance and we have configured
everything.

I quickly made a couple of patches here, we'll be posting them
tomorrow.
