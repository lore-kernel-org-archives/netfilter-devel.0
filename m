Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90D3BC00140
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 04:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbiHBEkH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Aug 2022 00:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiHBEkG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Aug 2022 00:40:06 -0400
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8E1D3E0B2
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 21:40:05 -0700 (PDT)
HMM_SOURCE_IP: 172.18.0.48:37986.1144032876
HMM_ATTACHE_NUM: 0000
HMM_SOURCE_TYPE: SMTP
Received: from clientip-180.167.241.60 (unknown [172.18.0.48])
        by chinatelecom.cn (HERMES) with SMTP id D24492800AE;
        Tue,  2 Aug 2022 12:40:00 +0800 (CST)
X-189-SAVE-TO-SEND: wenxu@chinatelecom.cn
Received: from  ([172.18.0.48])
        by app0024 with ESMTP id 9ccec09d885c4b43b74a3ea576a20e43 for pablo@netfilter.org;
        Tue, 02 Aug 2022 12:40:01 CST
X-Transaction-ID: 9ccec09d885c4b43b74a3ea576a20e43
X-Real-From: wenxu@chinatelecom.cn
X-Receive-IP: 172.18.0.48
X-MEDUSA-Status: 0
Sender: wenxu@chinatelecom.cn
Date:   Tue, 2 Aug 2022 12:40:00 +0800
From:   "wenxu@chinatelecom.cn" <wenxu@chinatelecom.cn>
To:     "Pablo Neira Ayuso" <pablo@netfilter.org>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
Subject: Re: Re: [PATCH nf-next v2 1/3] nf_flow_table_offload: offload the vlan encap in the flowtable
References: <1653548252-2602-1-git-send-email-wenxu@chinatelecom.cn>, 
        <Yuerh8IrTVa35dIs@salvia>
X-Priority: 3
X-Has-Attach: no
X-Mailer: Foxmail 7.2.23.121[cn]
Mime-Version: 1.0
Message-ID: <2022080212395929523424@chinatelecom.cn>
Content-Type: text/plain;
        charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

CgoKCj4+ICtzdGF0aWMgdm9pZCBuZl9mbG93X2VuY2FwX3B1c2goc3RydWN0IHNrX2J1ZmYgKnNr
YiwKPj4gKwkJCcKgwqDCoMKgwqDCoCBzdHJ1Y3QgZmxvd19vZmZsb2FkX3R1cGxlX3JoYXNoICp0
dXBsZWhhc2gpCj4+ICt7Cj4+ICsJaW50IGk7Cj4+ICsKPj4gKwlmb3IgKGkgPSAwOyBpIDwgdHVw
bGVoYXNoLT50dXBsZS5lbmNhcF9udW07IGkrKykgewo+PiArCQlzd2l0Y2ggKHR1cGxlaGFzaC0+
dHVwbGUuZW5jYXBbaV0ucHJvdG8pIHsKPj4gKwkJY2FzZSBodG9ucyhFVEhfUF84MDIxUSk6Cj4+
ICsJCWNhc2UgaHRvbnMoRVRIX1BfODAyMUFEKToKPj4gKwkJCXNrYl92bGFuX3B1c2goc2tiLAo+
Cj5OaXQ6IHNrYl92bGFuX3B1c2goKSBtaWdodCBmYWlsLgoKCgo+CgoKClRoZSBwYWNrZXQgbWF5
YmUgbW9kaWZpZWQuICBTbyBtYXliZSBvbmx5IGRyb3AgdGhpcyBwYWNrZXQgaWYgc2tiX3ZsYW5f
cHVzaCBmYWlsZWQ/IAoK

