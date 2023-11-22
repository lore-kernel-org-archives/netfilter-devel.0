Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D70F0C61D9B
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Nov 2023 12:56:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344227AbjKVM4L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Nov 2023 07:56:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344202AbjKVM4I (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2023 07:56:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5BFD50
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:56:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1700657761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=qrKevS+35N4R12ixaB3tV6ZfLuSDdrfBnn0orJNVdjE=;
        b=RkF2mGuw5/AClEawfW0vCcPpEqfwtAZHKxpoCuQ41LWZiW5jq0wf8ZkKTsnUhEDWwJk8xp
        rlwtWxLPuSVUfod69Uyf/LFNLQeda/tX6A3xj/7pIq34qZR+Zr/Ox0Oj2TXz9Ru+aIQeiT
        S08WM+rjAtq4gg+9wdkQVoZMvkhwdyI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-92-kjIAsgiZOAmLW0y89omqBA-1; Wed, 22 Nov 2023 07:56:00 -0500
X-MC-Unique: kjIAsgiZOAmLW0y89omqBA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32d933dde69so426722f8f.1
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2023 04:55:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700657758; x=1701262558;
        h=mime-version:user-agent:content-transfer-encoding:autocrypt
         :references:in-reply-to:date:cc:to:from:subject:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qrKevS+35N4R12ixaB3tV6ZfLuSDdrfBnn0orJNVdjE=;
        b=VyKAd/ndP/ZlL2aBT/nI9QVcO7x5B3xztmFg88ocWtJaQNwO6fuW44SdSXQ1tISVcW
         J6VvLWFf8o+0mW08GT0IbwtcNQiyZEItpMmV+T/8FAcMcEtO2Hj9u/FrYSNvSZBT2BZi
         MrwD9UiZrwNlHI2y76UozjNskk9l+x4iEC9CHn58rP+TYX6uUlTetfimEmGbomHWE7b5
         EcEWF21DJKFz8QP2e84lFUGPpSrrRw2ZWybZi066X9ygX2WmKzKvdKsiVyeAAuGQdsCE
         FW9QRLHIAovlO7Xvoq6z5SIsWLKJmP8itLqx88L9i9cam9WUyLdt1ky7I3KUdIyjIHfy
         sbUA==
X-Gm-Message-State: AOJu0YxQNOVyi6wqoYWhmgT6OKS1cViJvYkj1lsHbdTrIXGlGeUT9Eht
        vsKYNlA0RVqmBudCvdxCdruq1JxRL19eftAH0cyDgChRhpT5fLdCN0c/fE7yExKyuFHtWeHy8P6
        kYs87Z38W+pku8m993GRBjmb6PQ4828lbiPbL
X-Received: by 2002:a05:6000:196e:b0:32f:51c6:cd6c with SMTP id da14-20020a056000196e00b0032f51c6cd6cmr1440619wrb.2.1700657758541;
        Wed, 22 Nov 2023 04:55:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEov0+6Vs4JCy4zYcNFovy+Q5145OoDGNI9GI03od+7dm8vW9UKB7UMoqAPuoi2n21yBqSFqg==
X-Received: by 2002:a05:6000:196e:b0:32f:51c6:cd6c with SMTP id da14-20020a056000196e00b0032f51c6cd6cmr1440605wrb.2.1700657758152;
        Wed, 22 Nov 2023 04:55:58 -0800 (PST)
Received: from [10.0.0.196] ([37.186.166.196])
        by smtp.gmail.com with ESMTPSA id p17-20020a5d48d1000000b003316ad360c1sm16387526wrs.24.2023.11.22.04.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Nov 2023 04:55:57 -0800 (PST)
Message-ID: <267d0bff359a01b3222506e272bb1c2b63c154c8.camel@redhat.com>
Subject: Re: [PATCH nft 1/1] tests: prettify JSON in test output and add
 helper
From:   Thomas Haller <thaller@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     NetFilter <netfilter-devel@vger.kernel.org>
Date:   Wed, 22 Nov 2023 13:55:57 +0100
In-Reply-To: <ZV31GgRsu6Y7UScC@calendula>
References: <20231122111946.439474-1-thaller@redhat.com>
         <ZV31GgRsu6Y7UScC@calendula>
Autocrypt: addr=thaller@redhat.com; prefer-encrypt=mutual; keydata=mQINBFLEazUBEADAszHnys6XWbNHTD4jriYFkKoRcZBBYVFxPdWF5ub9a7zrW7VvzahJPyGgKrOcW5vs0WccrOCTM+wZt63TpHqV1AtWPb4auKPsBJ4ltcU9u9RW6Z/TKv2gA+YoMe6IVnd91qKBCh/SmXzgOqCMv2edDfZfqrcHYFJeSfglw/wR7TJGL5BCcKrUa+zKHwsNCS8rIS7wmGLQGZJwfUFUqzyzz4WNDuL5OYuhoGPd8toecb14a6GYiBpyHi6Ii2EyBmCgSZRp4JprYD3Ryr5o3V3GvuhJuvZvybFAEvYPgUyoX7ZfNCugYCD6z/0CoeDEdAgeCkkLdfTbDBbOLJGOYnbgLQxexxg3bPR5RbDxkiGawJHVkRqy8by6jhhmw1HOgKoAev8yfJJpRQZ60IEvOThIF18ftdsL+wQfXEMQ0VT7F7nFxrQTC6OVKZ+9imlEn9Q5Nk4cdOKPKqweBBJeFOOWI3qARmneF9vbqZ9PL0CUNXFM3wuyeJTwtSxyvPVJQzMADxieUa1AaYrjJzoqgKmBRffwkatoFQqIn4b2nDELPzqNm2qtXz4SERdcSU8AD8fkriLX9TqAcht5M14Sp2bxyoppqEtd3M4GhK4lBlM8YcdTJFT4Imoqb0kGj+jGR7i6LwFqpKM71nmB7YmNfDF1RzMlqH5OFCs/pXdABKQsfwARAQABtCJUaG9tYXMgSGFsbGVyIDx0aGFsbGVyQHJlZGhhdC5jb20+iQJVBBMBCAA/AhsDBgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgBYhBEnqfGcOCFDnQZUU9inCNm5N/FcoBQJkKn7FBQkVKHqQAAoJECnCNm5N/FcoTx4P/1M9F1O0agPFoFG2eVRvaJnWXDl7hXWueOi442S/Gat0BW1xVJi0mDlvlV0ep09
 369EwJz5EgzyXQQiSL33pLOxtPmSB+k5mEDh2C8p6+0hsVTQIsmuDMYIXG 94JnOUjwC28xziMg5ESTYOD0Kum59nnOebG5hkRBEEbT2XLGZhQISvBDfWIQ4tF4zc0603srmXLqi9dKlMK6Kynieorte93s8JU47t71+B11MxGrgA1iPCcD15MSyYDLy6XmM7Q8WmcS8Y0p9JEAJX7BOBfyopeAO8d6Rv2juPjJqnbQh9cneA9YkQxGNE7I7do7zAX81mhPc1JVBn2Nu099LHWgaSmh1FKQUpP8wlzJi7AulRFYvYieg4XjolsmJEpXhv2s4mllRIm68C1SsNRFHx09WmmBjIB1u9Mk/wHZCRJoHUVPLrzBGkspVY204UCE+MMcegkFuIYWxQmYBg+AEq9I0Bn12ILc6UpjCobquvkd7gE7Y1B+nCdJn28nS04WTMpbPWS6zu3NpA6gmCdYNRB08B+VPqXMI7q0yv90ZkBMYoKInS9Ab5C57o8wHBIfEU5+EnPvtaZDI6stGLYAuKI7AmKePxlPZVxV1L36C1EzpmAqjgeRltSQJy5mzSM5OnDbTSMJWPxYX6roHBPMpDUf2FtqAqKlsZHKI/6zmkRKwvnuQINBFLEazUBEADH8k7ECPrqOPPByFUfnWvk5RAIYipZsrNm5oZAF0NVoUKFcYJOJt2yvgSIRB8thVBMYVAlWsSz3FpsbGzdEN23+PNvp8q7DK46im/t1Ld3DqxNoF1iEBhKFgBHvB+TOf6E49+x1dKHbGB91Pn6mYoQ6wLgn3P5lfvnG227Xct6rw+E+Tk+lf8umRNy1SZ/NbTb2N3OSMQlQYqK4MmR93kB3FDSDj/7IkNEqF6BpAIwcr4bpmTkRlMPcOec3KXPsDf45xijhgMqIDGwqYqWYNTXTO/2pEqsHTZC2Rh29QdU0PMANCsboxpSPHtsQI4u+wdkN/BAi40it3MLjhjYayyhOWXnWC2IQBLff5EAon7
 4gWZVsR8MCJZvcqMHyPNN+rqXwaaDv6Y9BkrcRO9lB7zC6ueuDqHMFzXOg+ D/1FToMVphmT2gNvJDLw7nTf4mVNHyWiEcQ2sR3TOolSPPjwetoTqE0rhtStN94wlf7yFTe4smnN9rClChQ0XkkTJzjD0Ythi2WpLBl07vYBy9K//YMteGWCwnBeBGPNxdr18X9w/qQxvAYVZyA6huprCO7FcUgzyjV8N9uKnJ5UAnaq3fun5RtRzaBD7Sb4gIy19fsfIwlCWklSi0rP/8gd8E/PQFXb6QkwOEV61AgQDiokUo1WC9yYuqduN9acM6s3VT6QARAQABiQI8BBgBCAAmAhsMFiEESep8Zw4IUOdBlRT2KcI2bk38VygFAmQqfs4FCRUoepkACgkQKcI2bk38VygQQhAAl+a7quouHAZdRbGLrJbNkPeFggliknCBOFzennQd67pH/YHPZQMZNJkiHHpfplESskrbS4BPTIQmwCrWI9+tUoSfOfYTF6b41L3G/UE9wKQznP+/M6FMPe5silbH+Yoj4KLqrTkUyCmEJEV1zKA1Ese5NfY+2IsX/ctclBzNhnZLJgPkKHJL+c9jAHd3IdEWXM40p3LCwMl+887K0djFmchIprU+z4+yfJ0OK7uLYC9h6VDQeJb8iM07pd6san+2rfWZAU2MKQwLUg86u1QPelMjYYH/qwje+Bs0foDYNiSvEj7vz//CqoctxqNqJt3w4Cfz0iUiDSxpO8vh4r0SKVhFJNF71qPTWrjT5Qn7UPEgDzKfxFlrqUN9KayY4j4GS/OszwX0RTlF0+keF67FiOkYvOLxRzsYu9wCswh2loE2JFzTN0+/hoO1XpPb/gxr77gSyY+SL+grEUX5HDa/tTdiNMs3PSvbzht4xe+BIUqygGp5GGui9lDdVHfQOe6lRhMagvALosgLRHp7KtKLZH/ug1XDp0tJ+RB8Zm9CkJ+V7KI4qAC1rflC8fcXSULDYI8tWyn
 w0SFaex54sbnFUiMVS1BZPlB9yIH5YwMDd8cXvL6lkk9mScg9U9k0OP1cwj7 nzHTx3OrSfP3+UeSVB1Nyr0Kn0PHR5g+hWHjCsbKZAg0EUfpfSwEQALpQiYNk/8mxUS38iMZD0ji7oIDRK78Mp103VUTvyYXJAP4FVXdUWZH+BCgvWZcugi070axPDMQO/f9Cwu3oa65Gn7pLp7tJrM8Ha06OJHTnuPtdgfx4DpJzoPSNCiJmSZzthqtGkLfex+IPuyQiUCgG/dXt7oJ/X1f4Lv21aNCg5c9K6LPeH6BjHGpcXW8Rha9hoCzLXPoD7rUAdqWKegHtSL0+zdU8GVWX82yKqmEGuRJyOSDKO++pIG/25UgXSg/CRNRUkVMGrpfcWFQOkIe78dIO1MIjifC+bMc/laJ1q6xFLFWbAnj6PCpCSi3b8lY6jJxwfooVFFMMw0irvyuH8K/JM3LEP/Dz+MmJb5gBnx21P7F5Sl6eJI0fdEQxmvllrj8HTH5qtC4f4ikAmrSycS5HT1gMntjBbuF8aQX+aI6qEPXS68dcpFNR0J4sUUzpKPabsNfyDkX8jkjYajF5+2iAf9IzwOgDIiZckGXIAuhreBlV+NyJfJrKG7QJbQ6hdK+laSTBdzCn9v/R/ZxWXy9LLkX0kmAxhoa8GPMWqCJXjG405v1ng0FJbxkRAYsijHIOsThM6G56QNBKvW7/gEEoT1+DEGYzqsHVV1gHR9CX3wOyJjcs+bx4RW4WdQLBmUoapNaLkN6zHcWktuh9EL6mo7DZRkTOjvmEsv6bABEBAAG0IlRob21hcyBIYWxsZXIgPHRoYWxsZXJAcmVkaGF0LmNvbT6JAj4EEwECACgFAlH6X0sCGwMFCQPCZwAGCwkIBwMCBhUIAgkKCwQWAgMBAh4BAheAAAoJEKHCmQ/SsOFd4QkP/RyUrXafY9o7XIwiS6o2V5mrIZHEQ8M6PdAZDRl3/0FtrQ/cjbFvw3fxfXh
 IC261AS2f+b0EQr34e5T6XMTqDeZUNJUXLr+9w8FPPn1RQ8wO3wCKGVvplw/f QLVU8JKOKNYQsUnbUSGKwX0he1zGymH0isIiV/X572EgDgrcHHR+z8XIPuIIWfKl7J/xjaqg084kuyAiTw4DEH9RN8XVqTQpVPUh138/nx7GSvZJSS92OvKFaeGXGJ1MUUSKYUyyLQyHD6vxI26S8kEFkinwcn86tF7PblC+AiaS7tFBhW+Bwi641vjyNTsCDwxmhujhlgQhj17qhcG8xPETl2iv8QCOv2TGkvBc1DO2keheVP34bFYQm/vuYQ3heUfyJJWitbHoK9MWj5OUa5AM/uSvogXIL3sQD8K7QSvVTfbodN2WYWPNBVe7pgxifo8u2t3fYWaeySX4pOTGPmJQbr1apdTiTAg+yHpxG6x4FJFs1TsG/PeL81ioBQgIMzBvmqddUrkzAMlxiSBLvJLzPQ4i81F3EBPFvYAdu8z+YwYtRe0HJO2fI4Wi1VWCQ0ed9AmPjzJE+5t3pp6C73pvqthilc9A7EVKL/8aW79+5NCA9I5PQIRaFg9EmcEKGDaZ1pV3ZFtHNpqY7+YdlAkTdP7DPIOLow2rFkD+GksmEsvAxQfe
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.50.1 (3.50.1-1.fc39) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, 2023-11-22 at 13:33 +0100, Pablo Neira Ayuso wrote:
> Hi,
>=20
> On Wed, Nov 22, 2023 at 12:19:40PM +0100, Thomas Haller wrote:
> > - add helper script "json-pretty.sh" for prettify/format JSON.
> > =C2=A0 It uses either `jq` or a `python` fallback. In my tests, they
> > =C2=A0 produce the same output, but the output is not guaranteed to be
> > =C2=A0 stable. This is mainly for informational purpose.
> >=20
> > - add a "json-diff-pretty.sh" which prettifies two JSON inputs and
> > =C2=A0 shows a diff of them.
> >=20
> > - in "test-wrapper.sh", after the check for a .json-nft dump fails,
> > also
> > =C2=A0 call "json-diff-pretty.sh" and write the output to "ruleset-
> > diff.json.pretty".
> > =C2=A0 This is beside "ruleset-diff.json", which contains the original
> > diff.
>=20
> One silly question: Does the prettify hightlights the difference?

Yes. That that is the idea.

>=20
> tests/py clearly shows what is the difference in the JSON diff that
> quickly helps you identify what is missing.


As always, you will find some result files in /tmp/nft-
test.latest.$USER/, which I usually read with

  $ grep --color=3Dalways ^ -aR /tmp/nft-test.latest.*/ | less -R

there will be a new file there, named "ruleset-diff.json.pretty".

It contains the content of "./tests/shell/helpers/json-diff-pretty.sh"
output.


For example:

  $ cp tests/shell/testcases/bitwise/dumps/0040mark_binop_2.json-nft tests/=
shell/testcases/bitwise/dumps/0040mark_binop_3.json-nft
  $ ./tests/shell/run-tests.sh tests/shell/testcases/bitwise/0040mark_binop=
_3


leaves a file

     /tmp/nft-test.latest.*/test-tests-shell-testcases-bitwise-0040mark_bin=
op_3.1/ruleset-diff.json.pretty


with the following content:


Cmd: "./tests/shell/helpers/json-diff-pretty.sh" "tests/shell/testcases/bit=
wise/dumps/0040mark_binop_3.json-nft" "/tmp/nft-test.20231122-135045.550.28=
uKHu/test-tests-shell-testcases-bitwise-0040mark_binop_3.1/ruleset-after.js=
on"
--- tests/shell/testcases/bitwise/dumps/0040mark_binop_3.json-nft	2023-11-2=
2 13:50:12.114098356 +0100
+++ /tmp/nft-test.20231122-135045.550.28uKHu/test-tests-shell-testcases-bit=
wise-0040mark_binop_3.1/ruleset-after.json	2023-11-22 13:50:45.622065923 +0=
100
@@ -1 +1 @@
-{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "hand=
le": 0, "type": "filter", "hook": "output", "prio": 0, "policy": "accept"}}=
, {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr"=
: [{"mangle": {"key": {"ct": {"key": "mark"}}, "value": {"|": [{"<<": [{"pa=
yload": {"protocol": "ip", "field": "dscp"}}, 2]}, 16]}}}]}}]}
+{"nftables": [{"metainfo": {"version": "VERSION", "release_name": "RELEASE=
_NAME", "json_schema_version": 1}}, {"table": {"family": "ip", "name": "t",=
 "handle": 0}}, {"chain": {"family": "ip", "table": "t", "name": "c", "hand=
le": 0, "type": "filter", "hook": "input", "prio": 0, "policy": "accept"}},=
 {"rule": {"family": "ip", "table": "t", "chain": "c", "handle": 0, "expr":=
 [{"mangle": {"key": {"meta": {"key": "mark"}}, "value": {"|": [{"<<": [{"p=
ayload": {"protocol": "ip", "field": "dscp"}}, 2]}, 16]}}}]}}]}
--- /dev/fd/63	2023-11-22 13:50:45.627065918 +0100
+++ /dev/fd/62	2023-11-22 13:50:45.627065918 +0100
@@ -21,7 +21,7 @@
         "name": "c",
         "handle": 0,
         "type": "filter",
-        "hook": "output",
+        "hook": "input",
         "prio": 0,
         "policy": "accept"
       }
@@ -36,7 +36,7 @@
           {
             "mangle": {
               "key": {
-                "ct": {
+                "meta": {
                   "key": "mark"
                 }
               },

