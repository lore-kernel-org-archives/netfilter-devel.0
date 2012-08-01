From: Gomathivinayagam Muthuvinayagam <sankarmail@gmail.com>
Subject: ulogd - maximum polling time interval - without risk of losing data
Date: Wed, 1 Aug 2012 01:42:46 -0700
Message-ID: <CAAJpzgb_FB=WNwK0_E3GqNUcYPRuGjF0dxwn6rJzFhgLr-zDSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44808 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2HAInH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 04:43:07 -0400
Received: by obbuo13 with SMTP id uo13so11903258obb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Aug 2012 01:43:06 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Your help would be much appreciated.

I'm using ulogd(NACCT) with polling. If I just use polling based
logging without event based logging, are there any chances that I may
some connection data?
What could be the maximum polling interval value in which I dont miss
the NACCT data?
For example, if I set polling interval as 600s, there are chances I
may some NACCT data, since some timeout values are less than that(like
net.netfilter.nf_conntrack_tcp_timeout_last_ack = 30). If the
connection destroys before logging, then its a miss.

net.netfilter.nf_conntrack_tcp_timeout_close has a timeout of 10
seconds. My guess is I should have polling interval less than this to
avoid missing of any data. Is it correct?


Thanks & Regards,
