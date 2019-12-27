Return-Path: <SRS0=2e0L=2R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61F05C2D0DB
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 03:50:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E00320838
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Dec 2019 03:50:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ps002pRs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbfL0Dut (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 26 Dec 2019 22:50:49 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:45023 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbfL0Dut (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 26 Dec 2019 22:50:49 -0500
Received: by mail-ot1-f67.google.com with SMTP id h9so32125528otj.11;
        Thu, 26 Dec 2019 19:50:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X28Eu+H0R7isIu0zMhh5cpt8djyO9YcV6tOOZlBOjtA=;
        b=Ps002pRsFpiGlXurUYOKlOUlQTwcmt9Q6Msftj/wo6iE/p9n+efTUlKmMelGuafCbH
         KxcGfwnnAHBxNNMBByAQh+2EQh2O4JylrCUPss5sVKzLeJOUHxm810YC7yIY+O7tPtHm
         LSzfAMROsIyGy0F887UTs3/8G9ri+iPCka1EPbh5fc6Cz31zFNHO3hv/J8RWOBRID9bf
         ExfQ4FGVCTmNzsByiBAJ5sWn88NETb8lcTSoLpZztVoyBzzdgfCBAw/yqqLjXGErbETk
         hm4xyoixBl6xnJCblKWsi4iOhgjnyX//3TegHJ6kmYF+me817RN4w2MZ4oL8rG9CPFjs
         Jp5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X28Eu+H0R7isIu0zMhh5cpt8djyO9YcV6tOOZlBOjtA=;
        b=ECUevmYBX7L94o6YQkUsdRWqxf5rjDcfYGAz3fqctKhu/io+QtaZMB/RdiamDZvF+F
         ZgNL5ia+msVL3ay2uj+QUH1Zu9xonhJAWI9QGP2GY09wLBzYLZJvf5ZJITt29jYW7FWz
         xNfQ0WQ9Em1EshrCJLvxXlnNO96V/gLs7N2nsaJ61VT5rUwDa8Di9DQkJX1lA7oQCGZV
         CSyfOAXU7GggfjQibu5RE8QJCTmZVECea/Du0SR7E1oDWAfqnUS/e+wcpIhH46Jc2RaI
         jpFEKnLjo3EWQu937nk9CIZ38LXylUG0eQIw3wfOBJmcaeV4Kct8z3KH9C/ZzccmG4NT
         9NgQ==
X-Gm-Message-State: APjAAAW1gucmpgsCJBp/TeyChulhlfE4n9aKIT6GksXdrNEbUaSpxI5E
        z2p3oo/16x9cYaqNYyE/NfcMAJyx2pFGrNr5MBA1Dg==
X-Google-Smtp-Source: APXvYqyFvQ5xTHNpfOBBoDOioPTSU2KACQ7735zB6ftXrFz34PGneyVA3GHsa1PWrkUojk9kHfFIUN/SUz2UapL2Qxo=
X-Received: by 2002:a9d:da2:: with SMTP id 31mr52278608ots.319.1577418648220;
 Thu, 26 Dec 2019 19:50:48 -0800 (PST)
MIME-Version: 1.0
References: <00000000000057fd27059aa1dfca@google.com> <00000000000015fd8f059aa682d3@google.com>
In-Reply-To: <00000000000015fd8f059aa682d3@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 26 Dec 2019 19:50:37 -0800
Message-ID: <CAM_iQpX7AfcuK6G94KYNxNoz3Lxvjat1nQ2p8sqLbPpMyy92sA@mail.gmail.com>
Subject: Re: general protection fault in xt_rateest_tg_checkentry
To:     syzbot <syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        kadlec@netfilter.org, LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Dec 26, 2019 at 6:47 PM syzbot
<syzbot+d7358a458d8a81aee898@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 3427b2ab63faccafe774ea997fc2da7faf690c5a
> Author: Cong Wang <xiyou.wangcong@gmail.com>
> Date:   Fri Mar 2 02:58:38 2018 +0000
>
>      netfilter: make xt_rateest hash table per net

Yes, net pointer is missing in initialization... I will send out a patch.

Thanks!
