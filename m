Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0BDC00140
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 04:43:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiHBEnh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Aug 2022 00:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232111AbiHBEng (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Aug 2022 00:43:36 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 52BE82DD
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 21:43:35 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.188:50892.2074169493
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-180.167.241.60 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id 9F9522800C3;
        Tue,  2 Aug 2022 12:43:33 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 788b3eca1487455995ae16f6f1cab7eb for pablo@netfilter.org;
        Tue, 02 Aug 2022 12:43:34 CST
X-Transaction-ID: 788b3eca1487455995ae16f6f1cab7eb
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
Date:   Tue, 2 Aug 2022 12:43:33 +0800
From:   "wenxu@chinatelecom.cn" <wenxu@chinatelecom.cn>
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Re: [PATCH nf-next v2 2/3] nf_flow_table_offload: offload the PPPoE encap in the flowtable
References: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>, 
        <1653548252-2602-2-git-send-email-wenxu@chinatelecom.cn>, 
        <YuetB9cZNovLFldA@salvia>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.2.23.121[cn]
Mime-Version: 1.0
Message-ID: <2022080212425107857025@chinatelecom.cn>
Content-Type: text/plain;
        charset="ISO-8859-1"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CgoKCgoKCgoKPj4gCgoKCj4+IEl0IGNhbiBzdXBwb3J0IGFsbCBraW5kcyBvZiBWTEFOIGRldiBw
YXRoOgoKCgo+PiBwcHBvZS0tPmV0aAoKCgo+PiBwcHBvZS0tPmJyMC4xMDAtLT5icjAodmxhbiBm
aWx0ZXIgZW5hYmxlKS0tPmV0aAoKCgo+PiBwcHBvZS0tPmV0aC4xMDAtLT5ldGgKCgoKPj4gCgoK
Cj4+IFRoZSBwYWNrZXQgeG1pdCBhbmQgcmVjdiBvZmZsb2FkIHRvIHRoZSAnZXRoJyBpbiBib3Ro
IG9yaWdpbmFsIGFuZAoKCgo+PiByZXBseSBkaXJlY3Rpb24uCgoKCj4KCgoKPlRoaXMgc2hvdWxk
IHByb3ZpZGUgYSBzaWduaWZpY2FudCBzcGVlZCB1cCBpbiBwYWNrZXQgZm9yd2FyZGluZywgc2lu
Y2UKCgoKPnBhY2tldHMgYXJlIG5vdCBwYXNzZWQgdXAgdG8gdXNlcnNwYWNlIGFueW1vcmUgdmlh
IHBwcCBkcml2ZXIuCgoKCj4KCgoKPkJUVywgd2hhdCB1c2Vyc3BhY2UgcHBwIHNvZnR3YXJlIGFy
ZSB5b3UgdXNpbmcgdG8gdGVzdCB0aGlzPwoKCgoKCgoKcHBwLng4Nl82NCA6IFRoZSBQb2ludC10
by1Qb2ludCBQcm90b2NvbCBkYWVtb24KCgoKCgoK

