From: Feng Gao <gfree.wind@gmail.com>
Subject: Why ctinfo is IP_CT_RELATED_REPLY when reject with TCP RST
Date: Tue, 20 Sep 2016 22:21:09 +0800
Message-ID: <CA+6hz4pj1qSJV=NE_Yb8L0tx6xs4h1Hmh_TkyZHGbSZ8U1hUQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f42.google.com ([209.85.213.42]:35365 "EHLO
        mail-vk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752611AbcITOVS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2016 10:21:18 -0400
Received: by mail-vk0-f42.google.com with SMTP id g9so27692601vkg.2
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 07:21:18 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I could understand the ctinfo is IP_CT_RELATED_REPLY when reject with
ICMP. Because ICMP reply does not belong to the original conntrack.

But why it is IP_CT_RELATED_REPLY too when reject with TCP RST?
The RST reply should belong the original conntrack.

Is it expected or one bug? If it is one bug, I could try to fix it.

Regards
Feng
