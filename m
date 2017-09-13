From: Michael Chi <chibo.michael@gmail.com>
Subject: does nftables support string match?
Date: Wed, 13 Sep 2017 20:13:38 +0800
Message-ID: <CAMXhvOCwO49YmLAnEthGGifMZbdSgw2+vR6Pdp3o4cW-XaVjAQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:43547 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751085AbdIMMNj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2017 08:13:39 -0400
Received: by mail-oi0-f44.google.com with SMTP id r20so223449oie.0
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2017 05:13:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi experts,

We are using nftables instead of iptables, but after I have search all
the nftables documents I found, I don't find a corresponding match
that can match string in packet, like following in iptables:
iptables -A INPUT -m string --string 'badstring' -j DROP

Is such function supported by nftables?
Really appreciate your reply.

Thanks,
Bo
