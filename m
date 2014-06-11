From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [RFC PATCH libnetfilter_conntrack 0/1] zero value handling of mark
 and zone
Date: Thu, 12 Jun 2014 08:38:14 +0900
Message-ID: <CAGCkEt1s+qbY90TV5y4-oxXojv3Eu4Mg+03qgsNG0mnx+aU22Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:56659 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbaFKXiP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2014 19:38:15 -0400
Received: by mail-la0-f48.google.com with SMTP id gl10so260039lab.21
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jun 2014 16:38:14 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello,

Dumping conntrack entries of zone value 0 by conntrack command in
conntrack-tools
by specifying option -L -w0 does not list any entry. To solve it, I
think we have three
options:

1. As with mark, adding filter code to ctnetlink_dump_table() and
ctnetlink_get_conntrack()

2. Add zone value even its value 0 in ctnetlink_fill_info() (and
ctnetlink_conntrack_event())

3. Handle mark and zone as special case in comparison. (This patch)

Would you tell me what is suitable for?

Thanks,
