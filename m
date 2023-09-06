Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C39C6EB8FB3
	for <netfilter-devel@archiver.kernel.org>; Wed,  6 Sep 2023 13:43:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238325AbjIFNn6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 6 Sep 2023 09:43:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjIFNn6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2023 09:43:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64C20173F
        for <netfilter-devel@vger.kernel.org>; Wed,  6 Sep 2023 06:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1694007779;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rU8pzHCBetsT4wwR1pA6G8VXFdjKgZPFPvGO6xyRpBQ=;
        b=i6KoF2YFenT9upv5Se8vBDkwd3sonZxgE2wlKvBBGcm7r02fYfw/H+26TFs4rozmdi03VG
        VhGBGWVLFsfvuNdJYE5aLSRRzicPr7THxTzkU24McwBQYYlZxhV/GCTxug09cxY5zizDCT
        yrb+GuGvGlu50CdTHV+1pi19Ah4HAsg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-687-oFpNh9h8NeSZj0Qazhnjzg-1; Wed, 06 Sep 2023 09:42:57 -0400
X-MC-Unique: oFpNh9h8NeSZj0Qazhnjzg-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-402d5a3c649so4385445e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2023 06:42:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694007775; x=1694612575;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rU8pzHCBetsT4wwR1pA6G8VXFdjKgZPFPvGO6xyRpBQ=;
        b=A4lHsfPkaLBc+juTazUR54LM6ACaX3lZUSA0qgQLAWrDx+L/fqj0d9sYyQKKErnXMO
         lXR2y5uH0f6N11FhpFDqS9Nq3cYnwwsnfPnMpG3f9E47a+V6j+nZsszfJDq2VcluJebX
         AL0zY2Xv3zDS+7qUKqh/UNpicQZ8aEFrLd9nr6Xho2uZs75OsN6oDKjEea38aMiR5gmL
         cV8p7w914rAm49oortWKFwMpOQ2FjgBjWg5rRpg3X79uo4BtY5iN27Jd/UC7NAc5iu9T
         mCHa3bZCvU9/M5ZVa1utvy8y/yRrEuFCu4wWgsSv0aMc3vMxsoTUr+7Q8UHukZ5kGcZZ
         nsug==
X-Gm-Message-State: AOJu0YwDmSfvWFu4biOEcS89qWmJ9pac11SzzoX0iJzb4Lx+d/fTgamy
        eeBBSNTBoSonpniyx5oQ9PIb479FdV53R35nOdlkGH38jHSSLVXEXnNe4UCr2HCoqECB644I6Ug
        BJr+iLw9HucX8Pn2BeW2SE1d6LlmpCNUMt78A
X-Received: by 2002:a05:600c:1c9e:b0:401:b0f8:c26a with SMTP id k30-20020a05600c1c9e00b00401b0f8c26amr12635252wms.4.1694007775566;
        Wed, 06 Sep 2023 06:42:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFEBlK8awnfQgI48/FB/d4E+XCPKvxqRM/wVyKseuz/hZ49lpldeuJj8kMQPufbkjF+vfa+wQ==
X-Received: by 2002:a05:600c:1c9e:b0:401:b0f8:c26a with SMTP id k30-20020a05600c1c9e00b00401b0f8c26amr12635232wms.4.1694007775237;
        Wed, 06 Sep 2023 06:42:55 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id s10-20020adfecca000000b003197869bcd7sm20479014wro.13.2023.09.06.06.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 06:42:54 -0700 (PDT)
Message-ID: <901548e08cdc6fcff34a436f1ff0871816d87795.camel@redhat.com>
Subject: Re: [PATCH nft 2/5] tests: shell: let netdev_chain_0 test indicate
 SKIP if kernel requires netdev device
From:   Thomas Haller <thaller@redhat.com>
To:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Date:   Wed, 06 Sep 2023 15:42:54 +0200
In-Reply-To: <20230904090640.3015-3-fw@strlen.de>
References: <20230904090640.3015-1-fw@strlen.de>
         <20230904090640.3015-3-fw@strlen.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gTW9uLCAyMDIzLTA5LTA0IGF0IDExOjA2ICswMjAwLCBGbG9yaWFuIFdlc3RwaGFsIHdyb3Rl
Ogo+IFRoaXMgdGVzdCBjYXNlIG9ubHkgd29ya3Mgb24ga2VybmVsIDYuNCsuCj4gQWRkIGZlYXR1
cmUgcHJvYmUgZm9yIHRoaXMgYW5kIHRoZW4gZXhpdCBlYXJseS4KPiAKPiBXZSBkb24ndCB3YW50
IHRvIGluZGljYXRlIGEgdGVzdCBmYWlsdXJlLCBhcyB0aGlzIHRlc3QgZG9lc24ndCBhcHBseQo+
IG9uIG9sZGVyIGtlcm5lbHMuCj4gCj4gQnV0IHdlIHNob3VsZCBub3QgaW5kaWNhdGUgc3VjZXNz
IGVpdGhlciwgZWxzZSB3ZSBtaWdodCBiZSBmb29sZWQKPiBpbiBjYXNlIHNvbWV0aGluZyB3ZW50
IHdyb25nIGR1cmluZyBmZWF0dXJlIHByb2JlLgo+IAo+IEFkZCBhIHNwZWNpYWwgcmV0dXJuIHZh
bHVlLCAxMjMsIGFuZCBsZXQgcnVuLXRlc3RzLnNoIGNvdW50IHRoaXMKPiBhcyAnU0tJUFBFRCcu
Cj4gCgpbLi4uXQoKPiDCoGZhaWxlZD0wCj4gK3NraXBwZWQ9MAo+IMKgdGFpbnQ9MAo+IMKgCj4g
wqBjaGVja19mZWF0dXJlcygpCj4gQEAgLTI3MCw2ICsyNzEsOSBAQCBkbwo+IMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtc2df
d2FybiAiW0RVTVAgRkFJTF3CoMKgwqAkdGVzdGZpbGUiCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgZmkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGZpCj4gK8KgwqDCoMKgwqDCoMKgZWxpZiBbICIkcmNfZ290IiAtZXEgMTIzIF07IHRo
ZW4KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgKChza2lwcGVkKyspKQo+ICvCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtc2dfaW5mbyAiW1NLSVBQRURdwqDCoMKgwqDCoCR0
ZXN0ZmlsZSIKCkkgYWdyZWUgd2l0aCBQaGlsLCBJIHRoaW5rIHRoaXMgc2hvdWxkIHJldHVybiA3
Ny4KCkJ0dywgSSBkaWQgYSBzaW1pbGFyIHBhdGNoIG9uIAoKICBbUEFUQ0ggbmZ0IHY1IDA4LzE5
XSB0ZXN0cy9zaGVsbDogaW50ZXJwcmV0IGFuIGV4aXQgY29kZSBvZiA3NyBmcm9tIHNjcmlwdHMg
YXMgInNraXBwZWQiCgpHcmFudGVkLCB5b3Ugc2VuZCB5b3VyIGZpcnN0IHZlcnNpb24gd2l0aCB0
aGlzIHBhdGNoL2lkZWEgYSBmZXcgaG91cnMKYmVmb3JlIG1pbmUuIEkganVzdCBwb2ludCBvdXQg
dGhlIG92ZXJsYXAuLi4KCgo+IMKgwqDCoMKgwqDCoMKgwqBlbHNlCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqAoKGZhaWxlZCsrKSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoGlmIFsgIiRWRVJCT1NFIiA9PSAieSIgXSA7IHRoZW4KPiBAQCAtMjk0LDcgKzI5OCwx
MiBAQCBlY2hvICIiCj4gwqBrbWVtbGVha19mb3VuZD0wCj4gwqBjaGVja19rbWVtbGVha19mb3Jj
ZQo+IMKgCj4gLW1zZ19pbmZvICJyZXN1bHRzOiBbT0tdICRvayBbRkFJTEVEXSAkZmFpbGVkIFtU
T1RBTF0gJCgob2srZmFpbGVkKSkiCj4gK21zZ19pbmZvICJyZXN1bHRzOiBbT0tdICRvayBbRkFJ
TEVEXSAkZmFpbGVkIFtTS0lQUEVEXSAkc2tpcHBlZAo+IFtUT1RBTF0gJCgob2srZmFpbGVkK3Nr
aXBwZWQpKSIKPiArCj4gK2lmIFsgJG9rIC1lcSAwIC1hwqAgJGZhaWxlZCAtZXEgMCBdOyB0aGVu
Cj4gK8KgwqDCoMKgwqDCoMKgIyBubyB0ZXN0IGNhc2VzIHdlcmUgcnVuLCBpbmRpY2F0ZSBhIGZh
aWx1cmUKPiArwqDCoMKgwqDCoMKgwqBmYWlsZWQ9MQo+ICtmaQoKSSB0aGluayB0aGlzIHNob3Vs
ZCBiZSBkcm9wcGVkLgoKV2hlbiBJIHJ1bgoKICAuL3Rlc3RzL3NoZWxsL3J1bi10ZXN0cy5zaCB0
ZXN0cy9zaGVsbC90ZXN0Y2FzZXMvbWFwcy90eXBlb2ZfbWFwc19hZGRfZGVsZXRlCgpvbiBteSBG
ZWRvcmEzOCwgdGhlIHRlc3QgZ2V0cyBza2lwcGVkLiBCdXQgSSB0aGluayB0aGUgY29tbWFuZCBz
aG91bGQKanVzdCBnaXZlIG1lIGEgc3VjY2Vzcy4gV2hhdCB3b3VsZCBJIGRvIGFib3V0IHRoZSAi
ZmFpbHVyZSIgYW55d2F5PwoKClRob21hcwo=

