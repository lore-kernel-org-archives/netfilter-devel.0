Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2C54C71149
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Aug 2023 14:16:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377696AbjHROPo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Aug 2023 10:15:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377663AbjHROPK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Aug 2023 10:15:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4394223
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 07:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692368046;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZeVMSXLPfL6xxlEnfaqxgRQq8UNYTLII8EdIIVyHIs8=;
        b=JTIO0dkrt2KKEawSan2ZUqTBc7tqVm2BOKunKrEZsMQpA59gKnA9dhfV/OVh3Gc8IWTYjY
        /o0fFFsgrGoyO7I2DJLLPgV8DfCFBb1Z498dW42YQz+bLkcFGrXySA53iXiUbH7709ZAuG
        JP+lwo85uuctssHf19wBROC9cQmJo8Q=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-oevVOWeaNSKVHg31hHjTfg-1; Fri, 18 Aug 2023 10:14:04 -0400
X-MC-Unique: oevVOWeaNSKVHg31hHjTfg-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3fe246ec511so2038525e9.1
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Aug 2023 07:14:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692368043; x=1692972843;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZeVMSXLPfL6xxlEnfaqxgRQq8UNYTLII8EdIIVyHIs8=;
        b=Y9Sc8cGQ2Wfc1DJtt1vejriYpHoaYjyUYY8cGigkSYKQlQnAXY5CgZMjghJMQzteQN
         0REVAkgoAH6MhxGZhR8SRvfs+fEaEmPVXE+JqKhaV9Xqe2xRqxyFHBQG3oXfoJfws2kK
         d1pnDQfBY/z5DDPN29nRju3qrZ5MtGwu/cjnFsXoLWp4MhfYhQrPowfDkuCu+hmrmSKB
         3M2nQhf7ZECi7icji+1Nfg0YXSP+JdK8ETLW/w3lrONqaalnKhTMP+umgGlgh1GS+XkH
         yKq4AxYkRhaXAL2d9X6cjhaCWc0ivNwH51ahIM9p19h1D/Q2mD/16N7t2T6yum/5OyEQ
         EuSw==
X-Gm-Message-State: AOJu0YznYFBaENrQB2gRGm7Gew4MKQiH0WXrhezrcL4sMngeRdwoXgWE
        bhL+Rg7zY/krYur+Mo0doGKVdlXR1YMNVJOgA4g/Iobr6kE2GS/ITVfElB2jTOSej9Y8p9U34lI
        Lr2WFszdkV6MGpMcuk1pIQnxDOphab4/U4vNF
X-Received: by 2002:a05:600c:3b0c:b0:3fa:9767:bb0 with SMTP id m12-20020a05600c3b0c00b003fa97670bb0mr2281144wms.0.1692368042970;
        Fri, 18 Aug 2023 07:14:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEmETJTV6g/hpQx3TlEdJ7VjHUcMGiSZIRGXeWwWLhQemDouBtCuOum5YNH06iJ9AXhrCiEWg==
X-Received: by 2002:a05:600c:3b0c:b0:3fa:9767:bb0 with SMTP id m12-20020a05600c3b0c00b003fa97670bb0mr2281129wms.0.1692368042601;
        Fri, 18 Aug 2023 07:14:02 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id z22-20020a7bc7d6000000b003fbfef555d2sm6408539wmk.23.2023.08.18.07.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Aug 2023 07:14:01 -0700 (PDT)
Message-ID: <5541fc793b4346e2f00eaf3e7f18c754053d8d00.camel@redhat.com>
Subject: Re: [nft PATCH v2] src: use reentrant
 getprotobyname_r()/getprotobynumber_r()/getservbyport_r()
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Fri, 18 Aug 2023 16:14:01 +0200
In-Reply-To: <ZN9AnetYNCRBODhb@calendula>
References: <20230810123035.3866306-1-thaller@redhat.com>
         <20230818091926.526246-1-thaller@redhat.com> <ZN9AnetYNCRBODhb@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGkgUGFibG8sCgpPbiBGcmksIDIwMjMtMDgtMTggYXQgMTE6NTcgKzAyMDAsIFBhYmxvIE5laXJh
IEF5dXNvIHdyb3RlOgo+IAo+ID4gLcKgwqDCoMKgwqDCoMKgc3RydWN0IHByb3RvZW50ICpwOwo+
ID4gLQo+ID4gwqDCoMKgwqDCoMKgwqDCoGlmICghbmZ0X291dHB1dF9udW1lcmljX3Byb3RvKG9j
dHgpKSB7Cj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcCA9IGdldHByb3RvYnlu
dW1iZXIobXB6X2dldF91aW50OChleHByLT52YWx1ZSkpOwo+ID4gLcKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoGlmIChwICE9IE5VTEwpIHsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbmZ0X3ByaW50KG9jdHgsICIlcyIsIHAtPnBfbmFtZSk7
Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgY2hhciBuYW1lWzEwMjRdOwo+IAo+
IElzIHRoZXJlIGFueSBkZWZpbml0aW9uIHRoYXQgY291bGQgYmUgdXNlZCBpbnN0ZWFkIG9mIDEw
MjQuIFNhbWUKPiBjb21tZW50IGZvciBhbGwgb3RoZXIgaGFyZGNvZGVkIGJ1ZmZlcnMuIE9yIG1h
eWJlIGFkZCBhIGRlZmluaXRpb24KPiBmb3IKPiB0aGlzPwoKQWRkZWQgZGVmaW5lcyBpbnN0ZWFk
LiBTZWUgdjMuCgpbLi4uXQoKPiA+IMKgI2luY2x1ZGUgPG5mdGFibGVzLmg+Cj4gPiDCoCNpbmNs
dWRlIDx1dGlscy5oPgo+ID4gQEAgLTEwNSwzICsxMDYsOTAgQEAgaW50IHJvdW5kX3Bvd18yKHVu
c2lnbmVkIGludCBuKQo+ID4gwqB7Cj4gPiDCoMKgwqDCoMKgwqDCoMKgcmV0dXJuIDFVTCA8PCBm
bHMobiAtIDEpOwo+ID4gwqB9Cj4gPiArCj4gCj4gQ291bGQgeW91IG1vdmUgdGhpcyBuZXcgY29k
ZSB0byBhIG5ldyBmaWxlIGluc3RlYWQgb2YgdXRpbHMuYz8gV2UgYXJlCj4gc2xvd2luZyBtb3Zp
bmcgdG93YXJkcyBHUEx2MiBvciBhbnkgbGF0ZXIgZm9yIG5ldyBjb2RlLiBQcm9iYWJseQo+IG5l
dGRiLmMgb3IgcGljayBhIGJldHRlciBuYW1lIHRoYXQgeW91IGxpa2UuCgpUaGlzIHJlcXVlc3Qg
bGVhdmVzIG1lIHdpdGggYSBsb3Qgb2YgY2hvaWNlcy4gSSBtYWRlIHRoZW0sIGJ1dCBJIGd1ZXNz
CnlvdSB3aWxsIGhhdmUgc29tZXRoaW5nIHRvIHNheSBhYm91dCBpdC4gU2VlIHYzLgoKPiAKPiA+
ICtib29sIG5mdF9nZXRwcm90b2J5bnVtYmVyKGludCBwcm90bywgY2hhciAqb3V0X25hbWUsIHNp
emVfdAo+ID4gbmFtZV9sZW4pCj4gPiArewo+ID4gK8KgwqDCoMKgwqDCoMKgY29uc3Qgc3RydWN0
IHByb3RvZW50ICpyZXN1bHQ7Cj4gPiArCj4gPiArI2lmIEhBVkVfREVDTF9HRVRQUk9UT0JZTlVN
QkVSX1IKPiA+ICvCoMKgwqDCoMKgwqDCoHN0cnVjdCBwcm90b2VudCByZXN1bHRfYnVmOwo+ID4g
K8KgwqDCoMKgwqDCoMKgY2hhciBidWZbMjA0OF07Cj4gPiArwqDCoMKgwqDCoMKgwqBpbnQgcjsK
PiA+ICsKPiA+ICvCoMKgwqDCoMKgwqDCoHIgPSBnZXRwcm90b2J5bnVtYmVyX3IocHJvdG8sCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoCAmcmVzdWx0X2J1ZiwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIGJ1ZiwKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVvZihidWYpLAo+ID4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAg
KHN0cnVjdCBwcm90b2VudCAqKikgJnJlc3VsdCk7Cj4gPiArwqDCoMKgwqDCoMKgwqBpZiAociAh
PSAwIHx8IHJlc3VsdCAhPSAmcmVzdWx0X2J1ZikKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqByZXN1bHQgPSBOVUxMOwo+ID4gKyNlbHNlCj4gPiArwqDCoMKgwqDCoMKgwqByZXN1
bHQgPSBnZXRwcm90b2J5bnVtYmVyKHByb3RvKTsKPiA+ICsjZW5kaWYKPiAKPiBJJ2Qgc3VnZ2Vz
dCB3cmFwIHRoaXMgY29kZSB3aXRoICNpZmRlZidzIGluIGEgaGVscGVyIGZ1bmN0aW9uLgoKSSBk
b24ndCB1bmRlcnN0YW5kLiBuZnRfZ2V0cHJvdG9ieW51bWJlcigpICppcyogdGhhdCBoZWxwZXIg
ZnVuY3Rpb24gdG8Kd3JhcCB0aGUgI2lmLiBUaGlzIHBvaW50IGlzIG5vdCBhZGRyZXNzZWQgYnkg
djMgKD8/KS4KCgoKdGhhbmtzLApUaG9tYXMK

