Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.2 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A21EC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 22:26:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E030D611F2
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Sep 2021 22:26:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbhIJW2B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Sep 2021 18:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhIJW2A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Sep 2021 18:28:00 -0400
X-Greylist: delayed 139 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Sep 2021 15:26:48 PDT
Received: from mxd1.seznam.cz (mxd1.seznam.cz [IPv6:2a02:598:a::78:210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 614BBC061574
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Sep 2021 15:26:48 -0700 (PDT)
Received: from email.seznam.cz
        by email-smtpc13a.ko.seznam.cz (email-smtpc13a.ko.seznam.cz [10.53.11.135])
        id 455a59105b3fb15445cbf2ff;
        Sat, 11 Sep 2021 00:26:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=email.cz; s=beta;
        t=1631312806; bh=qGpZ93tC47u8NjKwWZiPmmGB3V/DX8Z68HYjpn7lnYg=;
        h=Received:From:To:Subject:Date:Message-Id:Mime-Version:X-Mailer:
         Content-Type:Content-Transfer-Encoding;
        b=XLS32njg/2dX7b3Gon+WWGTIaCr871n2byp1CKZ3XrHQ4TY1vwOHvPzg5OsKsNCLE
         G1Ncx1NFgY0657NG/YTRe+iv0oUXfb+v3gTp3qQC2YzeA8fh5M7Hvobg/wr6cYWyJO
         laSOHH/iDtGi15Os4JGwWEa+KXukFVdHAmMvJ9oY=
Received: from unknown ([::ffff:176.114.242.3])
        by email.seznam.cz (szn-ebox-5.0.79) with HTTP;
        Sat, 11 Sep 2021 00:24:23 +0200 (CEST)
From:   <kaskada@email.cz>
To:     <netfilter-devel@vger.kernel.org>
Subject: module ipp2p (xtables) for ip6tables? No such file or directory...
Date:   Sat, 11 Sep 2021 00:24:23 +0200 (CEST)
Message-Id: <Tj.aVNM.6d2PRLDYSwa.1XEziN@seznam.cz>
Mime-Version: 1.0 (szn-mime-2.1.14)
X-Mailer: szn-ebox-5.0.79
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello forum,

I`m trying to use this ip6tables rule (similar I`m used to use in iptables=
):

ip6tables -t mangle -A PREROUTING -m ipp2p --dc -j ACCEPT

But I get only this error:

ip6tables v1.8.4 (legacy): Couldn't load match `ipp2p':No such file or dir=
ectory
Try `ip6tables -h' or 'ip6tables --help' for more information.

I`m running pkg-xtables-addons-debian-3.18-1 (compiled from sources) on De=
bian 10 and iptables variant works as expected:
iptables -m ipp2p --help
iptables v1.8.4
Usage: iptables -[ACD] chain rule-specification [options]
...

What am I doing wrong, please? Or it seems ip6tables are not supported by =
ipp2p module?

Thank you, Pep.
