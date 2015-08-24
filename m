From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH nf-next 0/2] netfilter: nfnetlink_log attach conntrack
Date: Tue, 25 Aug 2015 08:10:38 +0900
Message-ID: <20150824231038.GA20038@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:35984 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751020AbbHXXKn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 24 Aug 2015 19:10:43 -0400
Received: by padfo6 with SMTP id fo6so3838517pad.3
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Aug 2015 16:10:43 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi,
 
 It would be good if conntrack information is attached to nflog
netlink message since we can get NATed information from nflog. This
patch series uses NFQUEUE basis in a hacky way, could it be
acceptable?

Thanks,
Ken
