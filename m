Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4DEDC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Jul 2022 07:48:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbiGVHsh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Jul 2022 03:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234351AbiGVHsd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Jul 2022 03:48:33 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446B243E5C
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2022 00:48:32 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id bf9so6340211lfb.13
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Jul 2022 00:48:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=nMVYuooHpuSRFWA94y31ZT+4CjOqQBQ0PcZ52rs1hb4=;
        b=cWywlRUj6Ipq0dLZq6D6HvuisiIbRXW6S9gufRzJF2HMJz2owHi0zcRPvDRftFU5WH
         sPeDWxIde2OsRH9zuPqsxcG4A/PazKlMev4DN1KEbhRb6gQBVQsV+7XVNYVNDA2FOoWE
         PXkI53jBpWW2lAta25hoEr8mSjOa+UZdcPdP/s3ccQKgySp+IsrNw8h6aVdDSV2Ohd1h
         ptpybKhCdp3xtwkKr+O6mWPJr72l7Yi8F0kpX1Xa+yOdNN5ccRk/WqIigHySnTYJjL4O
         0dx0Fb/fk5qnVb09sjN2YTghNljDixFEKGWeubmMMrTC1fhoNbsQN62N7dZDNXC0BZFl
         HqpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=nMVYuooHpuSRFWA94y31ZT+4CjOqQBQ0PcZ52rs1hb4=;
        b=Xd8lR/mKKKQybM5tqtdbjtekgcTrhBn4Rc0jColNYSjCC7REeZgK6nmOF/bVQm/sx1
         tfC+j+61pnQQYKwkM7f1PR+F6V2ST3CywAc+TORVsXU5UrUYr8GJnUs6z6MJQPw37Pxz
         rxz7pzhE4z8i23ebdkwxFotCVM8KyI71Papo3HIfYEnokhKHxGANR1jQTn/Xs9fst0SM
         JJ2XdhvWju0v+mxRI9AhhOlPOB/NSB1iTzf92OwevnEkq1hOvwmifjXpDv1uWrABUFI7
         HTw1TQ4PzG+RSIb8bpU6wNZ7n1w56rJlg2yS3XpoRAVBeR67AEOetJc6RuPE1d4+4swg
         4exg==
X-Gm-Message-State: AJIora/oLG76uemdPoacj1JvH6RV0VhJ1IdsugRlMrcanYVacOTFD8oG
        suMROtG9LqDRmjSAk3d9rhgn0czw4FTsg2EKoCpSOnyR4sE=
X-Google-Smtp-Source: AGRyM1sbdkTnCoRi3mtqCMkErh5O+pDMlPs+j2SuvXeNF181tS8glSR7dgDrbVyFUuZhSxy2VmKRS1ME9uVbuzXUxys=
X-Received: by 2002:a05:6512:3c99:b0:489:fe21:3a38 with SMTP id
 h25-20020a0565123c9900b00489fe213a38mr841548lfv.144.1658476110105; Fri, 22
 Jul 2022 00:48:30 -0700 (PDT)
MIME-Version: 1.0
From:   Eve Adam <adameve1981zero@gmail.com>
Date:   Fri, 22 Jul 2022 15:48:18 +0800
Message-ID: <CA+bdBU5gEpSOkhExTKE1Y-HvEg4gqFbSKiM8LVMb4-QZpLpDEA@mail.gmail.com>
Subject: A probable bug in nftables doc
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,

It seems that section 'ICMPV6 TYPE TYPE' and 'ICMPVX CODE TYPE' of
nftables doc have some problems:

The keyword of 'icmpv6 type type' probably should be 'icmpv6_type'
rather than 'icmpx_code';
meanwhile, the keyword of 'icmpvx code type' probably should be
'icmpx_code' rather than 'icmpv6_type'.

This issue can also be verified by typing the command 'nft describe
icmpv6_type' and 'nft describe icmpx_code' and comparing their actual
output with the output described by the doc.

I found the issue in 'nftables v0.9.8 (E.D.S.)'. But it is also the
case in the newest version v1.0.4.
v1.0.4 source code
(https://git.netfilter.org/nftables/tree/doc/data-types.txt?h=v1.0.4):

from line 267:

ICMPV6 TYPE TYPE
~~~~~~~~~~~~~~~~
[options="header"]
|==================
|Name | Keyword | Size | Base type
|ICMPv6 Type |
icmpx_code |
8 bit |
integer
|===================

from line 361:

ICMPVX CODE TYPE
~~~~~~~~~~~~~~~~
[options="header"]
|==================
|Name | Keyword | Size | Base type
|ICMPvX Code |
icmpv6_type |
8 bit |
integer
|===================
