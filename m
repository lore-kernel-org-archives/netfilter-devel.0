From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH nf-next 2/2] netfilter: nfnetlink_log: allow to attach
 conntrack
Date: Tue, 1 Sep 2015 09:34:36 +0900
Message-ID: <20150901003436.GA2642@gmail.com>
References: <20150824231038.GA20038@gmail.com>
 <20150824231520.GC20038@gmail.com>
 <20150826190553.GA18429@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36784 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbbIAAel (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2015 20:34:41 -0400
Received: by pacgr6 with SMTP id gr6so4950373pac.3
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2015 17:34:41 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150826190553.GA18429@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The compile fails if both nflog and nfqueue are built-in at the
previous patch.

I am trying to link nf_netlink_queue_ct to nf_conntrack_netlink, not
to nf_netlink_queue_core, to avoid the compilation fail in the
following patch series. The idea is that nfqueue and nflog uses the
functions in nf_conntrack_netlink.o, put the conntrack attachment
basis into nf_conntrack_netlink.

On Wed, Aug 26, 2015 at 09:05:53PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 25, 2015 at 08:15:20AM +0900, Ken-ichirou MATSUZAWA wrote:
> >  config NETFILTER_NETLINK_QUEUE_CT
> > -        bool "NFQUEUE integration with Connection Tracking"
> > +        bool "NFQUEUE/NFLOG integration with Connection Tracking"
> >          default n
> > -        depends on NETFILTER_NETLINK_QUEUE
> > +        depends on NETFILTER_NETLINK_QUEUE || NETFILTER_NETLINK_LOG
> >  	help
> > -	  If this option is enabled, NFQUEUE can include Connection Tracking
> > -	  information together with the packet is the enqueued via NFNETLINK.
> > +	  If this option is enabled, NFQUEUE and/or NFLOG can include
> > +	  Connection Tracking information together with the packet is
> > +	  enqueued, logged via NFNETLINK.
> 
> You better add another Kconfig for _LOG.

That idea causes to expose functions in nf_netlink_queue_ct and to
disable to separate config in Kconfig too. Should I separate those
config? and would you please tell me how if I should?

Thanks,
