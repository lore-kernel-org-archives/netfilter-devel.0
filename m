Return-Path: <SRS0=nEPA=2E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D05C43603
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Dec 2019 08:27:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F183120706
	for <netfilter-devel@archiver.kernel.org>; Sat, 14 Dec 2019 08:27:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="yCegVpCU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725893AbfLNI1j (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 14 Dec 2019 03:27:39 -0500
Received: from mail-wr1-f50.google.com ([209.85.221.50]:33241 "EHLO
        mail-wr1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbfLNI1h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 14 Dec 2019 03:27:37 -0500
Received: by mail-wr1-f50.google.com with SMTP id b6so1276695wrq.0
        for <netfilter-devel@vger.kernel.org>; Sat, 14 Dec 2019 00:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LHa3dQiWJlDXub8DbxjNfhIyEVmXkpSuaLzv1x3MU8Q=;
        b=yCegVpCUJgM3yIJQ0Xm4MHNE0y1Gqg0hlkBqf9b/k+ReB9iJxJpd7LFovejjD6agfS
         7o8hZMpjRfd3IbMTuhsvwbgwgANNfkEboTrAH9qUFTloUuNY1o0/Q9Ps3k5ncYhOPOhV
         s1x2NE56hN797W+K/QTFIzTpqNT5+jdB11SQJBkCoxuWp7xO45TNWa1rHrmZW9L8z1Wh
         /lJOa5OWjKLS+BoB0i4iR0NpH/8oHk+ZIVGmcCueAZh+8fuLqLoYfa2zVzmcq3MQ739R
         OjLjNPEKADCvUNm0Vtgz8oigCYAucSWmB0S4g3WkcvDay0Y9RQJjGnfhRDE/FXVTGC5+
         4x4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LHa3dQiWJlDXub8DbxjNfhIyEVmXkpSuaLzv1x3MU8Q=;
        b=UprB3aAA1B7+1PDMnakVjJOqROtzGwiwwwObRokMtFPw9WW7VN8dnnpFcBiO2HZF4r
         OvgJkvz/wqq+Y6zMwrzgYJ0kQkkkszyHmNLpCyAcNtTPbz7q7dkmnlkWTNdo+C363w28
         Yz0P7OdOqQsKIpwEvn7I9KFNQlbalJN4kGJp2bxmj35jqNXTQwfTo8Wv+FZiIIcJg3SI
         tNJL8IyvJqwxg9s4+LSq7WeMLWxnO+009zkEZ1MyYoHAHf9sI4O3kvJEsHmMTTkaXlUJ
         KESOnIiW9gjny4vxG52dSZGBNix6SY+48r+jLSJyFzIBBHEHhb5LyLTpq8iJjf7bRjY0
         T3Ng==
X-Gm-Message-State: APjAAAUYs8sNMPMux2Cz7fBzSloLNXcl8IRtixlXNogH0Vob9rUgBt6O
        yGsKLMKaw5Gntoq8rFcA3PZXYg==
X-Google-Smtp-Source: APXvYqwlzhArMNrZkqvROQofomigQB+B38RPfp8d/+ns1go+Z4vvzrQIHN+N+4wuN64QcuM6IXp28A==
X-Received: by 2002:adf:db84:: with SMTP id u4mr18005133wri.317.1576312055469;
        Sat, 14 Dec 2019 00:27:35 -0800 (PST)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id i10sm12613233wru.16.2019.12.14.00.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 00:27:35 -0800 (PST)
Date:   Sat, 14 Dec 2019 09:27:34 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 nf-next 4/5] netfilter: nft_tunnel: also dump
 OPTS_ERSPAN/VXLAN
Message-ID: <20191214082734.GD5926@netronome.com>
References: <cover.1576226965.git.lucien.xin@gmail.com>
 <e4812b0aef4aaeee9751fec15f5f34d6f983e134.1576226965.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4812b0aef4aaeee9751fec15f5f34d6f983e134.1576226965.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Dec 13, 2019 at 04:53:08PM +0800, Xin Long wrote:
> This patch is to add the nest attr OPTS_ERSPAN/VXLAN when dumping
> KEY_OPTS, and it would be helpful when parsing in userpace. Also,
> this is needed for supporting multiple geneve opts in the future
> patches.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Reviewed-by: Simon Horman <simon.horman@netronome.com>

