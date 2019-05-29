Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DC2C28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 12:59:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 91822208CB
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 12:59:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="OcO5xT1T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbfE2M7d (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 08:59:33 -0400
Received: from mail-wr1-f44.google.com ([209.85.221.44]:35360 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfE2M7d (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 08:59:33 -0400
Received: by mail-wr1-f44.google.com with SMTP id m3so1735394wrv.2
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 05:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:to:cc:from:subject:organization:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Cjx7ohj7Vb/J6cz9PxR/5E6MO6hFK7n0gK8aVge3U2U=;
        b=OcO5xT1TX7+sGrQ0LTJabAjL+CYqaM7hg+igR/CItpsiioJEo5UN+E7XmoCLQxD1HM
         hzN6p5yC99KrId9ISWRi89tP1+Zqa53yKE+VWfvoFJ3068oeTuSl9NgLDDOu6XHIPybX
         cwzBkku3roKp6eDxNF2Kjs28csesm+N+tj4X4oX96qrWBElNMesQOp82+y/8q9I4mPH4
         jYE1qyFVq6YmejvK5r4/jBsBKyFVFNhJvZ6doOcz9A0RxvpuNWPa1chP/22p3ERapFeK
         rHZ+lTGFNx9tatX3hCViIi+bJkd33cB7MiyBbUdhHnwI2t/UoiIdsrXx62mkNYquhAhi
         J8tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:to:cc:from:subject:organization
         :message-id:date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=Cjx7ohj7Vb/J6cz9PxR/5E6MO6hFK7n0gK8aVge3U2U=;
        b=ffPoAwsHsjgQvbDUMNRfx4D/i1O1MnPzc8H3klJw8c5J03SxcoAk1MOjFu5iFEkJbK
         7JlQIfvT7NKQyVTTEj7dw0ZGF9xYBEFITdVcq5Xcjem3szVT8YkfyGAAgLfQGc/FE41/
         up8+A1jSSzcRME3WrKjBhckfc3qc5rC7Z+cdbr/syWodu/JGa+2VC4Dy2DGEvPa4abJ4
         xyZSnnPdx+jc8FpktQWtiosVkkr7FEJZlLqyNVJEJb+i3WdUuhxOBSVPabAc76755bEP
         Gll2cF0uTyCIWXKhyv9y3pbhvSGTiF6ru0eRYSeMP2EgP58ZE6b4Jksz2cWV2WELQpPs
         /ktw==
X-Gm-Message-State: APjAAAXArFYvIDRo3SKf+6YYWKS+WvM4LSLZbWCPhCuwzAOrAFkbf2N9
        10CRCry1bEvEr/PWCKB639dBcyCQq6A=
X-Google-Smtp-Source: APXvYqyVsB5YFjaUdWxRevCzbtRuGq/U57ESegPQmoCKVx8tjF20CvZ1maLzfo0zcdG5L2MdUVs4dw==
X-Received: by 2002:adf:e446:: with SMTP id t6mr7777644wrm.115.1559134766464;
        Wed, 29 May 2019 05:59:26 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:f493:8438:340f:beb2? ([2a01:e35:8b63:dc30:f493:8438:340f:beb2])
        by smtp.gmail.com with ESMTPSA id z25sm6316066wmi.5.2019.05.29.05.59.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 05:59:25 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
To:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel <netfilter-devel@vger.kernel.org>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Subject: nftables release
Organization: 6WIND
Message-ID: <65ec483a-b8d7-530b-373f-6dcdd5f668c6@6wind.com>
Date:   Wed, 29 May 2019 14:59:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

is there any plan to release an official version of the nftables user-space utility?
The last one (v0.9.0) is now one year old ;-)


Regards,
Nicolas
