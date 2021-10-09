Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 646F9C433F5
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 12:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41A4460F70
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Oct 2021 12:19:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232978AbhJIMVw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Oct 2021 08:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbhJIMVv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Oct 2021 08:21:51 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5BFC061570
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Oct 2021 05:19:54 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r18so38217021wrg.6
        for <netfilter-devel@vger.kernel.org>; Sat, 09 Oct 2021 05:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=AjHipsnHPuQmV7iTk4X8/BkfFZ7YJZtFNPlw9DGiwfY=;
        b=q3TfM5Ys1X2w7g6Z+fJGG2BNTsx+LFC+KA8IhmfZZbVkZEJUbIf/09IGagF+QF1a1f
         vGMEXfQRK0913MXrKbIF4xkwvA/po4waNgcY/nfQ5ZxvTLg1q1oqCC7JRYYu3eBBo1X+
         Fs4i6WHaLhR8U7l6Mm5MV+3Ri85ip+MuCXqRasVywRmP6AQRxzpQQb15U7dKvNhk2Dwz
         FnCavrh+NrRF91/vrMhwOAA0EV4igd2giQ4Jnb1FMjtN85TXjwzlqqpH77xY8xpT7Wp0
         PZ2Wn4MiEXj8jl1L+tNtN/hzKTTxBdFOBTTUeQpJZX8881rbqHN5Oe0BZhOIuX3GF2jx
         xCRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=AjHipsnHPuQmV7iTk4X8/BkfFZ7YJZtFNPlw9DGiwfY=;
        b=nCQpxtvzwJHHxl8vH+cVPTwMXBbC6EsguL+Q1t4EuN1BC2y7L2snclB14EO8FO77Of
         frqA7CRAQlGmrUa0No7BiTkXbJeongRwMfxX3AuG07OEtGfSGlx+0cJLFi8MQ2MFPazA
         VFaIaLs9Dub2RqxipJdtFE7ZNwFbuogsIw52Eu7wI4kN3ebjaMuOLm5Nb3yf7Vr3qEen
         9thOsoOJkM7Wb5zAjdcEYVUmbPuGIdTzzHuUn4kZiqoPZqezq9h637cDVtpBRkD6xdrp
         4OzaZpVKaHRA+h5cokTj0SO09DDRtTIkaBJJg9bSz5PuB0kW6ep3gQGEIR0uLo/lblwm
         5NtA==
X-Gm-Message-State: AOAM5333M46NTBAM4u/THncFXbqCsPXFxi9Ayg5Iwi0044wXPCgYYegm
        etGA0R3LKUaIdLHasSX3FGBjWgwDPioGItBLoQE=
X-Google-Smtp-Source: ABdhPJzkYl8DFJRb22AsWA76ns+6zyU1bv0aQEyG+S2c7h1Rv3Pmt+FdK9gmL6n8+wNgnL/9n4YXXg==
X-Received: by 2002:a05:6000:1866:: with SMTP id d6mr10825202wri.141.1633781993124;
        Sat, 09 Oct 2021 05:19:53 -0700 (PDT)
Received: from [192.168.1.109] ([31.56.181.233])
        by smtp.gmail.com with ESMTPSA id y5sm2131050wma.5.2021.10.09.05.19.50
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Oct 2021 05:19:52 -0700 (PDT)
To:     netfilter-devel@vger.kernel.org
From:   alireza sadeghpour <alireza0101sadeghpour@gmail.com>
Subject: xtable-addons document request
Message-ID: <04436e65-8c72-e2e5-d5ca-e45fd96575eb@gmail.com>
Date:   Sat, 9 Oct 2021 15:49:45 +0330
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,
I've some questions about Xtable-addons:

1. is there any tool in xtable-addons that can help me to change MTU 
field of the incoming / outgoing packets?
2. as xtable-addons user guide, I've found the man page of xtable-addons 
but I think it is not a Comprehensive document. I would really 
appreciate it if anyone can share a comprehensive document about 
xtable-addons.


Sincerely

