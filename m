Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F140DC433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Apr 2022 15:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiD1PZw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Apr 2022 11:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbiD1PZv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Apr 2022 11:25:51 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18ECB6E4E
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2022 08:22:36 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 0214532009A3
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Apr 2022 11:22:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 28 Apr 2022 11:22:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sbrecher.com; h=
        cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:message-id:mime-version:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1651159355; x=1651245755; bh=EGKGQ0wc69
        2IyyyVZ8GA/+rRRHrmuhwsV3CBQG3cHCQ=; b=BZvcEAXZFi0lb/UsCOngw5Duum
        s7QhdMQ3/TRRwqqSkecPW64xdFlHEiqxeJGvj7ZzRQlx7KarXaXFITqEZhVjkJs0
        j6pb+C+PKBZB4nIwwb+aRd7j60Rd1xXwAnwT4Qbpxe4du8+OmJT2B6XupqSmjyw2
        E5jXfLW8BC7d4kZHp3tjSmAefWAdWo+KXXwId4vwf1pZZDYP47Bu/npO3HW0jMSI
        /IJmDZH5b8de/Sna/sYGTAOW2QL/0qq0+uI9s4MaZqNEVHEx5XEp0pIjCwbKPFLI
        vXMH/8dcfbp0EjLtSqP3hSskUE802B/u/gUmopb9mcow+/oMfCarp+P9a2vQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:date:from:from:in-reply-to:message-id:mime-version
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1651159355; x=
        1651245755; bh=EGKGQ0wc692IyyyVZ8GA/+rRRHrmuhwsV3CBQG3cHCQ=; b=u
        Am8azeehgpF4B8wiaJWW6vbe7UBZrkcuxzkmdblAyWjNQp5F27YbVs9auTcW+GKp
        q5F4GOeiYgK2jYI6+J5KH2DEXRA0wOC6biwRRAuZ2LgAh2MuEbOgSYn8fJb9brZn
        ytmxk60jyRwp9kssVZRRZyokHeQHo9+AUK9bUOa4cykPP/HTNMsAwHuaVVoWbaQj
        72HkEkQ8mAorE0T8kzZKKGx7fHuzg+3GRAtl9VdgRJHKLt7WmR963ypTaRgfHpNP
        Qc8pktfLFKiOm3PDExKyvEkk68qIsmaqqUu+6klX/t6Dr6FL+gW2Pqz51NFr/7Bh
        aeBro5Yzlg1MZpMHNK5EQ==
X-ME-Sender: <xms:O7FqYsnd2456zNI6GzeetwP0-WL1hjR3O6raCqAZlmyj1YRazsOuXQ>
    <xme:O7FqYr0gImgj6NRYjumP25ZuwtTRxXcchaCddpm1XpPUr9v04VUZzSbn28TuLQ4gy
    7pUGp22wyVCmrMZGfs>
X-ME-Received: <xmr:O7FqYqoWjgs0VaYregGhbdpQGz7nvdtSqN1FAx1Qx4pamv-022TwttaxQ1ZuvIDOlGBxL8wDP7NPF7i2nWMrImyhHyFZku2KXmU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejgdekkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepkfffgggfvffhufgtgfesthejredttd
    efjeenucfhrhhomhepufhtvghvvgcuuehrvggthhgvrhcuoehsthgvvhgvsehssghrvggt
    hhgvrhdrtghomheqnecuggftrfgrthhtvghrnhepffekgfduvdfgieefheeftefhleegfe
    etgfegffeggfefteeutdehledtvdfggeeknecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepshhtvghvvgesshgsrhgvtghhvghrrdgtohhm
X-ME-Proxy: <xmx:O7FqYonOdyktjdAktH3Stj8S9Tt44CGsRPRfRK4V-vi8VU7Q9CFphg>
    <xmx:O7FqYq3KIbxLowQIM26hf7wpxhukId9EhtihiU42IMREQ4oiJh63Lw>
    <xmx:O7FqYvtV3dTHeyfkCErqVGo3LN2S-2nOW0xPpiCnpDxEcXClleJIgQ>
    <xmx:O7FqYjjO0CxUr1MOffWO0itYVerok1TVGFEm8xEoAMtSDfjQuI-PKQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA for
 <netfilter-devel@vger.kernel.org>; Thu,
 28 Apr 2022 11:22:34 -0400 (EDT)
Message-ID: <f7f0656d-4634-caad-c562-3121756f5afb@sbrecher.com>
Date:   Thu, 28 Apr 2022 08:22:34 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.0
To:     netfilter-devel@vger.kernel.org
Content-Language: en-US
From:   Steve Brecher <steve@sbrecher.com>
Subject: Minor issue in iptables(8) man page
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

The 4th section of the page, Tables, begins, "There are currently three 
independent tables ..." but lists four tables (filter, nat, mangle, and raw).

Steve

--
steve@sbrecher.com (Steve Brecher)
