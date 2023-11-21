Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6E7C61D92
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Nov 2023 12:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234770AbjKUMfG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Nov 2023 07:35:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbjKUMfD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Nov 2023 07:35:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1104E138
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 04:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700570099;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=dfKEYrQZC8hfe40V67mKi+nZwVrNcGTwm8vZZyRlJxM=;
        b=gN5whQxzGZUnesD4reQiaBlXvVGUV/KUfQP2RxfMUr7HBiz+jp45JUt+ZweNgsYEooMH3d
        TNBxP2rGtTE3jjYIXUQthhO0L8nk2hkPRbQiTVgLi51PbBY8MSXwnhaGuzbFoGXVAGGKzd
        kTmsq4wQ8hyX7dOd48c1n+Ge1jNE8R8=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-122-UyQnfxvpMBGzRQL1r6tmEQ-1; Tue, 21 Nov 2023 07:34:57 -0500
X-MC-Unique: UyQnfxvpMBGzRQL1r6tmEQ-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4090c609c7bso10672265e9.0
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Nov 2023 04:34:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700570096; x=1701174896;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dfKEYrQZC8hfe40V67mKi+nZwVrNcGTwm8vZZyRlJxM=;
        b=RtUiEyTnbvcFmwdibYltsU7vb73JoukCeAcPZu1zlqss0v50m2L6utLUYfyPRPGd8K
         q2V9S/11r6m/VN7NG3nK/800nVpHP18e10yQPl1IYfxlz2k8Qo0VqEAwJXH8keax6gIh
         0MDQrWs2rXAXgKGpg9mtKX9Adj+G1/5xeBpkRapc1vH+jtviL9/6W1z6f5aLHsu1C0cJ
         RSgq8MwfYvwSuk/Nt8BNV+lH449ezB79SkxeAje4aBYIIRd7MltEMOiHi7HbIxpmhcg0
         o3mipWN895lvwaY3EB5LBi31KUK8nrRLQCexzFtEPXM0qY1AMtOMqeDs8Go8+OqjjcNS
         /Lcg==
X-Gm-Message-State: AOJu0YymNs1KjmNPt4PffpSdW21dqw4F2v2QlabsJbsRBcIOUIiM1RiP
        Pp7S5lYlxg3qpRKfBSLE9JWcTxNvCC+4UN28kiHCMyEX716syl2LwLT78tEpXaz+0Ug/m4zsAyM
        KFFeCxTBwimAhfyNJR/OIvOzYcfGcBPxEA6LfLIZSOtQhYKV/xV2r6q0EOPNRkY8MI9r0o0/Tmy
        qm93tGCv8B36E=
X-Received: by 2002:a1c:7715:0:b0:3fe:d637:7b25 with SMTP id t21-20020a1c7715000000b003fed6377b25mr8433804wmi.0.1700570096341;
        Tue, 21 Nov 2023 04:34:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFHNXIwbnYa3pH3Fl7vMBgV1eE27SIxzZrqjX9NyxQImAT9IWNTETqhVS9eTPGqFRz3SVz32g==
X-Received: by 2002:a1c:7715:0:b0:3fe:d637:7b25 with SMTP id t21-20020a1c7715000000b003fed6377b25mr8433799wmi.0.1700570095961;
        Tue, 21 Nov 2023 04:34:55 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id je14-20020a05600c1f8e00b0040596352951sm21820198wmb.5.2023.11.21.04.34.55
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Nov 2023 04:34:55 -0800 (PST)
Message-ID: <792015e09808892af632b8297195dd6bc449b1ae.camel@redhat.com>
Subject: Re: [PATCH nft v2 0/5] add infrastructure for unit tests
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Tue, 21 Nov 2023 13:34:54 +0100
In-Reply-To: <20231105150955.349966-1-thaller@redhat.com>
References: <20231105150955.349966-1-thaller@redhat.com>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=mQINBFLEazUBEADAszHnys6XWbNHTD4jriYFkKoRcZBBYVFxPdWF5ub9a7zrW7VvzahJPyGgKrOcW5vs0WccrOCTM+wZt63TpHqV1AtWPb4auKPsBJ4ltcU9u9RW6Z/TKv2gA+YoMe6IVnd91qKBCh/SmXzgOqCMv2edDfZfqrcHYFJeSfglw/wR7TJGL5BCcKrUa+zKHwsNCS8rIS7wmGLQGZJwfUFUqzyzz4WNDuL5OYuhoGPd8toecb14a6GYiBpyHi6Ii2EyBmCgSZRp4JprYD3Ryr5o3V3GvuhJuvZvybFAEvYPgUyoX7ZfNCugYCD6z/0CoeDEdAgeCkkLdfTbDBbOLJGOYnbgLQxexxg3bPR5RbDxkiGawJHVkRqy8by6jhhmw1HOgKoAev8yfJJpRQZ60IEvOThIF18ftdsL+wQfXEMQ0VT7F7nFxrQTC6OVKZ+9imlEn9Q5Nk4cdOKPKqweBBJeFOOWI3qARmneF9vbqZ9PL0CUNXFM3wuyeJTwtSxyvPVJQzMADxieUa1AaYrjJzoqgKmBRffwkatoFQqIn4b2nDELPzqNm2qtXz4SERdcSU8AD8fkriLX9TqAcht5M14Sp2bxyoppqEtd3M4GhK4lBlM8YcdTJFT4Imoqb0kGj+jGR7i6LwFqpKM71nmB7YmNfDF1RzMlqH5OFCs/pXdABKQsfwARAQABtCJUaG9tYXMgSGFsbGVyIDx0aGFsbGVyQHJlZGhhdC5jb20+iQJVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgBYhBEnqfGcOCFDnQZUU9inCNm5N/FcoBQJkKn7FBQkVKHqQAAoJECnCNm5N/FcoTx4P/1M9F1O0agPFoFG2eVRvaJnWXDl7hXWueOi442S/Gat0BW1xVJi0mDlvlV0ep09
 369EwJz5EgzyXQQiSL33pLOxtPmSB+k5mEDh2C8p6+0hsVTQIsmuDMYIXG 94JnOUjwC28xziMg5ESTYOD0Kum59nnOebG5hkRBEEbT2XLGZhQISvBDfWIQ4tF4zc0603srmXLqi9dKlMK6Kynieorte93s8JU47t71+B11MxGrgA1iPCcD15MSyYDLy6XmM7Q8WmcS8Y0p9JEAJX7BOBfyopeAO8d6Rv2juPjJqnbQh9cneA9YkQxGNE7I7do7zAX81mhPc1JVBn2Nu099LHWgaSmh1FKQUpP8wlzJi7AulRFYvYieg4XjolsmJEpXhv2s4mllRIm68C1SsNRFHx09WmmBjIB1u9Mk/wHZCRJoHUVPLrzBGkspVY204UCE+MMcegkFuIYWxQmYBg+AEq9I0Bn12ILc6UpjCobquvkd7gE7Y1B+nCdJn28nS04WTMpbPWS6zu3NpA6gmCdYNRB08B+VPqXMI7q0yv90ZkBMYoKInS9Ab5C57o8wHBIfEU5+EnPvtaZDI6stGLYAuKI7AmKePxlPZVxV1L36C1EzpmAqjgeRltSQJy5mzSM5OnDbTSMJWPxYX6roHBPMpDUf2FtqAqKlsZHKI/6zmkRKwvnuQINBFLEazUBEADH8k7ECPrqOPPByFUfnWvk5RAIYipZsrNm5oZAF0NVoUKFcYJOJt2yvgSIRB8thVBMYVAlWsSz3FpsbGzdEN23+PNvp8q7DK46im/t1Ld3DqxNoF1iEBhKFgBHvB+TOf6E49+x1dKHbGB91Pn6mYoQ6wLgn3P5lfvnG227Xct6rw+E+Tk+lf8umRNy1SZ/NbTb2N3OSMQlQYqK4MmR93kB3FDSDj/7IkNEqF6BpAIwcr4bpmTkRlMPcOec3KXPsDf45xijhgMqIDGwqYqWYNTXTO/2pEqsHTZC2Rh29QdU0PMANCsboxpSPHtsQI4u+wdkN/BAi40it3MLjhjYayyhOWXnWC2IQBLff5EAon7
 4gWZVsR8MCJZvcqMHyPNN+rqXwaaDv6Y9BkrcRO9lB7zC6ueuDqHMFzXOg+ D/1FToMVphmT2gNvJDLw7nTf4mVNHyWiEcQ2sR3TOolSPPjwetoTqE0rhtStN94wlf7yFTe4smnN9rClChQ0XkkTJzjD0Ythi2WpLBl07vYBy9K//YMteGWCwnBeBGPNxdr18X9w/qQxvAYVZyA6huprCO7FcUgzyjV8N9uKnJ5UAnaq3fun5RtRzaBD7Sb4gIy19fsfIwlCWklSi0rP/8gd8E/PQFXb6QkwOEV61AgQDiokUo1WC9yYuqduN9acM6s3VT6QARAQABiQI8BBgBCAAmAhsMFiEESep8Zw4IUOdBlRT2KcI2bk38VygFAmQqfs4FCRUoepkACgkQKcI2bk38VygQQhAAl+a7quouHAZdRbGLrJbNkPeFggliknCBOFzennQd67pH/YHPZQMZNJkiHHpfplESskrbS4BPTIQmwCrWI9+tUoSfOfYTF6b41L3G/UE9wKQznP+/M6FMPe5silbH+Yoj4KLqrTkUyCmEJEV1zKA1Ese5NfY+2IsX/ctclBzNhnZLJgPkKHJL+c9jAHd3IdEWXM40p3LCwMl+887K0djFmchIprU+z4+yfJ0OK7uLYC9h6VDQeJb8iM07pd6san+2rfWZAU2MKQwLUg86u1QPelMjYYH/qwje+Bs0foDYNiSvEj7vz//CqoctxqNqJt3w4Cfz0iUiDSxpO8vh4r0SKVhFJNF71qPTWrjT5Qn7UPEgDzKfxFlrqUN9KayY4j4GS/OszwX0RTlF0+keF67FiOkYvOLxRzsYu9wCswh2loE2JFzTN0+/hoO1XpPb/gxr77gSyY+SL+grEUX5HDa/tTdiNMs3PSvbzht4xe+BIUqygGp5GGui9lDdVHfQOe6lRhMagvALosgLRHp7KtKLZH/ug1XDp0tJ+RB8Zm9CkJ+V7KI4qAC1rflC8fcXSULDYI8tWyn
 w0SFaex54sbnFUiMVS1BZPlB9yIH5YwMDd8cXvL6lkk9mScg9U9k0OP1cwj7 nzHTx3OrSfP3+UeSVB1Nyr0Kn0PHR5g+hWHjCsbKZAg0EUfpfSwEQALpQiYNk/8mxUS38iMZD0ji7oIDRK78Mp103VUTvyYXJAP4FVXdUWZH+BCgvWZcugi070axPDMQO/f9Cwu3oa65Gn7pLp7tJrM8Ha06OJHTnuPtdgfx4DpJzoPSNCiJmSZzthqtGkLfex+IPuyQiUCgG/dXt7oJ/X1f4Lv21aNCg5c9K6LPeH6BjHGpcXW8Rha9hoCzLXPoD7rUAdqWKegHtSL0+zdU8GVWX82yKqmEGuRJyOSDKO++pIG/25UgXSg/CRNRUkVMGrpfcWFQOkIe78dIO1MIjifC+bMc/laJ1q6xFLFWbAnj6PCpCSi3b8lY6jJxwfooVFFMMw0irvyuH8K/JM3LEP/Dz+MmJb5gBnx21P7F5Sl6eJI0fdEQxmvllrj8HTH5qtC4f4ikAmrSycS5HT1gMntjBbuF8aQX+aI6qEPXS68dcpFNR0J4sUUzpKPabsNfyDkX8jkjYajF5+2iAf9IzwOgDIiZckGXIAuhreBlV+NyJfJrKG7QJbQ6hdK+laSTBdzCn9v/R/ZxWXy9LLkX0kmAxhoa8GPMWqCJXjG405v1ng0FJbxkRAYsijHIOsThM6G56QNBKvW7/gEEoT1+DEGYzqsHVV1gHR9CX3wOyJjcs+bx4RW4WdQLBmUoapNaLkN6zHcWktuh9EL6mo7DZRkTOjvmEsv6bABEBAAG0IlRob21hcyBIYWxsZXIgPHRoYWxsZXJAcmVkaGF0LmNvbT6JAj4EEwECACgFAlH6X0sCGwMFCQPCZwAGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEKHCmQ/SsOFd4QkP/RyUrXafY9o7XIwiS6o2V5mrIZHEQ8M6PdAZDRl3/0FtrQ/cjbFvw3fxfXh
 IC261AS2f+b0EQr34e5T6XMTqDeZUNJUXLr+9w8FPPn1RQ8wO3wCKGVvplw/f QLVU8JKOKNYQsUnbUSGKwX0he1zGymH0isIiV/X572EgDgrcHHR+z8XIPuIIWfKl7J/xjaqg084kuyAiTw4DEH9RN8XVqTQpVPUh138/nx7GSvZJSS92OvKFaeGXGJ1MUUSKYUyyLQyHD6vxI26S8kEFkinwcn86tF7PblC+AiaS7tFBhW+Bwi641vjyNTsCDwxmhujhlgQhj17qhcG8xPETl2iv8QCOv2TGkvBc1DO2keheVP34bFYQm/vuYQ3heUfyJJWitbHoK9MWj5OUa5AM/uSvogXIL3sQD8K7QSvVTfbodN2WYWPNBVe7pgxifo8u2t3fYWaeySX4pOTGPmJQbr1apdTiTAg+yHpxG6x4FJFs1TsG/PeL81ioBQgIMzBvmqddUrkzAMlxiSBLvJLzPQ4i81F3EBPFvYAdu8z+YwYtRe0HJO2fI4Wi1VWCQ0ed9AmPjzJE+5t3pp6C73pvqthilc9A7EVKL/8aW79+5NCA9I5PQIRaFg9EmcEKGDaZ1pV3ZFtHNpqY7+YdlAkTdP7DPIOLow2rFkD+GksmEsvAxQfe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.50.1 (3.50.1-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gU3VuLCAyMDIzLTExLTA1IGF0IDE2OjA4ICswMTAwLCBUaG9tYXMgSGFsbGVyIHdyb3RlOgo+
IENoYW5nZXMgdG8gdjE6Cj4gCj4gLSByZW5hbWUgc29tZSBgbWFrZSB0YXJnZXRzYAo+IC0gYWRk
IGBtYWtlIGNoZWNrLXVuaXRgIHRvIGFsaWFzIGBtYWtlIGNoZWNrLVRFU1RTYC4gVGhlc2UgdGFy
Z2V0cwo+IMKgIHJ1biB0aGUgdGVzdHMgaG9va2VkIHVwIGFzICJURVNUUz0iICh3aGljaCBmb3Ig
bm93IGFyZSB0aGUgdGVzdHMKPiDCoCBpbiB0ZXN0cy91bml0KS4KPiAtIGltcHJvdmUgY29tbWl0
IG1lc3NhZ2VzIGFuZCB2YXJpb3VzIG1pbm9yIGNvZGUgY2hhbmdlcy4KPiAKPiBUaG9tYXMgSGFs
bGVyICg1KToKPiDCoCBidWlsZDogYWRkIGJhc2ljICJjaGVjay17bG9jYWwsbW9yZSxhbGx9IiBh
bmQgImJ1aWxkLWFsbCIgbWFrZQo+IHRhcmdldHMKPiDCoCBidWlsZDogYWRkIGBtYWtlIGNoZWNr
LWJ1aWxkYCB0byBydW4gYC4vdGVzdHMvYnVpbGQvcnVuLXRlc3RzLnNoYAo+IMKgIGJ1aWxkOiBh
ZGQgYG1ha2UgY2hlY2stdHJlZWAgdG8gY2hlY2sgY29uc2lzdGVuY3kgb2Ygc291cmNlIHRyZWUK
PiDCoCBidWlsZDogY2xlYW51cCBpZi1ibG9ja3MgZm9yIGNvbmRpdGlvbmFsIGNvbXBpbGF0aW9u
IGluCj4gIk1ha2VmaWxlLmFtIgo+IMKgIHRlc3RzL3VuaXQ6IGFkZCB1bml0IHRlc3RzIGZvciBs
aWJuZnRhYmxlcwo+IAo+IMKgLmdpdGlnbm9yZcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgfMKgIDE1ICstCj4gwqBNYWtlZmlsZS5hbcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHwgMTM0ICsrKysrKysr
KysrKy0tLQo+IMKgc3JjLy5naXRpZ25vcmXCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoCB8wqDCoCA1IC0KPiDCoHRlc3RzL3VuaXQvbmZ0LXRlc3QuaMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8wqAgMTQgKysKPiDCoHRlc3RzL3VuaXQvdGVzdC1saWJu
ZnRhYmxlcy1zdGF0aWMuYyB8wqAgMTYgKysKPiDCoHRlc3RzL3VuaXQvdGVzdC1saWJuZnRhYmxl
cy5jwqDCoMKgwqDCoMKgwqAgfMKgIDIxICsrKwo+IMKgdG9vbHMvdGVzdC1ydW5uZXIuc2jCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCB8IDIzNQo+ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKwo+IMKgNyBmaWxlcyBjaGFuZ2VkLCA0MTIgaW5zZXJ0aW9ucygrKSwgMjggZGVsZXRp
b25zKC0pCj4gwqBjcmVhdGUgbW9kZSAxMDA2NDQgdGVzdHMvdW5pdC9uZnQtdGVzdC5oCj4gwqBj
cmVhdGUgbW9kZSAxMDA2NDQgdGVzdHMvdW5pdC90ZXN0LWxpYm5mdGFibGVzLXN0YXRpYy5jCj4g
wqBjcmVhdGUgbW9kZSAxMDA2NDQgdGVzdHMvdW5pdC90ZXN0LWxpYm5mdGFibGVzLmMKPiDCoGNy
ZWF0ZSBtb2RlIDEwMDc1NSB0b29scy90ZXN0LXJ1bm5lci5zaAoKCkhpIFBhYmxvLAoKYW55IGNv
bmNlcm5zIGFib3V0IHRoaXM/IENvdWxkIGl0IGJlIG1lcmdlZD8KClRoYW5rIHlvdSwKVGhvbWFz
Cgo=

