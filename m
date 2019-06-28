Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB67C4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 11:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D6E520645
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 11:45:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MPdKspEd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726587AbfF1Lpr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 07:45:47 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43848 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726502AbfF1Lpr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 07:45:47 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so11789481ios.10
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 04:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=F56TvVTOLp54TnrRS5I7mFCnSDCOD4C6V4BA/TO9UJY=;
        b=MPdKspEdo2AtIaizLmPf8eIhf6h3Cj124a3qNu9kb5v23+Mr4dq06ESlqR2TSpVp3K
         FZ6Eb0Yz3IrS9nQDgy5FrHLS7mkNlBRd/8rWiA+4S5I8Bpb6+y+wWhoF1kytNBgV7h0w
         ySvJDcCNsEkQliFJTmPqiQKGwydEFOvO0Guu9R6YknjqLZ8L0fQ7OlNmH3pY8+w7hfyq
         KYSDaKaF5PetqkkJEUyu5sXaaK5o8rEHzbCymn22lx3cGeXLnJys0xBkR2Yl9Vc8F/uU
         AY8nAnrlAD6Z5VDF3CZDFQOsDJHUInLhbKjw1dVXjXd0aCmMSfwOZBr79iC4znmBVBJC
         l+7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=F56TvVTOLp54TnrRS5I7mFCnSDCOD4C6V4BA/TO9UJY=;
        b=NMWasTqBE6ptWNcmyJ6kwGKOzeknbe+lVFKQ7kItuUFWktv4UDEzJ7Ub63cbZxH9AB
         tq1UjtVG6G+mODFfHVORb2zQbwH6lK8ndwZx9cFU8Hq+bwuSO8HsEl621gHr5TBjauiW
         v/FqCrivvuwRVaX8Y1ACYjBSVRw1B1Uivx1WRdxG2n+0SK5f7XhzOwGXtxTA0/6VX89e
         nmRU091cR++H9/rz8PgmS5+8P5nLMAbMLwW04bf21NfsL63Im8aD1oMs4/R/ImWDtECD
         SKXwXO2V38qQM4+ozaGxumGgidQggfD04nEfGNsZjr+SsUQEBWVwpGMuq+umZbD6cnKF
         mKIg==
X-Gm-Message-State: APjAAAWv4eJ3cuIYziLQkYF3+GbpMHu0JJBoyQ6jcyzaSxqJYpVgA6oG
        U9N8RdeOE9pZw7bYfgcHXDc3MU0G9pzum88aTBx6uA==
X-Google-Smtp-Source: APXvYqwXtTzkWoenHy/ND+LZogrHNATeiv5Jmv50tLj8sl2KXtE3TZXdDkeksU8gx+McFAOv9f6u67Wb/mph7jll5LM=
X-Received: by 2002:a02:662f:: with SMTP id k47mr11058022jac.4.1561722346530;
 Fri, 28 Jun 2019 04:45:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a02:3b60:0:0:0:0:0 with HTTP; Fri, 28 Jun 2019 04:45:46
 -0700 (PDT)
From:   Valeri Sytnik <valeri.sytnik@gmail.com>
Date:   Fri, 28 Jun 2019 15:45:46 +0400
Message-ID: <CAF1SjT56zfq9VeUwqwe+vVfB6wija76Ldpa_dhY96x_eo4JU5A@mail.gmail.com>
Subject: if nfqnl_test utility (libnetfilter_queue) drops a packet the utility
 receives the packet again
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

Subject:
if nfqnl_test utility ( libnetfilter_queue project ) drops a packet
the utility receives this packet again (in loop)

I faced a very strange problem when trying to use a code from:

https://git.netfilter.org/libnetfilter_queue/tree/utils/nfqnl_test.c

The problem consists in the following:

If all packets are processed as accepted (NF_ACCEPT),
the utility (nfqnl_test) works good,

But if in the utility line:

return nfq_set_verdict(qh, id, NF_ACCEPT, 0, NULL);

I apply NF_DROP (instead NF_ACCEPT) to some tcp packet which
contains some specific string known to me (say, hhhhh)
that packet comes back to the queue again but with different id.
And that happens in the loop: the packet drops again and comes back
again, and so on.
That is interesting that the packet comes back to the queue with frequency
that becomes slower over time.
Also, the above process seems to block other packets (the queue does
not receives other packets).

More details:
(o) To generate tcp packets communications I use simple
     tcp server (port 1100) and tcp client that can send a packet with
    specific string or a packet without specific string.
(o) To reduce queue traffic I use the following expressions:
    iptables -I OUTPUT -p tcp --dport 1100  -j NFQUEUE  --queue-bypass
 --queue-num 0
    or
    nft insert rule ip filter output ip protocol tcp  tcp dport 1100
counter queue num 0

(o) I tried the platforms: ubuntu 18.04 (kernel 4.15.0)
                           ubuntu 19.04 (kernel 5.0.0)
                           ubuntu 12.04 (kernel 3.2.0)
                           oracle 7.5

All above platforms shows the same behavior with nfqnl_test.
After three weeks of debugging I really need your help.
Thanks.
Valeri
