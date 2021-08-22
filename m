Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_MUA_MOZILLA,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F60C4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B1E861247
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 16:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbhHVQYB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 12:24:01 -0400
Received: from relais-inet.orange.com ([80.12.70.34]:49404 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhHVQX7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 12:23:59 -0400
Received: from opfednr00.francetelecom.fr (unknown [xx.xx.xx.64])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by opfednr26.francetelecom.fr (ESMTP service) with ESMTPS id 4Gt0zN4VxzzysJ
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 18:23:12 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1629649392;
        bh=91kMWEtpHyHQb9zf3gWoziwzqSz47tApkyV3jsl9leE=;
        h=To:From:Subject:Message-ID:Date:MIME-Version:Content-Type:
         Content-Transfer-Encoding;
        b=RTOrP5y2wlAI4gVxk+QlFVmtUP0iXcIC1YWLOH3jtE/D6bq3vOwLCRSEo5P/aYJTh
         hdTR6n1j4YOQwN5eqrwNlkRwkryeZoD5/M6LjFYZ8gDH4WJjefh8pVwvnBN5RsoZB5
         7zhvzWBPmqxmR8SBjlfZcucInVCqSW1mgp7Jf35UhTJqwIx8bpelLnvZ3jfBke7dKd
         4plDR9dOIdSLLkoueyEX246pkRba750xoaAAjbVNJpS/w8fU6Ib7hQrHmCTZAPosM+
         sVzrbeQkvggV9eVXt8SNl/AdnGNg0GcffWOKHiE38DpFbTUtnqgBp6bw0OtVeWfrPl
         qzU7KwEZZ0Vuw==
Received: from Exchangemail-eme3.itn.ftgroup (unknown [xx.xx.50.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by opfednr00.francetelecom.fr (ESMTP service) with ESMTPS id 4Gt0zN3bjNzDq7Y
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 18:23:12 +0200 (CEST)
Received: from [10.193.4.89] (10.114.50.248) by exchange-eme3.itn.ftgroup
 (10.114.50.14) with Microsoft SMTP Server (TLS) id 14.3.498.0; Sun, 22 Aug
 2021 18:23:12 +0200
To:     <netfilter-devel@vger.kernel.org>
From:   <alexandre.ferrieux@orange.com>
Subject: Old good cBPF and program size
Message-ID: <19466_1629649392_612279F0_19466_497_1_07f3ddab-0bbe-7962-0ad5-709ecf3ae6ef@orange.com>
Date:   Sun, 22 Aug 2021 18:23:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.114.50.248]
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

While eBPF is all the rage, I keep starry eyes about the simplicity and power of 
old good cBPF: needs no complex toolchain, and lets you revive fond asm memories :)

I came across a situation where it was the silver bullet, but for one nagging 
limitation:

     #define XT_BPF_MAX_NUM_INSTR   64

hardcoded into a kernel header (xt_bpf.h).
My situation required a longer program (120 insns or so). This tends to happen 
when loops are not permitted, and the protocol to parse is DNS (which finds it 
funny to stick the most important field, RR, behind a variable number of 
variable length chunks, the FQDN words).

So I fixed that value, with a similar patch to the iptables executable, and of 
course that works beautifully: "-m bpf" with some headroom gives new perspectives :)

Now, I'm here to ask whether that ship has sailed or not: is cBPF considered a 
thing of the past, where any improvement would hinder eBPF adoption, or would 
people see some value in removing that nagging limitation (with a /proc tunable 
for instance, defaulting to the old value) ?

_________________________________________________________________________________________________________________________

Ce message et ses pieces jointes peuvent contenir des informations confidentielles ou privilegiees et ne doivent donc
pas etre diffuses, exploites ou copies sans autorisation. Si vous avez recu ce message par erreur, veuillez le signaler
a l'expediteur et le detruire ainsi que les pieces jointes. Les messages electroniques etant susceptibles d'alteration,
Orange decline toute responsabilite si ce message a ete altere, deforme ou falsifie. Merci.

This message and its attachments may contain confidential or privileged information that may be protected by law;
they should not be distributed, used or copied without authorisation.
If you have received this email in error, please notify the sender and delete this message and its attachments.
As emails may be altered, Orange is not liable for messages that have been modified, changed or falsified.
Thank you.

