From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 0/1] netfilter: nfnetlink_queue: return -EOPNOTSUPP
 if QUEUE_CT is disabled
Date: Thu, 10 Sep 2015 18:20:58 +0900
Message-ID: <20150910092058.GA28436@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <1441731291-21342-4-git-send-email-pablo@netfilter.org>
 <20150909095516.GC11843@gmail.com>
 <20150910000958.GC5734@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f43.google.com ([209.85.220.43]:33621 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbbIJJVE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Sep 2015 05:21:04 -0400
Received: by pacex6 with SMTP id ex6so38132907pac.0
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Sep 2015 02:21:03 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150910000958.GC5734@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi,

> On Wed, Sep 09, 2015 at 06:55:16PM +0900, Ken-ichirou MATSUZAWA wrote:
> > On Tue, Sep 08, 2015 at 06:54:51PM +0200, Pablo Neira Ayuso wrote:
> > [...]
> > May I suggest one thing? How about returning -EOPNOTSUPP at
> > nfqnl_recv_config() if derefering nfq_ct_hook is NULL?
> 
> Makes sense. Thus, the user knows that it is not supported, please
> send a patch for that.

Would you review the following patch? It applies on top of your
"Rework nfnetlink_queue conntrack support" series.

Thanks,
