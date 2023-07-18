Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07AF0C001DC
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Jul 2023 09:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjGRJNC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Jul 2023 05:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbjGRJNB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Jul 2023 05:13:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E83F10CC
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 02:12:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689671524;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9irW/amfKSY+RgabxLM2Ly8Qjgxj7lc/S7n5/HLmgDY=;
        b=U8dVa/3+d9ApcNjxHAva5QnlazzbjfWiWiSxTDHch6rzSIrWQXPNhNqAbQpwK/tOziJv3N
        jg5P7vQtRvZAisUPejWR3SHpZNmugpqVVyJr6CqdzDjNramiL0kgMP3hOuP3W+YppLou0a
        IwwsAagWK/FnODlqLmAHhYZ5SOO6e1M=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-38-G2zNqLFKPzS7U72zjltbIw-1; Tue, 18 Jul 2023 05:12:03 -0400
X-MC-Unique: G2zNqLFKPzS7U72zjltbIw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-521a6fa62a4so114007a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jul 2023 02:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689671522; x=1690276322;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9irW/amfKSY+RgabxLM2Ly8Qjgxj7lc/S7n5/HLmgDY=;
        b=Q8rYjjEmnq/g91giloqAlEfYIhYCSbHmnlAGVc5GIWj7SJhrhmZR4RkUje2PaKRaSd
         BFt/oF4vpIry+rD7yHHgeBzI5kOTsBIPNrczW10G+WLbIvb50YmQFL+YozYT+W6R1KzD
         u/UMCEyYJlQrEJK549a+Cnde8wxsGwNuSkWJUuu+nIAyzI4GQptnimoyAeA6ccL5pfQD
         CNWuUtk5LSexPypgcS1fOcB1COBcGHnx+i9h+30pKHX2EExj3XPGXVjPQpW2IFpjfXmb
         dSZJSQkNCRBzEqTk5mEYrvSrvZuAXQPr53CaGDcWSlaPxKHHI/acbXPPq7pSGKB1ZRwp
         kT1A==
X-Gm-Message-State: ABy/qLZNfSrwmFQNrNnY76ZJRfxmFHy79+ilwtRshbVehbgB60cyhnZH
        BCe+fH+ur6gM7Cf3Kx9KXw5G0/qoDNIhu6bwgnnX0XqAkRtVx/KhYSZX/GkBTkfEZOFhd7M3j/Q
        DF4rLsjecl4+fIHYoOVn2eplsFu23IJj8su7k
X-Received: by 2002:a05:6402:27ce:b0:51d:cfeb:fc3b with SMTP id c14-20020a05640227ce00b0051dcfebfc3bmr7885742ede.1.1689671521855;
        Tue, 18 Jul 2023 02:12:01 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHN47KrPFbnROTqHqnxJjfwjTfF4sBC7l+x1dBX5klH4c2xcWpZnBMSk2OvWxZupiiukCss3A==
X-Received: by 2002:a05:6402:27ce:b0:51d:cfeb:fc3b with SMTP id c14-20020a05640227ce00b0051dcfebfc3bmr7885723ede.1.1689671521458;
        Tue, 18 Jul 2023 02:12:01 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.189.9])
        by smtp.gmail.com with ESMTPSA id p3-20020a056402074300b0052177c077eesm908257edy.68.2023.07.18.02.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 02:12:01 -0700 (PDT)
Message-ID: <c3c52ce4239f94ab413bfa7c25a5707112229041.camel@redhat.com>
Subject: Re: [nft v2 PATCH 2/3] nftables: add input flag
 NFT_CTX_INPUT_NO_DNS to avoid blocking getaddrinfo()
From:   Thomas Haller <thaller@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Tue, 18 Jul 2023 11:12:00 +0200
In-Reply-To: <ZLEeZF3voEjlT12h@orbyte.nwl.cc>
References: <ZKxG23yJzlRRPpsO@calendula>
         <20230714084943.1080757-1-thaller@redhat.com>
         <20230714084943.1080757-2-thaller@redhat.com>
         <ZLEeZF3voEjlT12h@orbyte.nwl.cc>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gRnJpLCAyMDIzLTA3LTE0IGF0IDEyOjA3ICswMjAwLCBQaGlsIFN1dHRlciB3cm90ZToKPiBP
biBGcmksIEp1bCAxNCwgMjAyMyBhdCAxMDo0ODo1MkFNICswMjAwLCBUaG9tYXMgSGFsbGVyIHdy
b3RlOgo+ID4gCj4gPiArc3RhdGljIHZvaWQgcGFyc2VfY3R4X2luaXQoc3RydWN0IHBhcnNlX2N0
eCAqcGFyc2VfY3R4LCBjb25zdAo+ID4gc3RydWN0IGV2YWxfY3R4ICpjdHgpCj4gPiArewo+ID4g
K8KgwqDCoMKgwqDCoMKgKnBhcnNlX2N0eCA9IChzdHJ1Y3QgcGFyc2VfY3R4KSB7Cj4gPiArwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLnRibMKgwqDCoMKgPSAmY3R4LT5uZnQtPm91dHB1
dC50YmwsCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgLmlucHV0wqDCoD0gJmN0
eC0+bmZ0LT5pbnB1dCwKPiA+ICvCoMKgwqDCoMKgwqDCoH07Cj4gPiArfQo+IAo+IFRoaXMgaXMg
aW50ZXJlc3RpbmcgY29kaW5nIHN0eWxlLCBidXQgbG9va3MgbW9yZSBjb21wbGljYXRlZCB0aGFu
Cgo+IAo+ID4gcGFyc2VfY3R4LT50YmzCoMKgPSAmY3R4LT5uZnQtPm91dHB1dC50Ymw7Cj4gPiBw
YXJzZV9jdHgtPmlucHV0wqDCoMKgwqDCoMKgwqDCoD0gJmN0eC0+bmZ0LT5pbnB1dDsKPiAKPiB0
aG91Z2ggSSB3b3VsZCBqdXN0IGtlZXAgdGhlIGV4dHJhIGFzc2lnbm1lbnQgaW5saW5lIGxpa2Ug
c286Cgo+IAo+ID4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHBhcnNlX2N0eCBwYXJzZV9jdHggPSB7
IC50YmwgPSAmY3R4LT5uZnQtCj4gPiA+b3V0cHV0LnRibCwgfTsKPiA+ICvCoMKgwqDCoMKgwqDC
oHN0cnVjdCBwYXJzZV9jdHggcGFyc2VfY3R4ID0gewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoC50YmzCoMKgwqDCoD0gJmN0eC0+bmZ0LT5vdXRwdXQudGJsLAo+ID4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoC5pbnB1dMKgwqA9ICZjdHgtPm5mdC0+aW5wdXQsCj4g
PiArwqDCoMKgwqDCoMKgwqB9Owo+IAo+IENoZWVycywgUGhpbAoKSGksCgpJIHdpbGwgYWRkcmVz
cyB0aGlzIGluIGFuIHVwZGF0ZS4KClRob21hcwo=

