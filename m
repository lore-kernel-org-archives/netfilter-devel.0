From: Shiyao Ma <i@introo.me>
Subject: How to add snat and dnat rules in a kernel module?
Date: Mon, 3 Jul 2017 03:02:55 +0800
Message-ID: <F2E1780C-190A-4DC0-9C04-DAF30A4BDDDE@introo.me>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36660 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751810AbdGBTC7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Jul 2017 15:02:59 -0400
Received: by mail-pf0-f196.google.com with SMTP id z6so23306256pfk.3
        for <netfilter-devel@vger.kernel.org>; Sun, 02 Jul 2017 12:02:59 -0700 (PDT)
Received: from [192.168.10.101] (n058152231085.netvigator.com. [58.152.231.85])
        by smtp.gmail.com with ESMTPSA id y192sm23525391pgd.38.2017.07.02.12.02.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Jul 2017 12:02:57 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I am writing a kernel module, and like to call some in-kernel =
iptables-nat functions to setup D/SNAT rules.

What's the relevant functions to call?

Thanks.=
