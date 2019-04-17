Return-Path: <SRS0=tvQP=ST=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AD9AC282DA
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 11:55:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05AB820835
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Apr 2019 11:55:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance-com.20150623.gappssmtp.com header.i=@bytedance-com.20150623.gappssmtp.com header.b="J/SCETSX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732179AbfDQLzF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Apr 2019 07:55:05 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:37102 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732004AbfDQLzF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Apr 2019 07:55:05 -0400
Received: by mail-pg1-f175.google.com with SMTP id e6so11912207pgc.4
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Apr 2019 04:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=xSJJ8odYWT/rkj0fwA6Bx08RLhyHIbojdyfcmR8jBXQ=;
        b=J/SCETSX6aL15JOSCMUfcx1/rb9wZF27c0SbziT0xWYM/Y5pjaPmD0oo3W6H6EcoMB
         /QVtARdWAA1hgh8Nr1yXnBF2rc0P0JvwKEBNYVXKJDXJ3XsMIhws8XQF6mzvIRswhHqt
         lEEnmAUxFK4hckwefBjKqOTaQagrOPMgHVdnTIU6d8xJmHyJnW3pl/3v0/IqXGdeOiYL
         ZJngnXqAOKUZYK4ObCCmpwQz+yu7RUGRVgh7l/nKERv+7gIv9usPkna+GxUAcs653WPO
         zbei9nM4zBsJTyeKHwLlevLPUDHxlOuIud7MBixLoOPBBgGg9Sp1AZWgpFln9VQ2DIMO
         4CLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=xSJJ8odYWT/rkj0fwA6Bx08RLhyHIbojdyfcmR8jBXQ=;
        b=YE5+jwDLcrgYn77hGDHqU4MQPjnys9sdtCxaDEP5+z/mOoQxfJLOz+W3uuQr+zqr3q
         GDgAHzGytcmrKMrH8guAmJn2TqrejknwPsSPgAyVb4xAecxqssyErxBuretruG592W06
         Mv8Bfk15slrEgTodJ3ia1J95/amo0rTKUr57epMC8396llGJfg8n+KPsnqJkWExuc1s9
         CDFggVMqJYcMCXq8AUHh7hF5Iuk1qbkoXOcQ+9Qn449rjmglAP1TaMcLfqnjBrR0zCSM
         W1L1KgKD5hLHhhdaPn0ZNqyFzqJGmRjL7wygqmtQRBMu2PF1LaLTs0GchMRZR27qAGG+
         1P6Q==
X-Gm-Message-State: APjAAAV7vZuVv9PXzkCtSrrr3zBg4LqMQcExSdL1iHkr38DJaWgLs7hV
        J2JWZTsYCv9Hwukwi8Ip/4bYACzNlN1yOA==
X-Google-Smtp-Source: APXvYqzHuYe7ZvF7F+7tdf4niRLU0BM+uTTXnY6c+3iNnlntr5yJxVvKvFbaIqtfBXgYc9gn4q8PHg==
X-Received: by 2002:a63:1064:: with SMTP id 36mr82198387pgq.155.1555502104382;
        Wed, 17 Apr 2019 04:55:04 -0700 (PDT)
Received: from bytedancedeMacBook-Air.local ([61.120.150.77])
        by smtp.gmail.com with ESMTPSA id h8sm76056131pfo.149.2019.04.17.04.55.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Apr 2019 04:55:03 -0700 (PDT)
Date:   Wed, 17 Apr 2019 19:54:59 +0800
From:   Xiaozhou Liu <liuxiaozhou@bytedance.com>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        zhangyongsu@bytedance.com, wenxudong@bytedance.com
Subject: Re: [External Email] Re: RFC: NAT's default behavior of forwarding
 un-NATed packets
Message-ID: <20190417115457.l6fblixeihez7blc@bytedancedeMacBook-Air.local>
References: <20190417080242.jas4vongrv5fivzx@bytedancedeMacBook-Air.local>
 <nycvar.YFH.7.76.1904171048490.11120@n3.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <nycvar.YFH.7.76.1904171048490.11120@n3.vanv.qr>
User-Agent: NeoMutt/20180323
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Apr 17, 2019 at 10:58:37AM +0200, Jan Engelhardt wrote:

Hi Jan,
> 
> I disagree. The ct state may be absent because the firewall has an empty state
> (e.g. reboot / `conntrack -F`) — that alone does not make the TCP connection
> invalid. Blocking ct-less packets breaks the user expectation to get a timely
> response (the more so on connection shutdown).
> 

Allowing ct-less packets out does not help in this situation either. If for
some reason the NAT's ct gets emptied, and some abnormal packets (orphaned
SYN-ACK/FIN) pass through SNAT without NATed, they'd still carry their inner
source IP (e.g. 192.168.X.X) in the header, which will not be respected outside
of our private network. Hence, although the bad packets are not dropped by NAT,
they can go to the internet but eventually gets dropped somewhere else. So the
user's experience would be the same as the packets are dropped by NAT. This
is what happened here in our network.

On the other hand, we see that normal established-state packets can setup ct
info on-the-fly even if NAT's ct gets emptied, and can be correctly handled
by SNAT later. User's expectation is not broken.

> NF_ACCEPT is the proper action, because it mirrors the default policy when the
> firewall is unconfigured. Pretty much all common acts of dropping, directly or
> indirectly, are opt-in.

Resonable.

But if an admin setup a SNAT, he/she really does not expect any packet with
inner-source-IP showing on the outgoing wire. ;( Not everyone knows that filtering
of such packets should setup explicitly. At least that is the case here until
we dug into kernel source code. It's a little bit counter intuitive.

> 
> iptables -I FORWARD -m conntrack --ctstate UNTRACKED -j DROP
> 
> Or better yet, model your ruleset such that
>  --ctstate NEW/ESTABLISHED/$OtherwiseGood -j ACCEPT
>  -P DROP

Thanks for your reply and advice!


Regards,
Xiaozhou
