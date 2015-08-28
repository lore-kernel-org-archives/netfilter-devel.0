From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCH nf-next 2/2] netfilter: nfnetlink_log: allow to attach
 conntrack
Date: Fri, 28 Aug 2015 15:43:00 +0900
Message-ID: <20150828064300.GA32065@gmail.com>
References: <20150824231038.GA20038@gmail.com>
 <20150824231520.GC20038@gmail.com>
 <20150826190553.GA18429@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35164 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbH1GnG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Aug 2015 02:43:06 -0400
Received: by pacdd16 with SMTP id dd16so52410562pac.2
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Aug 2015 23:43:05 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150826190553.GA18429@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 26, 2015 at 09:05:53PM +0200, Pablo Neira Ayuso wrote:
> On Tue, Aug 25, 2015 at 08:15:20AM +0900, Ken-ichirou MATSUZAWA wrote:
> > This patch enables to include the conntrack information together
> > with the packet that is sent to user-space via NFLOG, then a
> > user-space program can acquire NATed information by this NFULA_CT
> > attribute.
> > 
> No objections to this series, just several comments below on them.

Thank you for your taking time. But I realize these can not be
statically built into kernel, sorry.

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

I'll follow your instruction, thanks.
I have to reconsider to enable it statically linked and will be glad
if you review again at the next time.

Thanks,
