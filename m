From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCHv2 nf-next 0/4] netfilter: nfnetlink_log attach conntrack
 information
Date: Mon, 5 Oct 2015 11:44:54 +0900
Message-ID: <20151005024454.GA14637@gmail.com>
References: <1443724990-4014-1-git-send-email-pablo@netfilter.org>
 <1443724990-4014-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:34778 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153AbbJECo7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Oct 2015 22:44:59 -0400
Received: by padhy16 with SMTP id hy16so21305752pad.1
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Oct 2015 19:44:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1443724990-4014-2-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi Pablo,

I rebased on top of your patches, would you review these?

You suggested it might be better to divide ct attaching Kconfig to
each of nfqueue and nflog, but I think it makes less sense now
because of your rework. is it right?

Thanks,
