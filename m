Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D945E82CB4
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Sep 2023 17:07:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229458AbjI0RHU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Sep 2023 13:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjI0RHT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Sep 2023 13:07:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0EBDD
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 10:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695834391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WlAGlpl7zOIlgJ1mH0K7Z9Z0Dw68KjjKlLV3rb7kyFA=;
        b=hBIS2BVGACOVElWos1a1OWgXbTVZlP2ENP1PQpeDDNbnhISTLiBE+PgZgKTZfrUK/VktPh
        7iisVRK1636iAx8QSYPMvnqcpB06+NT68+Z5p2ap4aoVoHnMAN9C0hg/HbcHjFYrW7vnx8
        gDV6gFoVUGaO5w/ee6BYLkgDPEUq3+0=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-689-F1T4ireDNy-8wQoK5ekjjQ-1; Wed, 27 Sep 2023 13:06:29 -0400
X-MC-Unique: F1T4ireDNy-8wQoK5ekjjQ-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-530c12c72a7so1479372a12.0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Sep 2023 10:06:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695834388; x=1696439188;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WlAGlpl7zOIlgJ1mH0K7Z9Z0Dw68KjjKlLV3rb7kyFA=;
        b=w1V9077/szTuT9aS6Weetv+Bl9gDPJfR3vb0wgf+zHQh+3MzQlU2UsLQCDhEOY/tiA
         002kMoz00ubV0oaBTh8Jw88PdWKzXKmlIef8z/RAeu9HhfPTDfv70I13jZUTjVviPiet
         NHOiriuSqo4qipH5B89MnFQQ+fCxzMnxvdxYmT8+kjjkoUjlOSq5/krrtqeDoaN0gXk3
         MVXcTrrSRJ9ynPPpQ5LD3FbGmZtYDnQD9hWp0QFzuFGUJF3TbLXwiaSU13QqEvPMQmV5
         szLQPwNkZiHJ3nigsgijPcokekRCJexRx3ce55PtLcpqpr/RoTDiWGbhALgZ1qKkaWKu
         R//w==
X-Gm-Message-State: AOJu0YxkUzqBcjcD+ri0DEUe+ikYoNEcVmYdplGPA1vu2waHfryzc6PM
        s8Okg64iKxXTvItNwtfMDKikC0urVVfyzbeEXU/VWGj7hjXTxCC2Tv/TCx9EgJlje7/d7chEgJr
        OtsqXUyEjpBt61tgGiV7F7kxZyzF9Nzzf889Llz+4Dbt0gakEeM0F6Ccipw5WhRenUF69UDDGHO
        rXlzMzbKvcOVM=
X-Received: by 2002:a05:6402:5193:b0:51a:4d46:4026 with SMTP id q19-20020a056402519300b0051a4d464026mr2520991edd.0.1695834387930;
        Wed, 27 Sep 2023 10:06:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFDgNWvvPHTXuUYOyCM4IFwgDapXHmf6acH6+S9koid3eYm2evwbLBQjUljxW8EX2GIdm3ajg==
X-Received: by 2002:a05:6402:5193:b0:51a:4d46:4026 with SMTP id q19-20020a056402519300b0051a4d464026mr2520971edd.0.1695834387527;
        Wed, 27 Sep 2023 10:06:27 -0700 (PDT)
Received: from [10.0.0.196] ([37.186.167.86])
        by smtp.gmail.com with ESMTPSA id f3-20020a056402068300b005256771db39sm8406887edy.58.2023.09.27.10.06.26
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 10:06:27 -0700 (PDT)
Message-ID: <5abe71186c7dd1b78b58fcca9a3920deccad16fc.camel@redhat.com>
Subject: Re: [PATCH nft 3/3] netlink_linearize: avoid strict-overflow
 warning in netlink_gen_bitwise()
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 27 Sep 2023 19:06:26 +0200
In-Reply-To: <20230927122744.3434851-4-thaller@redhat.com>
References: <20230927122744.3434851-1-thaller@redhat.com>
         <20230927122744.3434851-4-thaller@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gV2VkLCAyMDIzLTA5LTI3IGF0IDE0OjIzICswMjAwLCBUaG9tYXMgSGFsbGVyIHdyb3RlOgo+
IFdpdGggZ2NjLTEzLjIuMS0xLmZjMzgueDg2XzY0Ogo+IAo+IMKgICQgZ2NjIC1JaW5jbHVkZSAt
YyAtbyB0bXAubyBzcmMvbmV0bGlua19saW5lYXJpemUuYyAtV2Vycm9yIC0KPiBXc3RyaWN0LW92
ZXJmbG93PTUgLU8zCj4gwqAgc3JjL25ldGxpbmtfbGluZWFyaXplLmM6IEluIGZ1bmN0aW9uIOKA
mG5ldGxpbmtfZ2VuX2JpdHdpc2XigJk6Cj4gwqAgc3JjL25ldGxpbmtfbGluZWFyaXplLmM6MTc5
MDoxOiBlcnJvcjogYXNzdW1pbmcgc2lnbmVkIG92ZXJmbG93Cj4gZG9lcyBub3Qgb2NjdXIgd2hl
biBjaGFuZ2luZyBYICstIEMxIGNtcCBDMiB0byBYIGNtcCBDMiAtKyBDMSBbLQo+IFdlcnJvcj1z
dHJpY3Qtb3ZlcmZsb3ddCj4gwqDCoCAxNzkwIHwgfQo+IMKgwqDCoMKgwqDCoMKgIHwgXgo+IMKg
IGNjMTogYWxsIHdhcm5pbmdzIGJlaW5nIHRyZWF0ZWQgYXMgZXJyb3JzCj4gCj4gSXQgYWxzbyBt
YWtlcyBtb3JlIHNlbnNlIHRoaXMgd2F5LCB3aGVyZSAibiIgaXMgdGhlIGhpZ2h0IG9mIHRoZQo+
ICJiaW5vcHMiIHN0YWNrLCBhbmQgd2UgY2hlY2sgZm9yIGEgbm9uLWVtcHR5IHN0YWNrIHdpdGgg
Im4gPiAwIiBhbmQKPiBwb3AKPiB0aGUgbGFzdCBlbGVtZW50IHdpdGggImJpbm9wc1stLW5dIi4K
PiAKPiBTaWduZWQtb2ZmLWJ5OiBUaG9tYXMgSGFsbGVyIDx0aGFsbGVyQHJlZGhhdC5jb20+Cj4g
LS0tCj4gwqBzcmMvbmV0bGlua19saW5lYXJpemUuYyB8IDcgKysrLS0tLQo+IMKgMSBmaWxlIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkKPiAKPiBkaWZmIC0tZ2l0IGEv
c3JjL25ldGxpbmtfbGluZWFyaXplLmMgYi9zcmMvbmV0bGlua19saW5lYXJpemUuYwo+IGluZGV4
IGM5MTIxMTU4MmIzZC4uZjI1MTRiMDEyYTlkIDEwMDY0NAo+IC0tLSBhL3NyYy9uZXRsaW5rX2xp
bmVhcml6ZS5jCj4gKysrIGIvc3JjL25ldGxpbmtfbGluZWFyaXplLmMKPiBAQCAtNzEyLDE0ICs3
MTIsMTMgQEAgc3RhdGljIHZvaWQgbmV0bGlua19nZW5fYml0d2lzZShzdHJ1Y3QKPiBuZXRsaW5r
X2xpbmVhcml6ZV9jdHggKmN0eCwKPiDCoMKgwqDCoMKgwqDCoMKgd2hpbGUgKGxlZnQtPmV0eXBl
ID09IEVYUFJfQklOT1AgJiYgbGVmdC0+bGVmdCAhPSBOVUxMICYmCj4gwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCAobGVmdC0+b3AgPT0gT1BfQU5EIHx8IGxlZnQtPm9wID09IE9QX09SIHx8
IGxlZnQtPm9wCj4gPT0gT1BfWE9SKSkKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGJpbm9wc1tuKytdID0gbGVmdCA9IGxlZnQtPmxlZnQ7CgpJIHdhbnRlZCB0byBhc2ssIHdoYXQg
ZW5zdXJlcyB0aGF0IGJpbm9wcyBidWZmZXIgZG9lcyBub3Qgb3ZlcmZsb3c/CgoKPiAtwqDCoMKg
wqDCoMKgwqBuLS07Cj4gwqAKPiAtwqDCoMKgwqDCoMKgwqBuZXRsaW5rX2dlbl9leHByKGN0eCwg
Ymlub3BzW24tLV0sIGRyZWcpOwo+ICvCoMKgwqDCoMKgwqDCoG5ldGxpbmtfZ2VuX2V4cHIoY3R4
LCBiaW5vcHNbLS1uXSwgZHJlZyk7Cj4gwqAKPiDCoMKgwqDCoMKgwqDCoMKgbXB6X2JpdG1hc2so
bWFzaywgZXhwci0+bGVuKTsKPiDCoMKgwqDCoMKgwqDCoMKgbXB6X3NldF91aSh4b3IsIDApOwo+
IC3CoMKgwqDCoMKgwqDCoGZvciAoOyBuID49IDA7IG4tLSkgewo+IC3CoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqBpID0gYmlub3BzW25dOwo+ICvCoMKgwqDCoMKgwqDCoHdoaWxlIChuID4g
MCkgewo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpID0gYmlub3BzWy0tbl07Cj4g
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBtcHpfc2V0KHZhbCwgaS0+cmlnaHQtPnZh
bHVlKTsKPiDCoAo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgc3dpdGNoIChpLT5v
cCkgewoK

