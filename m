Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA0BCA0ECA
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Sep 2023 07:19:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231526AbjILHTe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Sep 2023 03:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjILHT3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Sep 2023 03:19:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 813C7B9
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 00:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694503120;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R2DP0mh+qiAKxJX/Y0qKdzsFg9DPFQ0r0tE8Kf/GBoA=;
        b=iOTWL5VdblPg6X2vjZox5V/6U4CXzxtT5237+0lv7SUBEcA8/aSFcr7sa5FOG4GQSIi6yQ
        /OZJvMLMYgFiZIc+uQSt87dSpsMfumcorrZw5UKy54BGl/hwlOE42864V/VwVaq45uPHHr
        o7apyivYbJIXDF8MpBUcp7Z7suvxHYM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-417-tC8GpJOSPFSWtaSr3PCGCQ-1; Tue, 12 Sep 2023 03:18:38 -0400
X-MC-Unique: tC8GpJOSPFSWtaSr3PCGCQ-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-319553c466dso485732f8f.1
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Sep 2023 00:18:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694503117; x=1695107917;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R2DP0mh+qiAKxJX/Y0qKdzsFg9DPFQ0r0tE8Kf/GBoA=;
        b=WZ/lHCZlJ6KHCQbaNTit9EYwcgkID962f5JydSCJ8EfLmHkNzN+8hNq8Tw1hRNcCDt
         LUSKrdrEb9mDlx8OAJoEAw9soY0xT+CVzB9m0029s6vBvp53ok2engRflLeZz5MjCSAz
         dep0t1N/lyWSKWOP4rlfyXyRJNHh3YgQA4Nd67FD2aFxrJsN3KzamQSY9kMdudYN/fux
         ZE5RNWYmGFJ5vcTtdbibCGtXjM0wZ0fEy+Zow2WZswLWwMC+FWL/2+4GLnnyrk5iRupR
         a07zSMmoOwrBLe8rgMbtmXFGkHORz8y3J96OIf+iKUmH7ltkxZycQbkqTnENAYZPrVpg
         Sxkw==
X-Gm-Message-State: AOJu0Yy/lhsl/ZS7wjVpT5VtyrZUo6sOtSGY0Rl9GH0XniwqFPWaf0Zx
        lcl3DV5T4+gMUjj515u85NCXpuA7ntCgq3GeiBtcDbkADTdJyxMmhVBqd3cQd7iI0YarmYw3MwO
        8QhvNCpQA+rlqd94FS9CnHKILeWjwYBinRJTx59w=
X-Received: by 2002:a05:6000:136f:b0:317:73e3:cf41 with SMTP id q15-20020a056000136f00b0031773e3cf41mr8599069wrz.1.1694503116979;
        Tue, 12 Sep 2023 00:18:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGfzU3Tba6ML8Jb++src49O2qbg3VnvOIEUiXCw8T5MftOAu/hWU9CCEVADugpmIEsOOE09Rw==
X-Received: by 2002:a05:6000:136f:b0:317:73e3:cf41 with SMTP id q15-20020a056000136f00b0031773e3cf41mr8599057wrz.1.1694503116581;
        Tue, 12 Sep 2023 00:18:36 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id a16-20020a5d4570000000b00317f70240afsm12057971wrc.27.2023.09.12.00.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 00:18:35 -0700 (PDT)
Message-ID: <0c61700ba841fa0aed32e99476a675aa325ce97f.camel@redhat.com>
Subject: Re: [nft PATCH] datatype: fix leak and cleanup reference counting
 for struct datatype
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 12 Sep 2023 09:18:34 +0200
In-Reply-To: <ZP+JBMa83ArN1FQD@calendula>
References: <20230911090106.635361-1-thaller@redhat.com>
         <ZP+JBMa83ArN1FQD@calendula>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGkgUGFibG8sCgo+ID4gQEAgLTM4MDYsMzcgKzM4MzMsNDMgQEAgc3RhdGljIGludCBzdG10X2V2
YWx1YXRlX25hdF9tYXAoc3RydWN0Cj4gPiBldmFsX2N0eCAqY3R4LCBzdHJ1Y3Qgc3RtdCAqc3Rt
dCkKPiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgZGF0YXR5cGVfc2V0KGRhdGEsIGR0eXBlKTsK
PiAKPiBOb3RlIGhlcmUgYWJvdmUsIGR0eXBlIGlzIHNldCB0byBkYXRhIGV4cHJlc3Npb24sIHRo
ZW4uLi4KPiAKPiA+IMKgCj4gPiAtwqDCoMKgwqDCoMKgwqBpZiAoZXhwcl9vcHMoZGF0YSktPnR5
cGUgIT0gRVhQUl9DT05DQVQpCj4gPiAtwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcmV0
dXJuIF9fc3RtdF9ldmFsdWF0ZV9hcmcoY3R4LCBzdG10LCBkdHlwZSwgZHR5cGUtCj4gPiA+c2l6
ZSwKPiA+ICvCoMKgwqDCoMKgwqDCoGlmIChleHByX29wcyhkYXRhKS0+dHlwZSAhPSBFWFBSX0NP
TkNBVCkgewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHIgPSBfX3N0bXRfZXZh
bHVhdGVfYXJnKGN0eCwgc3RtdCwgZHR5cGUsIGR0eXBlLQo+ID4gPnNpemUsCj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqAgQllURU9SREVSX0JJR19FTkRJQU4sCj4gPiDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAgJnN0bXQtPm5hdC5hZGRyKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBnb3RvIG91dDsKPiAKPiAuLi4gdGhpcyBnb3RvIGlzIG5vdCBuZWVkZWQg
YW55bW9yZT8gZHR5cGUgaGFzIGJlZW4gYWxyZWFkeSBzZXQgdG8KPiBkYXRhLgo+IFNvIHRoaXMg
cGF0Y2ggY2FuIGJlIHNpbXBsaWZpZWQuIFNhbWUgdGhpbmdzIGZvciBnb3RvIGJlbG93IGluIHRo
ZQo+IHNjb3BlIG9mIHRoaXMgZnVuY3Rpb24uCgpBZnRlciBkYXRhdHlwZV9zZXQoZGF0YSwgZHR5
cGUpIHRoZSByZWZlcmVuY2UgdG8gImR0eXBlIiBtdXN0IHN0aWxsIGJlCnJlbGVhc2VkLiBUaGUg
c2ltcGxlIHdheSBpcwoKICAgZGF0YXR5cGVfc2V0KGRhdGEsIGR0eXBlKTsKICAgZGF0YXR5cGVf
ZnJlZShkdHlwZSk7CiAgIGR0eXBlID0gTlVMTDsKCmFuZCBtYWtlIHN1cmUgdG8gbm90IHVzZSAi
ZHR5cGUiIGFmdGVyd2FyZHMsIGJ1dCBkYXRhLT5kdHlwZS4KCkJ1dCB0aGVyZSBhcmUgYWxyZWFk
eSAiZ290byBvdXQiIGVhcmxpZXIuIFNvIHRoaXMgY2hhbmdlIG9mIGNsZWFudXAtCnN0eWxlIGhh
bGZ3YXkgdGhyb3VnaCBpcyBlcnJvciBwcm9uZS4gV2UgY291bGQgYWxzbyBkcm9wIHRoZSBvdGhl
cgoiZ290byBvdXQiIGFuZCBleHBsaWNpdGx5IGltcGxlbWVudCBjbGVhbnVwIGF0IHRoZSBtdWx0
aXBsZSBleGl0IHBvaW50cwpvZiB0aGUgZnVuY3Rpb24uIEJ1dCB0aGF0J3MgYWxzbyBlcnJvciBw
cm9uZSBhbmQgcmVkdW5kYW50LgoKVGhlIHNhZmUgdGhpbmcgaXMgdG8gYmUgdmVyeSBjbGVhciB3
aGljaCB2YXJpYWJsZSBob2xkcyBhIHJlZmVyZW5jZQooZHR5cGUpLCBhbmQgYWx3YXlzK29ubHkg
cmVsZWFzZSBpdCBhdCB0aGUgZW5kIChnb3RvIG91dCkuCgpUaGUgcmVhbCBzb2x1dGlvbiB0byBh
bGwgb2YgdGhpcyB3b3VsZCBiZSBfX2F0dHJpYnV0ZV9fKChjbGVhbnVwKSkgYW5kCmxldCB0aGUg
Y29tcGlsZXIgaGVscC4gVW5sZXNzIHRoYXQgaXMgdXNlZCwgYSBjb25zaXN0ZW50IGBnb3RvIG91
dGAgaXMKdGhlIGNsZWFuZXN0IHNvbHV0aW9uLgoKSXQncyBhYm91dCBjb25zaXN0ZW50bHkgZG9p
bmcgImdvdG8gb3V0IiwgYW5kIG5vdCB0aGF0IHlvdSBjb3VsZCByZXdvcmsKb25lICJnb3RvLW91
dCIgd2l0aCBzb21ldGhpbmcgZWxzZSB0byBzYWZlIGEgZmV3IGxpbmVzIG9mIGNvZGUuIE9uY2Ug
d2UKZG8gImdvdG8gb3V0IiwgdGhlcmUgaXMgbm8gbmVlZCB0cnlpbmcgdG8gcmVsZWFzZSByZWZl
cmVuY2VzIGVhcmx5IG9yCmRvIGFueXRoaW5nIHNtYXJ0IHdpdGggdHJhbnNmZXJyaW5nIG93bmVy
c2hpcC4KCgo+ID4gQEAgLTk3OCw3ICs5ODMsOCBAQCBzdHJ1Y3Qgc2V0ICpuZXRsaW5rX2RlbGlu
ZWFyaXplX3NldChzdHJ1Y3QKPiA+IG5ldGxpbmtfY3R4ICpjdHgsCj4gPiDCoMKgwqDCoMKgwqDC
oMKgaWYgKGtleXR5cGUgPT0gTlVMTCkgewo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBuZXRsaW5rX2lvX2Vycm9yKGN0eCwgTlVMTCwgIlVua25vd24gZGF0YSB0eXBlIGluCj4g
PiBzZXQga2V5ICV1IiwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAga2V5KTsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqByZXR1cm4gTlVMTDsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBzZXQgPSBOVUxMOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0
Owo+IAo+IFdoeSB0aGlzIGdvdG8gb3V0PyBOb3QgcmVhbGx5IG5lZWRlZC4KCk5vLCBpdCdzIG5v
dCBuZWVkZWQgZm9yIHRlY2huaWNhbCByZWFzb25zLiBJdCdzIHRoZXJlIGZvciBjb25zaXN0ZW5j
eQpyZWdhcmRpbmcgdGhlIHJlbGVhc2Ugb2YgdGhlIHBvaW50ZXJzLiBBbnl3YXksIEkgZHJvcCB0
aGlzLgoKSSB3aWxsIGxhdGVyIHByb3Bvc2UgYSBwYXRjaCB1c2luZyBfX2F0dHJpYnV0ZV9fKChj
bGVhbnVwKSkgZm9yCmNvbXBhcmlzb24uCgoKPiAKPiA+IMKgwqDCoMKgwqDCoMKgwqB9Cj4gPiDC
oAo+ID4gwqDCoMKgwqDCoMKgwqDCoGZsYWdzID0gbmZ0bmxfc2V0X2dldF91MzIobmxzLCBORlRO
TF9TRVRfRkxBR1MpOwo+ID4gQEAgLTk5MSw4ICs5OTcsOCBAQCBzdHJ1Y3Qgc2V0ICpuZXRsaW5r
X2RlbGluZWFyaXplX3NldChzdHJ1Y3QKPiA+IG5ldGxpbmtfY3R4ICpjdHgsCj4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBuZXRsaW5rX2lvX2Vycm9y
KGN0eCwgTlVMTCwKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJVbmtub3duIGRhdGEgdHlw
ZSBpbiBzZXQKPiA+IGtleSAldSIsCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBkYXRhKTsK
PiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZGF0YXR5
cGVfZnJlZShrZXl0eXBlKTsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIE5VTEw7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoHNldCA9IE5VTEw7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGdvdG8gb3V0Owo+ID4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqB9Cj4gPiDCoMKgwqDCoMKgwqDCoMKgfQo+ID4gwqAKPiA+IEBAIC0xMDMw
LDE5ICsxMDM2LDE4IEBAIHN0cnVjdCBzZXQgKm5ldGxpbmtfZGVsaW5lYXJpemVfc2V0KHN0cnVj
dAo+ID4gbmV0bGlua19jdHggKmN0eCwKPiA+IMKgwqDCoMKgwqDCoMKgwqBpZiAoZGF0YXR5cGUp
IHsKPiAKPiBNb3ZlIHRoaXMgY29kZSB1bmRlciB0aGlzIGlmIChkYXRhdHlwZSkgYnJhbmNoIGlu
dG8gZnVuY3Rpb24gaW4gYQo+IHByZXBhcmF0aW9uIHBhdGNoLgo+IAo+IFBsZWFzZSwgY2FsbCBp
dDoKPiAKPiDCoMKgwqDCoMKgwqDCoCBuZXRsaW5rX2RlbGluZWFyaXplX3NldF90eXBlb2YoKQo+
IAo+IG9yIHBpY2sgYSBiZXR0ZXIgbmFtZSBpZiB5b3UgbGlrZSBzbyB0aGVyZSBpcyBubyBuZWVk
IGZvciBkdHlwZTIuCj4gCj4gSXQgd2lsbCBoZWxwIGNsZWFuIHVwIHRoaXMgY2h1bmsgdGhhdCB5
b3UgYXJlIHBhc3NpbmcgYnkgaGVyZS4KCk5vdCBzdXJlIGhvdyB0byBkbyB0aGF0LiBGb3Igb25l
LCB0aGUgaWYtYmxvY2sgaXMgb25seSB1c2VkIGF0IG9uZQpwbGFjZS4gU28gdGhlIGZ1bmN0aW9u
IGlzbid0IHJlYWxseSByZXVzYWJsZSAob3Igd2hlcmUgY2FuIEkgYWxzbyByZXVzZQppdCk/LiBB
bHNvLCBpdCB1c2VzIHF1aXRlIG1hbnkgbG9jYWwgdmFyaWFibGVzLiBJZiBhbGwgdGhvc2UgYmVj
b21lCmZ1bmN0aW9uIHBhcmFtZXRlcnMsIGl0J3MgY29uZnVzaW5nLiBJZiBJIG1vdmUgb25seSBh
IHN1YnNldCBvZiB0aGUKYmxvY2sgdG8gdGhlIG5ldyBmdW5jdGlvbiwgaXQncyBub3QgY2xlYXIg
aG93IGl0IHNpbXBsaWZpZXMgYW55dGhpbmcuIEkKdGhpbmsgdGhlcmUgaXMgbm90IGEgc3VmZmlj
aWVudGx5IGlzb2xhdGVkIGZ1bmN0aW9uYWxpdHksIHRoYXQgd2FycmFudHMKYSBmdW5jdGlvbi4K
Cm5ldGxpbmtfZGVsaW5lYXJpemVfc2V0KCkgaXMgbGFyZ2UgYW5kIGFsbG9jYXRlcyB1cCB0byA0
IGRhdGF0dHlwZXMKdGhhdCB3ZSBuZWVkIHRvIHJlbGVhc2UgKGRhdGF0eXBlLCBrZXl0eXBlLCBk
dHlwZTIsIGR0eXBlKS4gV2l0aCB0aGUKcGF0Y2gsIHRoZSBwYXR0ZXJuIGlzIHZlcnkgc2ltcGxl
LCB0aGF0IHRob3NlIDQgdmFyaWFibGVzIGdldCBvbmx5CmFzc2lnbmVkIGF0IG9uZSBwbGFjZSwg
YW5kIGFsd2F5cyByZWxlYXNlZCBvbmx5IGF0IHRoZSBlbmQgKGdvdG8gb3V0KS4KTW92aW5nIHRo
ZSBibG9jayB0byBhIHNlcGFyYXRlIGZ1bmN0aW9uLCBhdCBtb3N0IHNhZmVzIGR0eXBlMiBidXQK
ZG9lc24ndCByZW1vdmUgdGhlIGdlbmVyYWwgbmVlZCBmb3Igc3VjaCByZWxlYXNlLWF0LWVuZC4g
SWYgSSByZWFsbHkKd2FudGVkLCBJIGNvdWxkIG1vdmUgZHR5cGUyIGluc2lkZSB0aGUgaWYtYmxv
Y2suIEJ1dCB0aGF0IGRvZXNuJ3Qgc2VlbQp1c2VmdWwsIGdpdmVuIHRoZXJlIGlzIGEgY29uc2lz
dGVudCBSQUlJLWxpa2UgY2xlYW51cCBtZWNoYW5pc20gaW4KcGxhY2UuCgoKCk90aGVyIHBvaW50
cyB3aWxsIGJlIGZpeGVkIGluIHYyLgoKVGhvbWFzCg==

