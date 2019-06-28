Return-Path: <SRS0=rhnh=U3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F8AC4321A
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 18:57:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FFC7205F4
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Jun 2019 18:57:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="XoArU2Aw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbfF1S51 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Jun 2019 14:57:27 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42609 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbfF1S50 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Jun 2019 14:57:26 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so3707538plb.9
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2019 11:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=GEJr3AqvHre2EqiUp9wkeTIrlXFQndtx5Gxgp/CLC/Y=;
        b=XoArU2Aw8uy6yHzMzOQ8pchviB6L+RP4fgA/8H3T5PNGYyVaXqKQqTIwc7a4oy+fnV
         F1iR3tXMQ34FbQ+fE8PXhJfHqbNf+Sn8tcEf7KYCanV+dVUAQA5PC6ql/3/lkLjzI4Cv
         BT9bbsuFZ5wsJLWle1D+GKJmmk4aHobb+e2eY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=GEJr3AqvHre2EqiUp9wkeTIrlXFQndtx5Gxgp/CLC/Y=;
        b=r/yKra+fQd+XYZPL1dyMP9iaWEKaznjAVyB/SWVrxsjlM+LYfa0ddqfijjPM7ohhC2
         w+JTcmV47upc3bfv1r9SDpQ4w4Q3T9wXaqKoeh3YFri1hf9VlCktNHHaL3OYQ130RjbY
         vno+JsY9V5sng6LqM/WivRG2Cn/PZrKIr5bjS6u1oAw7S/cmVKCB1MoZZZSuZ+IjlnTL
         oNulzZznIKcnUvfLR8gaTgrut2CVudwknNR6e4oQBNhha62xzCEnQ5IE7t0XPAu+pZ8o
         1LjRimHlDga7J264LwgXnj1gQJml27yQ+A5lCv8EIGvtRDTMc+Mfs/sevrptEAd+ljMw
         aO+w==
X-Gm-Message-State: APjAAAWsFWX5nlIPb5hg5Hxa97zLvlG5dVZR9qSIVplolvP50lhcmhbR
        uaDB4JkNNO13/Ub7fv8ovbyCgw==
X-Google-Smtp-Source: APXvYqxFoDW9J1n1b7IoCWK5H6zYvA3wRtWclaCyF1V0DeG5Vz04P8IhMaf+FOo/j1jTbYYohqE2hQ==
X-Received: by 2002:a17:902:aa03:: with SMTP id be3mr13363364plb.240.1561748246107;
        Fri, 28 Jun 2019 11:57:26 -0700 (PDT)
Received: from [10.230.29.90] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b15sm3008737pfi.141.2019.06.28.11.57.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 28 Jun 2019 11:57:25 -0700 (PDT)
Subject: Re: [PATCH 2/4] lpfc: reduce stack size with
 CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE
To:     Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        James Morris <jmorris@namei.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        netdev@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Hannes Reinecke <hare@suse.com>, Willy Tarreau <w@1wt.eu>,
        Silvio Cesare <silvio.cesare@gmail.com>
References: <20190628123819.2785504-1-arnd@arndb.de>
 <20190628123819.2785504-2-arnd@arndb.de>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <3027eebb-e49f-6db6-ae0a-39a61c0e34e1@broadcom.com>
Date:   Fri, 28 Jun 2019 11:57:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190628123819.2785504-2-arnd@arndb.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 6/28/2019 5:37 AM, Arnd Bergmann wrote:
> The lpfc_debug_dump_all_queues() function repeatedly calls into
> lpfc_debug_dump_qe(), which has a temporary 128 byte buffer.
> This was fine before the introduction of CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE
> because each instance could occupy the same stack slot. However,
> now they each get their own copy, which leads to a huge increase
> in stack usage as seen from the compiler warning:
>
> drivers/scsi/lpfc/lpfc_debugfs.c: In function 'lpfc_debug_dump_all_queues':
> drivers/scsi/lpfc/lpfc_debugfs.c:6474:1: error: the frame size of 1712 bytes is larger than 100 bytes [-Werror=frame-larger-than=]
>
> Avoid this by not marking lpfc_debug_dump_qe() as inline so the
> compiler can choose to emit a static version of this function
> when it's needed or otherwise silently drop it. As an added benefit,
> not inlining multiple copies of this function means we save several
> kilobytes of .text section, reducing the file size from 47kb to 43.
>
> It is somewhat unusual to have a function that is static but not
> inline in a header file, but this does not cause problems here
> because it is only used by other inline functions. It would
> however seem reasonable to move all the lpfc_debug_dump_* functions
> into lpfc_debugfs.c and not mark them inline as a later cleanup.

I agree with this cleanup.

>
> Fixes: 81a56f6dcd20 ("gcc-plugins: structleak: Generalize to all variable types")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   drivers/scsi/lpfc/lpfc_debugfs.h | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
>

Reviewed-by: James Smart <james.smart@broadcom.com>

-- james

