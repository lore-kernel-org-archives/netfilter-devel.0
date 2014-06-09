From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [PATCH libnetfilter_conntrack v2 0/2] add event filters
Date: Mon, 9 Jun 2014 18:59:48 +0900
Message-ID: <20140609095948.GA28658@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:40436 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbaFIJ7y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:59:54 -0400
Received: by mail-pd0-f175.google.com with SMTP id z10so4671199pdj.34
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Jun 2014 02:59:54 -0700 (PDT)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hello,
 
I tried to chang zero CTA_MARK and CTA_ZONE value handling, regard its value
as 0 if the values are not set in a message.
 
Thanks,
