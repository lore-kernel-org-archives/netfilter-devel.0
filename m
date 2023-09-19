Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0111CD5BA9
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Sep 2023 12:31:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232069AbjISMbi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Sep 2023 08:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232051AbjISMbg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Sep 2023 08:31:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 958CAE3
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 05:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695126644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7qumu/cqCzdkCXmn60bQzer8ThDGGUMCMZZWFvgu3rs=;
        b=bqIt+yXpwvR4JHftdXpeSmxTNpB8lRJRFTJpCwBHjXSgc0yiUFud69eWKTX35QROihKqb/
        IQz5Ku+7t9QNn19mastJWDDwU6BhT1xjbNAArhLD9p9lgurkSF/VT+DddFIQFkXE3pt52f
        Bcw9k71Ikuh8CFrESZpdP1CB4Y3LCH8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-248-D-IiJwW1OxS9xOSuAMIIYA-1; Tue, 19 Sep 2023 08:30:41 -0400
X-MC-Unique: D-IiJwW1OxS9xOSuAMIIYA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-51e3bb0aeedso745754a12.0
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Sep 2023 05:30:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695126640; x=1695731440;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7qumu/cqCzdkCXmn60bQzer8ThDGGUMCMZZWFvgu3rs=;
        b=NqzqXNLW4ODiO5Rtc2v4gFicfks3vyYXN0Ui+gajYVFFIf/l/gMrsshB+ZQVS177Mi
         umLBIEhBmlS9MYChbbsWe2f6n0jI1WJe/E8NiL1fKLuFxgqwm+GRVm1GBFOJnGHD2CBM
         rTMWiTIy2/b9khSRsaAeG0m4+5SZF3bQGngfZkj9gSmMPaeJTdcT/z07bVyUpkApfStN
         PCB/G5QxjcFH6RsDSm4UbswLwBDkjb2WSQIHZzjsTlYG6P8JOOoU2f+K7VggVc60rDFy
         u1Knx7znWWY5lYB7HT0y3hJ8hOmJXUy35ZYI9uRj0Jklysk2UiHp8ETaHv4sDB9Mxv7L
         qFeQ==
X-Gm-Message-State: AOJu0YxPtrHyIU58gQxX9NadeiSoVY7MAxTi0ltTXnCi6X8uMKQBbcdm
        7xJzL/TBX2apuWG/fZ0sz3p2GLL6iSWHMW+21fJCr9eQI1EcODk1ru3ZigQucf01nv5RLAgb10W
        PKD13TjPgFLmPxWj6KPvkaCEw7VlsItAfpqie
X-Received: by 2002:a05:6402:2708:b0:522:e6b0:8056 with SMTP id y8-20020a056402270800b00522e6b08056mr9992503edd.4.1695126639804;
        Tue, 19 Sep 2023 05:30:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGcmAxjyLcxXAEQQ0zGMX8Id0v//wsuxvH+q9dx7iULtZAQcDTKh8gzLvfnFl8Fgvwav1mTFA==
X-Received: by 2002:a05:6402:2708:b0:522:e6b0:8056 with SMTP id y8-20020a056402270800b00522e6b08056mr9992486edd.4.1695126639407;
        Tue, 19 Sep 2023 05:30:39 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id n24-20020a5099d8000000b00530df581407sm4193905edb.35.2023.09.19.05.30.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Sep 2023 05:30:38 -0700 (PDT)
Message-ID: <38547bfa61da64801d1cb79f757b40ca1e0c44f4.camel@redhat.com>
Subject: Re: [PATCH nft 1/1] datatype: explicitly set missing datatypes for
 TYPE_CT_LABEL,TYPE_CT_EVENTBIT
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 19 Sep 2023 14:30:38 +0200
In-Reply-To: <ZQmRoKljTJJWEGx1@calendula>
References: <20230919112811.2752909-1-thaller@redhat.com>
         <ZQmRoKljTJJWEGx1@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gVHVlLCAyMDIzLTA5LTE5IGF0IDE0OjE4ICswMjAwLCBQYWJsbyBOZWlyYSBBeXVzbyB3cm90
ZToKPiBIaSBUaG9tYXMsCj4gCj4gT24gVHVlLCBTZXAgMTksIDIwMjMgYXQgMDE6Mjg6MDNQTSAr
MDIwMCwgVGhvbWFzIEhhbGxlciB3cm90ZToKPiA+IEl0J3Mgbm90IG9idmlvdXMgdGhhdCB0d28g
ZW51bSB2YWx1ZXMgYXJlIG1pc3NpbmcgKG9yIHdoeSkuCj4gPiBFeHBsaWNpdGx5Cj4gPiBzZXQg
dGhlIHZhbHVlcyB0byBOVUxMLCBzbyB3ZSBjYW4gc2VlIHRoaXMgbW9yZSBlYXNpbHkuCj4gCj4g
SSB0aGluayB0aGlzIGlzIHVuY292ZXJpbmcgYSBidWcgd2l0aCB0aGVzZSBzZWxlY3RvcnMuCj4g
Cj4gV2hlbiBjb25jYXRlbmF0aW9ucyBhcmUgdXNlZCwgSUlSQyB0aGUgZGVsaW5lcml6ZSBwYXRo
IG5lZWRzIHRoaXMuCj4gCj4gVFlQRV9DVF9FVkVOVEJJVCBkb2VzIG5vdCBuZWVkIHRoaXMsIGJl
Y2F1c2UgdGhpcyBpcyBhIHN0YXRlbWVudCB0bwo+IGdsb2JhbGx5IGZpbHRlciBjdG5ldGxpbmsg
ZXZlbnRzIGV2ZW50cy4KPiAKPiBCdXQgVFlQRV9DVF9MQUJFTCBpcyBsaWtlbHkgbm90IHdvcmtp
bmcgZmluZSB3aXRoIGNvbmNhdGVuYXRpb25zLgo+IAo+IExldCBtZSB0YWtlIGEgY2xvc2VyIGxv
b2suCgpIaSBQYWJsbywKClRoYW5rIHlvdS4KCkZZSSwgSSBoYXZlIGEgcGF0Y2ggd2l0aCBhIHVu
aXQgdGVzdCB0aGF0IHBlcmZvcm1zIHNvbWUgY29uc2lzdGVuY3kKY2hlY2tzIG9mIHRoZSAiZGF0
YXR5cGVzIiBhcnJheS4gT25seSBUWVBFX0NUX0xBQkVMICsgVFlQRV9DVF9FVkVOVEJJVAphcmUg
bWlzc2luZy4KCllvdSBkb24ndCBuZWVkIHRvIHdyaXRlIGEgdGVzdCBhYm91dCB0aGF0LiBUaGUg
dGVzdCBpcyBob3dldmVyIG9uIHRvcApvZiAgIm5vIHJlY3Vyc2l2ZSBtYWtlIiBwYXRjaGVzLCB3
aGljaCBJIHdpbGwgcmVzZW50IGF0IGEgbGF0ZXIgdGltZS4KCgpUaG9tYXMKCj4gCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBUaG9tYXMgSGFsbGVyIDx0aGFsbGVyQHJlZGhhdC5jb20+Cj4gPiAtLS0KPiA+
IMKgc3JjL2RhdGF0eXBlLmMgfCA0ICsrKy0KPiA+IMKgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQo+ID4gCj4gPiBkaWZmIC0tZ2l0IGEvc3JjL2RhdGF0eXBl
LmMgYi9zcmMvZGF0YXR5cGUuYwo+ID4gaW5kZXggNzBjODQ4NDZmNzBlLi5iYjBjM2NmNzkxNTAg
MTAwNjQ0Cj4gPiAtLS0gYS9zcmMvZGF0YXR5cGUuYwo+ID4gKysrIGIvc3JjL2RhdGF0eXBlLmMK
PiA+IEBAIC02NSw2ICs2NSw3IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZGF0YXR5cGUgKmRhdGF0
eXBlc1tUWVBFX01BWAo+ID4gKyAxXSA9IHsKPiA+IMKgwqDCoMKgwqDCoMKgwqBbVFlQRV9DVF9E
SVJdwqDCoMKgwqDCoMKgwqDCoMKgwqDCoD0gJmN0X2Rpcl90eXBlLAo+ID4gwqDCoMKgwqDCoMKg
wqDCoFtUWVBFX0NUX1NUQVRVU13CoMKgwqDCoMKgwqDCoMKgPSAmY3Rfc3RhdHVzX3R5cGUsCj4g
PiDCoMKgwqDCoMKgwqDCoMKgW1RZUEVfSUNNUDZfVFlQRV3CoMKgwqDCoMKgwqDCoD0gJmljbXA2
X3R5cGVfdHlwZSwKPiA+ICvCoMKgwqDCoMKgwqDCoFtUWVBFX0NUX0xBQkVMXcKgwqDCoMKgwqDC
oMKgwqDCoD0gTlVMTCwKPiA+IMKgwqDCoMKgwqDCoMKgwqBbVFlQRV9QS1RUWVBFXcKgwqDCoMKg
wqDCoMKgwqDCoMKgPSAmcGt0dHlwZV90eXBlLAo+ID4gwqDCoMKgwqDCoMKgwqDCoFtUWVBFX0lD
TVBfQ09ERV3CoMKgwqDCoMKgwqDCoMKgPSAmaWNtcF9jb2RlX3R5cGUsCj4gPiDCoMKgwqDCoMKg
wqDCoMKgW1RZUEVfSUNNUFY2X0NPREVdwqDCoMKgwqDCoMKgPSAmaWNtcHY2X2NvZGVfdHlwZSwK
PiA+IEBAIC03Miw4ICs3Myw5IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZGF0YXR5cGUgKmRhdGF0
eXBlc1tUWVBFX01BWAo+ID4gKyAxXSA9IHsKPiA+IMKgwqDCoMKgwqDCoMKgwqBbVFlQRV9ERVZH
Uk9VUF3CoMKgwqDCoMKgwqDCoMKgwqA9ICZkZXZncm91cF90eXBlLAo+ID4gwqDCoMKgwqDCoMKg
wqDCoFtUWVBFX0RTQ1BdwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA9ICZkc2NwX3R5cGUsCj4g
PiDCoMKgwqDCoMKgwqDCoMKgW1RZUEVfRUNOXcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqA9
ICZlY25fdHlwZSwKPiA+IC3CoMKgwqDCoMKgwqDCoFtUWVBFX0ZJQl9BRERSXcKgwqDCoMKgwqDC
oMKgwqAgPSAmZmliX2FkZHJfdHlwZSwKPiA+ICvCoMKgwqDCoMKgwqDCoFtUWVBFX0ZJQl9BRERS
XcKgwqDCoMKgwqDCoMKgwqDCoD0gJmZpYl9hZGRyX3R5cGUsCj4gPiDCoMKgwqDCoMKgwqDCoMKg
W1RZUEVfQk9PTEVBTl3CoMKgwqDCoMKgwqDCoMKgwqDCoD0gJmJvb2xlYW5fdHlwZSwKPiA+ICvC
oMKgwqDCoMKgwqDCoFtUWVBFX0NUX0VWRU5UQklUXcKgwqDCoMKgwqDCoD0gTlVMTCwKPiA+IMKg
wqDCoMKgwqDCoMKgwqBbVFlQRV9JRk5BTUVdwqDCoMKgwqDCoMKgwqDCoMKgwqDCoD0gJmlmbmFt
ZV90eXBlLAo+ID4gwqDCoMKgwqDCoMKgwqDCoFtUWVBFX0lHTVBfVFlQRV3CoMKgwqDCoMKgwqDC
oMKgPSAmaWdtcF90eXBlX3R5cGUsCj4gPiDCoMKgwqDCoMKgwqDCoMKgW1RZUEVfVElNRV9EQVRF
XcKgwqDCoMKgwqDCoMKgwqA9ICZkYXRlX3R5cGUsCj4gPiAtLSAKPiA+IDIuNDEuMAo+ID4gCj4g
Cgo=

