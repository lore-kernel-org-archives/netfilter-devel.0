Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BECDC00140
	for <netfilter-devel@archiver.kernel.org>; Tue,  2 Aug 2022 06:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230298AbiHBGVc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 2 Aug 2022 02:21:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbiHBGVa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 Aug 2022 02:21:30 -0400
Received: from mo1.myeers.net (mo1.myeers.net [87.190.7.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FA8167D4
        for <netfilter-devel@vger.kernel.org>; Mon,  1 Aug 2022 23:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=airbus.com; i=@airbus.com; l=1466; q=dns/txt;
  s=eers-ng2048; t=1659421289; x=1690957289;
  h=mime-version:from:date:message-id:subject:to:
   content-transfer-encoding;
  bh=zttP5THG6k9gm2m7D8dPnM8fir8zQO0JBSmr+Jv1H4E=;
  b=HYyUYPOQoMK1nkhym2I6YDJ3ewIGphIc/q344Qd8v5O/+4mU1UlhasFJ
   qdsUMwIA37YRpgw/SK0FfyCAY3TRVxPXLPtDY/LrsN8jBxL4Uyd5fXvY2
   s9e8Q2GT0fuKwkpUryNo+Xl3xlpCFMqWJneWjOzAgy+j1owhvakdBgCHK
   ak5saUVzT9UGQtk8NocZlTh15eFkZiL4qmJ63BMoKKJVkavMeO+EwhwLC
   zftb289TXybhApAiwvkNurr75E6GN4N9R8WE6KWv54wWJ9ot2yHi6LVVN
   xopjOIb/EZUsQ5ZbEXtPGY7+XqAFZwFsMT+fcqLns9ooVgfGHvV3U5Jgg
   Q==;
Received-SPF: Fail (MX: domain of
  nicolas.maffre.external@airbus.com does not designate
  209.85.208.198 as permitted sender) identity=mailfrom;
  client-ip=209.85.208.198; receiver=MX;
  envelope-from="nicolas.maffre.external@airbus.com";
  x-sender="nicolas.maffre.external@airbus.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 ip4:87.190.7.224/28
  ip4:80.242.167.16/28 ip4:83.125.118.202 ip4:83.125.118.114
  ip4:217.239.138.48/28 ip4:62.217.58.112/28
  include:group1._spf.airbus.com include:group2._spf.airbus.com
  include:group3._spf.airbus.com include:group4._spf.airbus.com
  -all"
Received-SPF: None (MX: no sender authenticity information
  available from domain of postmaster@mail-lj1-f198.google.com)
  identity=helo; client-ip=209.85.208.198; receiver=MX;
  envelope-from="nicolas.maffre.external@airbus.com";
  x-sender="postmaster@mail-lj1-f198.google.com";
  x-conformance=spf_only
Authentication-Results: MX; spf=Fail smtp.mailfrom=nicolas.maffre.external@airbus.com; spf=None smtp.helo=postmaster@mail-lj1-f198.google.com; dkim=pass (signature verified) header.i=@airbus.com
X-Ironport-Dmarc-Check-Result: validskip
IronPort-SDR: GTre1XPjOkDeJhbw8mHKxfgTZRCso0e7dkuxp0iZaezEZxxO1Mb09na0K7RCD6S/eyJw0XdLlK
 iBgj1b6cj9RQ==
IronPort-Data: A9a23:RJ1vA6xBV8ElgUhLMW56t+dIxyrEfRIJ4+MujC+fZmUNrF6WrkUGn
 WIZC2GObPvYZWH9eY0gPYjg9B4B6pbTnNA1QAZlqXw8FHgiRegppDi6wuUcGwvLdqUvdK/rh
 iknQoGowPocFxcwnT/wdOm6xZVA/fvQHOCkWLaeYnkZqTJME0/NtzoywobVvaY42bBVMyvV0
 T/Di5W31G2NglaYAUpIg063ky6Didyp0N8uUvzSUtgQ1LPWvyF94JvyvshdJVOgKmVfNrbSq
 +ouUNhVV44ElirBBO9Jkp6jGqELarvbPAzLjngPHqb700gEqSs13aI2cvEbbC+7iR3Tx4E3m
 IgL78TgD154bsUgm8xEO/VcOyd/NqpC8aSBJHGxv9aeiUDWb3b2xfxqJEg3J4cF4aB8BmQmG
 fkwc25dNkzT17vsqF68YrA02p5LwNPQFIUSpn9hyS3UF7MqTI7OR43U6tJCmjQ9nMZDGbDZf
 cVxVNbFRACYNkYJZ0NOXcp4xPPy0yG5KGED90bO8PJxvnyMmSVv9JPoFvHJXPCKYeRcuHyYg
 ljd2V7nJi0CEuCF7wSE12b13rqX2XvvMG4JPLix9/ovhF/Kg2JKWU1QWly8rv20zEW5Xrpix
 4Uv0nNGhYA79VahU8K7VBq9yENodDZGMzaMO4XWKT1hy5Y4Jy6cD2kACzpDMZko7Z5mAzMt0
 VCNkpXiAjkHXHh5j56C3u/8kN9wEXB9waw+iessRAof6cT45oo0i3oji/59RbWtgISd9S7Yn
 1i3kcTmu4gusA==
IronPort-HdrOrdr: A9a23:qC5EgaA94QECiMnlHemd55DYdb4zR+YMi2TDsHoBMCC9E/bo8f
 xG+c5w6faaskdyZJhNo6HiBEDiexPhHPxOkOws1N6ZNWGMhILCFvAH0WKN+UyGJwTOssJ66I
 cISdkHNDQyNzRHZATBjTVQ3+xP/DBPys/Iudvj
X-IronPort-AV: E=Sophos;i="5.93,210,1654552800"; 
   d="scan'208";a="368048812"
Received: from mail-lj1-f198.google.com ([209.85.208.198])
  by mo1.myeers.net with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Aug 2022 08:21:26 +0200
Received: by mail-lj1-f198.google.com with SMTP id d4-20020a2e9284000000b0025e0f56d216so2823579ljh.7
        for <netfilter-devel@vger.kernel.org>; Mon, 01 Aug 2022 23:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=airbus.com; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/+Pyftk4Wfhf+etG6CYBLB3mxsyFGiVXkO7jNe09ORg=;
        b=hL8+2hYJ7oWftDmbklYxeaNp3xvgwZOjk06vlB7en+AUliNLpVUtKbP1WpgYM7xp4i
         iU4G2lINepNqRpGG6IA20QeX5f8gxcg7Nu7KWbk43ZnYruwaR1AOsg/ziUPnEHvf3C/7
         Zv9+41A8IGcmzM1t2ybVRytTpY1t+lDp0qTW1hbDUuaQ7RxKTWNBOwduNN4/81WRsIWu
         CPh+3HbRy5mIMjpqU25hRaFc/iW9JcPYPNeY0i22ftlOEaKf8xMRlqZUuO9IW549LikU
         jMB2BlsiPF/KgLcYL9DVf80Pochs+efjMj5tvzTwv8vWf4IaPmCOhlpSIk0UnVzrRODU
         Ik1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/+Pyftk4Wfhf+etG6CYBLB3mxsyFGiVXkO7jNe09ORg=;
        b=2Mx8bqyzxxvzU7TmGcRh1ysdR3b5igwWI6zIcOdWlV6id7FzZLUupTjM1XpS56CoK8
         5r8dAoMZMUHW5aqTnbSjK227pJqcAh4Eenl0R74ifz8qT+65+J3HtpRmzsRlXZOJLZ7M
         CzIFRk2Z12r0hVkMGrBmTGlTjFVwvlh8G+J2+GRLgHlpLPSc7NjMJ4a54vpHj1Xp1Wxy
         hUzljl3EyB+bO6nqa80f4d/E3hwHMH82ee11hCuF3LtzBnPivJ2MnihTXjwd8oGKo53k
         DmE+fGjIUxQAB49JcFTlHFH+fujcxWqVJjJio7w1MIFYg30L0LBqOHx6HPTT8iacFd68
         aRng==
X-Gm-Message-State: ACgBeo1G6mVq5wxdgyHjH6d0/B4rJAExqU0NJPuMZCDQ4odFpmHDrt1O
        4gZU7TC/ihQRtj5p0ZcEEdtGdot8k/iucDsROzOM1BCF0TPpSN9w5STp2ILSuw4OyT45C3hATX0
        c0h9k1g230vBxPEV4lQbpwLdkBQiaqjCB7CFgUwVxHkSh
X-Received: by 2002:a05:6512:b96:b0:48b:19c:5332 with SMTP id b22-20020a0565120b9600b0048b019c5332mr2174637lfv.151.1659421285587;
        Mon, 01 Aug 2022 23:21:25 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6YiUmhmeJEnJLSunnFDGdkOZVWnFdSM1mdtiYDJJYF3cwSXdUM1JFFKR9ARUCN33hPQtERoQMASsw81/VkNIk=
X-Received: by 2002:a05:6512:b96:b0:48b:19c:5332 with SMTP id
 b22-20020a0565120b9600b0048b019c5332mr2174631lfv.151.1659421285214; Mon, 01
 Aug 2022 23:21:25 -0700 (PDT)
MIME-Version: 1.0
From:   Nicolas MAFFRE <nicolas.maffre.external@airbus.com>
Date:   Tue, 2 Aug 2022 08:21:14 +0200
Message-ID: <CAHWqpUO3v0gtUYND=JNHwCU3W2qVaeVujYaKvZudvmmFqMpwpQ@mail.gmail.com>
Subject: iptables v1.6.2 EOS date
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

SGVsbG8sCgpJJ20gd29ya2luZyBvbiBhIHByb2plY3QgdGhhdCB1c2VzIGlwdGFibGVzIHYxLjYu
MiBhbmQgSSBuZWVkIHRvIGtub3cKaWYgdGhlcmUgaXMgYW4gIkVuZCBvZiBzdXBwb3J0IiBkYXRl
IGZvciB0aGlzIHZlcnNpb24gb2YgdGhlIHNvZnR3YXJlCmlwdGFibGVzID8KClRoYW5rIHlvdSBp
biBhZHZhbmNlLAoKQmVzdCByZWdhcmRzCgpOaWNvbGFzIE1BRkZSRQoKLS0gCgpTT05PVklTSU9O
IC0gVE9VTE9VU0UKR3JvdXBlIE9ydGVjCgpUw6lsLiArIDMzICgwKTUgNjIgNzQgMzAgNzUKCjQg
aW1wYXNzZSBBbGljZSBHdXkKCjMxMzAwIFRPVUxPVVNFClRoZSBpbmZvcm1hdGlvbiBpbiB0aGlz
IGUtbWFpbCBpcyBjb25maWRlbnRpYWwuIFRoZSBjb250ZW50cyBtYXkgbm90IGJlIGRpc2Nsb3Nl
ZCBvciB1c2VkIGJ5IGFueW9uZSBvdGhlciB0aGFuIHRoZSBhZGRyZXNzZWUuIEFjY2VzcyB0byB0
aGlzIGUtbWFpbCBieSBhbnlvbmUgZWxzZSBpcyB1bmF1dGhvcmlzZWQuCklmIHlvdSBhcmUgbm90
IHRoZSBpbnRlbmRlZCByZWNpcGllbnQsIHBsZWFzZSBub3RpZnkgQWlyYnVzIGltbWVkaWF0ZWx5
IGFuZCBkZWxldGUgdGhpcyBlLW1haWwuCkFpcmJ1cyBjYW5ub3QgYWNjZXB0IGFueSByZXNwb25z
aWJpbGl0eSBmb3IgdGhlIGFjY3VyYWN5IG9yIGNvbXBsZXRlbmVzcyBvZiB0aGlzIGUtbWFpbCBh
cyBpdCBoYXMgYmVlbiBzZW50IG92ZXIgcHVibGljIG5ldHdvcmtzLiBJZiB5b3UgaGF2ZSBhbnkg
Y29uY2VybnMgb3ZlciB0aGUgY29udGVudCBvZiB0aGlzIG1lc3NhZ2Ugb3IgaXRzIEFjY3VyYWN5
IG9yIEludGVncml0eSwgcGxlYXNlIGNvbnRhY3QgQWlyYnVzIGltbWVkaWF0ZWx5LgpBbGwgb3V0
Z29pbmcgZS1tYWlscyBmcm9tIEFpcmJ1cyBhcmUgY2hlY2tlZCB1c2luZyByZWd1bGFybHkgdXBk
YXRlZCB2aXJ1cyBzY2FubmluZyBzb2Z0d2FyZSBidXQgeW91IHNob3VsZCB0YWtlIHdoYXRldmVy
IG1lYXN1cmVzIHlvdSBkZWVtIHRvIGJlIGFwcHJvcHJpYXRlIHRvIGVuc3VyZSB0aGF0IHRoaXMg
bWVzc2FnZSBhbmQgYW55IGF0dGFjaG1lbnRzIGFyZSB2aXJ1cyBmcmVlLgo=

