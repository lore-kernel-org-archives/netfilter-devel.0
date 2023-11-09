Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59145C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 Nov 2023 17:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231475AbjKIRDu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 Nov 2023 12:03:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjKIRDt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Nov 2023 12:03:49 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4853E2715
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Nov 2023 09:03:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1699549380;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=5YlC2xmpgqilPeY2cftVoR70e7UiEA/Thloo0s+n7Fs=;
        b=K+lAeNCo23jNEEUq3GOsz+xMg16r2e27Y3kiMxe3zpqd/596YwP0pocYjNezkiipZ8ulS7
        iJXKv5ktZuILm+ecqf1fBVMco97Gcc90MO/o1KTRq2rrfDfhkh/e9N83y7HKyWRtwvyUxt
        4HcH064a7imQLrTbfmCQBZJzEUBrCWI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-52-9WkqlNEiP6avqBuLPIf14A-1; Thu, 09 Nov 2023 12:02:54 -0500
X-MC-Unique: 9WkqlNEiP6avqBuLPIf14A-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4084b6f4515so2437015e9.1
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Nov 2023 09:02:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699549373; x=1700154173;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5YlC2xmpgqilPeY2cftVoR70e7UiEA/Thloo0s+n7Fs=;
        b=GplT+dWBYIU408VPWiFVgyZXwi7JwfcscJU2Ai44qYXlNpX5xDm8dL+oGbNpgrkYuz
         UusjQBsf0Dl4cyeHlHpy6d/SD7fU5Nz49UnVWDQnijrfZ0XWtka+9P4pjtn1OtWG8Smd
         4NNDummwaxRHgPH8OolRcT0Yp4z9Cvq+pDnnvDG3hJwE0C1RQiB3Frr91v+P0WAhXWEU
         aErQ+mKMQ0Ay8rDtt0ZbLbKCDuKTQSufHazgpS2qBR79PcwFF6D30tvSxFLlWOfCq91N
         kyq3oCTDRLy1qgr92CJklCIjANV4FyqXcJncFfNfEq5oqVGLsPfAFTb+lSl+iz0akcHC
         Fz6A==
X-Gm-Message-State: AOJu0YwnOgYvS2aUUw+NrKR3c3BQ9oUgV0M1TgMUEBQwfrsNR+Ae97FD
        mW9LA1UDMKyY23hWs1tNcPmnD1mPp7k0Tv315nM5QT+9j35awJ447pGCsUeC1/CIIqWNO4Ufitq
        wzA0ix6BlbSXUOdtxgTu6F2gL00ftC0W+vKfF
X-Received: by 2002:a5d:5984:0:b0:32f:5e07:f53e with SMTP id n4-20020a5d5984000000b0032f5e07f53emr4603912wri.4.1699549373046;
        Thu, 09 Nov 2023 09:02:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEyzKvjh1VD+vt6L7PckAZ7HsR7GFw4bP/l2nmLR2AnbXu3yupOwj1eB6hP3b0PvBzRf2Uvfg==
X-Received: by 2002:a5d:5984:0:b0:32f:5e07:f53e with SMTP id n4-20020a5d5984000000b0032f5e07f53emr4603889wri.4.1699549372694;
        Thu, 09 Nov 2023 09:02:52 -0800 (PST)
Received: from [10.0.0.194] ([37.186.169.33])
        by smtp.gmail.com with ESMTPSA id h3-20020adfa4c3000000b0031980294e9fsm70509wrb.116.2023.11.09.09.02.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Nov 2023 09:02:52 -0800 (PST)
Message-ID: <2c3a28999adc1fa22b9b822bdae5ab79817957fa.camel@redhat.com>
Subject: Re: [PATCH nft 1/2] utils: add memory_allocation_check() helper
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Thu, 09 Nov 2023 18:02:51 +0100
In-Reply-To: <ZUz5mWjHQjXkU6If@calendula>
References: <20231108182431.4005745-1-thaller@redhat.com>
         <ZUz5mWjHQjXkU6If@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.50.0 (3.50.0-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gVGh1LCAyMDIzLTExLTA5IGF0IDE2OjI0ICswMTAwLCBQYWJsbyBOZWlyYSBBeXVzbyB3cm90
ZToKPiBPbiBXZWQsIE5vdiAwOCwgMjAyMyBhdCAwNzoyNDoyNFBNICswMTAwLCBUaG9tYXMgSGFs
bGVyIHdyb3RlOgo+ID4gCj4gPiArI2RlZmluZSBtZW1vcnlfYWxsb2NhdGlvbl9jaGVjayhjbWQp
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gPiArCSh7wqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqAgXAo+ID4gKwkJdHlwZW9mKChjbWQpKSBfdiA9IChjbWQpO8KgwqDCoMKgwqDCoMKgwqDC
oCBcCj4gPiArCQljb25zdCB2b2lkICpjb25zdCBfdjIgPSBfdjvCoMKgwqDCoMKgwqDCoCBcCj4g
PiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBcCj4gPiArCQlp
ZiAoIV92MinCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oCBcCj4gCj4gcGxlYXNlIGRvbid0IGhpZGUgYSBpZiBicmFuY2ggaW5zaWRlIGEgbWFjcm8uCgpX
aGF0IGlzIHRoZSByZWFzb24gZm9yIHRoaXMgcnVsZT8gSXMgdGhlcmUgYSBzdHlsZSBndWlkZSBz
b21ld2hlcmU/Cgo+IAo+ID4gKwkJCW1lbW9yeV9hbGxvY2F0aW9uX2Vycm9yKCk7IFwKPiA+ICsJ
CV92O8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgIFwKPiA+ICsJfSkKCgoKSXQgY291bGQgYmUgaW5zdGVhZDoKCgpzdGF0aWMgaW5s
aW5lIHZvaWQgKl9fbWVtb3J5X2FsbG9jYXRpb25fY2hlY2soY29uc3QgY2hhciAqZmlsZSwgdW5z
aWduZWQgbGluZSwgY29uc3Qgdm9pZCAqcHRyKSB7CiAgICBpZiAoIXB0cikKICAgICAgICBfX21l
bW9yeV9hbGxvY2F0aW9uX2Vycm9yKGZpbGUsIGxpbmUpOwogICAgcmV0dXJuICh2b2lkKikgcHRy
Owp9CgojZGVmaW5lIG1lbW9yeV9hbGxvY2F0aW9uX2NoZWNrKGNtZCkgXAogICAoKHR5cGVvZihj
bWQpIF9fbWVtb3J5X2FsbG9jYXRpb25fY2hlY2soX19GSUxFX18sIF9fTElORV9fLCAoY21kKSkK
CgpEb2Vzbid0IHNlZW0gdG8gbWFrZSBhIGRpZmZlcmVuY2UgZWl0aGVyIHdheS4KCgoKVGhvbWFz
Cg==

