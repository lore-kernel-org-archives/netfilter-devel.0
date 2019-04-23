Return-Path: <SRS0=M2Uw=SZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81998C282E3
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 19:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50A7F21850
	for <netfilter-devel@archiver.kernel.org>; Tue, 23 Apr 2019 19:00:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ug2fMkin"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbfDWTAY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 23 Apr 2019 15:00:24 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46570 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbfDWTAX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 23 Apr 2019 15:00:23 -0400
Received: by mail-lf1-f68.google.com with SMTP id k18so12532343lfj.13;
        Tue, 23 Apr 2019 12:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lJAquJngVeLiE+27zlo3Haxi5bkf/Fn6M8UQM88Fq0Y=;
        b=Ug2fMkinEcto9NC7g+mxNs/cK/WpSlqguRRqvx0DxFih2QS3jybEZlVIYBGsHcCsBd
         T9dkt5F6QHmhM5PA9wazYh05Xc7iBYeWXytitHN9UUNX6rVn0gXPM0J0lsF0eXeQPaLH
         zRf/QxPBXQQBwPV2x4BdSdyABPcPZRVfPBb8NURi0fk+kwvJLo6Ym1YFUCzIPSR9E0PH
         ESLi5joyskwXaycJDfWday2CL4pazbZpBUa+x5wwYSLJXIpxElUgxA3kJJAW1h+AowCs
         hMt7Xx2J5FfHwcK3nYEtThA8lpTW6h3hvFaBr92umke9NSom12KmaWBkEW9JHRL6SgoB
         4oKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lJAquJngVeLiE+27zlo3Haxi5bkf/Fn6M8UQM88Fq0Y=;
        b=gOca3lKi4FyseNkyATFkMDpJf3feSOHyT5SecGT1bHhxtNYlRztOO5PPafGhn2/kLU
         Kt24glcSYAj3KIZ0xfFXivWUJzSYgLCOmwnUDxK5q7AiFRG9saXPAoaTKYJGiEBu04zR
         PE3yIDqtLeEg2RjnEtt+NAsYKBnGJQt/j3QurPZUVC8ZJj9/9UBScZ7EGBLcGscqD9Zq
         BrohtwG5sx+3+KeSv+OJn5MkaGEYsrw/Y8pMkH15KGYJYZD9PgtsFMgBIfT56IQ98QGx
         VSA1xZebqY7+faixYkJLPaKpn3zQ09N/OuwOAUnB6UhtNraty40EAYjxR0cNrzQrhW4/
         EJ0g==
X-Gm-Message-State: APjAAAV8K93RoXprgqqnGmfYY/LDls9z8w2wuyln565V6WU912quRecQ
        WiaO2ncvpfkEZpdTuwVYHO/99fcC
X-Google-Smtp-Source: APXvYqzl6YI8VYT+chHTZhsK71+KFjV1uKsnKgvohl1YjccuYNTUXoQS0HjEi3imfwGeThUHA7rByQ==
X-Received: by 2002:ac2:42d6:: with SMTP id n22mr3525480lfl.57.1556046019773;
        Tue, 23 Apr 2019 12:00:19 -0700 (PDT)
Received: from [192.168.1.19] (ciw222.neoplus.adsl.tpnet.pl. [83.31.46.222])
        by smtp.gmail.com with ESMTPSA id q18sm2713405lfm.81.2019.04.23.12.00.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 12:00:18 -0700 (PDT)
Subject: Re: [PATCH v2 61/79] docs: leds: convert to ReST
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Vadim Pasternak <vadimp@mellanox.com>,
        Pavel Machek <pavel@ucw.cz>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        linux-leds@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, netdev@vger.kernel.org
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
 <c8da7b666a127687471f38cbb5edc12d44814009.1555938376.git.mchehab+samsung@kernel.org>
From:   Jacek Anaszewski <jacek.anaszewski@gmail.com>
Message-ID: <a8d307d2-04c7-d63e-54a4-5082217e38e8@gmail.com>
Date:   Tue, 23 Apr 2019 21:00:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <c8da7b666a127687471f38cbb5edc12d44814009.1555938376.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Mauro,

Thank you for your effort.

On 4/22/19 3:27 PM, Mauro Carvalho Chehab wrote:
> Rename the leds documentation files to ReST, add an
> index for them and adjust in order to produce a nice html
> output via the Sphinx build system.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>   Documentation/laptops/thinkpad-acpi.txt       |   4 +-
>   Documentation/leds/index.rst                  |  25 ++
>   .../leds/{leds-blinkm.txt => leds-blinkm.rst} |  63 ++---
>   ...s-class-flash.txt => leds-class-flash.rst} |  49 ++--
>   .../leds/{leds-class.txt => leds-class.rst}   |  15 +-
>   .../leds/{leds-lm3556.txt => leds-lm3556.rst} | 100 ++++++--
>   .../leds/{leds-lp3944.txt => leds-lp3944.rst} |  23 +-
>   Documentation/leds/leds-lp5521.rst            | 115 +++++++++
>   Documentation/leds/leds-lp5521.txt            | 101 --------
>   Documentation/leds/leds-lp5523.rst            | 147 ++++++++++++
>   Documentation/leds/leds-lp5523.txt            | 130 ----------
>   Documentation/leds/leds-lp5562.rst            | 137 +++++++++++
>   Documentation/leds/leds-lp5562.txt            | 120 ----------
>   Documentation/leds/leds-lp55xx.rst            | 224 ++++++++++++++++++
>   Documentation/leds/leds-lp55xx.txt            | 194 ---------------
>   Documentation/leds/leds-mlxcpld.rst           | 118 +++++++++
>   Documentation/leds/leds-mlxcpld.txt           | 110 ---------
>   ...edtrig-oneshot.txt => ledtrig-oneshot.rst} |  11 +-
>   ...ig-transient.txt => ledtrig-transient.rst} |  63 +++--
>   ...edtrig-usbport.txt => ledtrig-usbport.rst} |  11 +-
>   Documentation/leds/{uleds.txt => uleds.rst}   |   5 +-
>   MAINTAINERS                                   |   2 +-
>   drivers/leds/trigger/Kconfig                  |   2 +-
>   drivers/leds/trigger/ledtrig-transient.c      |   2 +-
>   net/netfilter/Kconfig                         |   2 +-
>   25 files changed, 996 insertions(+), 777 deletions(-)
>   create mode 100644 Documentation/leds/index.rst
>   rename Documentation/leds/{leds-blinkm.txt => leds-blinkm.rst} (56%)
>   rename Documentation/leds/{leds-class-flash.txt => leds-class-flash.rst} (74%)
>   rename Documentation/leds/{leds-class.txt => leds-class.rst} (92%)
>   rename Documentation/leds/{leds-lm3556.txt => leds-lm3556.rst} (70%)
>   rename Documentation/leds/{leds-lp3944.txt => leds-lp3944.rst} (78%)
>   create mode 100644 Documentation/leds/leds-lp5521.rst
>   delete mode 100644 Documentation/leds/leds-lp5521.txt
>   create mode 100644 Documentation/leds/leds-lp5523.rst
>   delete mode 100644 Documentation/leds/leds-lp5523.txt
>   create mode 100644 Documentation/leds/leds-lp5562.rst
>   delete mode 100644 Documentation/leds/leds-lp5562.txt
>   create mode 100644 Documentation/leds/leds-lp55xx.rst
>   delete mode 100644 Documentation/leds/leds-lp55xx.txt
>   create mode 100644 Documentation/leds/leds-mlxcpld.rst
>   delete mode 100644 Documentation/leds/leds-mlxcpld.txt
>   rename Documentation/leds/{ledtrig-oneshot.txt => ledtrig-oneshot.rst} (90%)
>   rename Documentation/leds/{ledtrig-transient.txt => ledtrig-transient.rst} (81%)
>   rename Documentation/leds/{ledtrig-usbport.txt => ledtrig-usbport.rst} (86%)
>   rename Documentation/leds/{uleds.txt => uleds.rst} (95%)
> 
> diff --git a/Documentation/laptops/thinkpad-acpi.txt b/Documentation/laptops/thinkpad-acpi.txt
> index 3de3c95f01f6..65719384fc36 100644

Acked-by: Jacek Anaszewski <jacek.anaszewski@gmail.com>

-- 
Best regards,
Jacek Anaszewski
