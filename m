Return-Path: <SRS0=Oskt=YH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.2 required=3.0 tests=DATE_IN_PAST_03_06,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08D68C4CECE
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 20:44:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BF6C820650
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Oct 2019 20:44:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QZ4cwLg8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387730AbfJNUoU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Oct 2019 16:44:20 -0400
Received: from mail-ed1-f41.google.com ([209.85.208.41]:38890 "EHLO
        mail-ed1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727879AbfJNUoU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Oct 2019 16:44:20 -0400
Received: by mail-ed1-f41.google.com with SMTP id l21so15970005edr.5
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Oct 2019 13:44:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=dnCxFx4bh0qEWcFsfns8kU21VGa+3iHV2MxZuOqDKWE=;
        b=QZ4cwLg8RmdIN2l8exGFCwE3pi0dSmygo8i/GMa3wHu1ub7G3ixaG6dTc/snD2yYov
         8h+Njj3es+xslpyj2qXDUFeiDHkvwl8Bv9wKqDhduHAjzrq1CFPBWLTpapuLKTXvUEW7
         nLaw/hFPADUSJv19QI3Sru80OlpAJlpOLEk6vxPlkgpKtz8Q61v7ZYJmZ+GtxK4W6IQm
         y4/nqghsFllTtLb5dko4JC8OrZ8z0DmrW9gb5f5JFKIZtjRszvySsud7ZcEC7R7g+liL
         BSg8lZ1rNHv4yLk3zBTH7Y6KsLjLJbuvfTiBnUWJzZQRq3o9AvqpcOS1yN5YoRB8Gpui
         hIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=dnCxFx4bh0qEWcFsfns8kU21VGa+3iHV2MxZuOqDKWE=;
        b=tqpklDQPa2oKRGBTIZ/44Q84TO5KGnFnwfinD60/prYB5hKENZuCRjZTfdgI+ldWY2
         U2buTWhWEbpJlqDf96VBIHU5HhdPBCauva35NJ7hHVDQ0TRSCas6olj/VEOoPl3hIVcO
         a+6Ach0plOdS12rhcD1O+6Spk0gn1oI7wdepX7kkTKgAPGQTFH+Ct8rc2o+OWj9XFG5u
         22PUnadGrksxqALroNOHNJXQAC24FSPZYFGF4MqHFgRUeEMqRXKzYe6kbaAgjVAl/Z87
         NJqeaMxx2JbOz8SXHdIdjHZM+qUWVEfYE2/ehxIgYEIFiZFf1L+T4unYtya//rTgC71F
         ZHGw==
X-Gm-Message-State: APjAAAVdmLPODxWJc1eWtolt5THKVKu/zzyfjuci3oTSTQB/Hu5oIkff
        CAmp5VV0uDV+LenbwiPXSBnATsUmdjVrksHTl/95UG62
X-Google-Smtp-Source: APXvYqzVaYMr4xSjJWisdbzupROB0fMe8ff1UTOqULzWEc6VBpA2ixQn/57bPstYwE9V3E/KoHrcJdjNmac/0cX+9ds=
X-Received: by 2002:a05:6402:21eb:: with SMTP id ce11mr29607370edb.182.1571085858553;
 Mon, 14 Oct 2019 13:44:18 -0700 (PDT)
MIME-Version: 1.0
From:   UDAY MEWADA <udaymewada1@gmail.com>
Date:   Mon, 14 Oct 2019 20:44:05 +0530
Message-ID: <CAA6WKfwC-pqFPCmsFnCDaRzvzxk7CuGw+7RW-rMu60=UOCB2Cw@mail.gmail.com>
Subject: First Contribution
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all !
My name is Uday Mewada, pursuing engineering in Computer Science.

I'm looking forward to contributing to Netfilter. Can someone guide me
how to start contributing in it and what are the initial bugs where I
can start.
