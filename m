From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 nf-next 0/1] netfilter: nfnetlink_queue: check
 NFQA_CFG_F_CONNTRACK config flag
Date: Tue, 6 Oct 2015 11:10:01 +0900
Message-ID: <20151006021001.GA30037@gmail.com>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
 <20151005024454.GA14637@gmail.com>
 <20151005025046.GE14637@gmail.com>
 <20151005152315.GA11562@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:34266 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131AbbJFCKH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Oct 2015 22:10:07 -0400
Received: by padhy16 with SMTP id hy16so53666778pad.1
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Oct 2015 19:10:07 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20151005152315.GA11562@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Thank you for advices.

I try to fix rcu_dereference() and to autoload not only
nf_conntrack_netlink but also l3ct module if nfgen family is
specified. Is it unnecessary?

I will make same thing to nfnetlink_log after this round.

Thanks,
