From: mark diener <rpzrpzrpz@gmail.com>
Subject: NFTables Internals
Date: Thu, 27 Oct 2016 09:56:18 -0600
Message-ID: <CAChgv6pe8mrMRgYhzmiTSQ9dC5d1shp8j_RpU2Kf+n31iA_omQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f41.google.com ([209.85.218.41]:33845 "EHLO
        mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933914AbcJ0P4U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Oct 2016 11:56:20 -0400
Received: by mail-oi0-f41.google.com with SMTP id p136so9302966oic.1
        for <netfilter-devel@vger.kernel.org>; Thu, 27 Oct 2016 08:56:19 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Thanks for all the responses about the internals of NFTables

The best starter document was this:

https://workshop.netfilter.org/2016/wiki/images/7/78/Nft-tutorial.pdf

Now I just need to figure out how to interpet the "payload load 4b @
network_header + 12" nomenclature to really get a handle on things.

Any more documents or videos to understand the internals?
(Instead of hours spent looking at source code!)

Thanks,

md
