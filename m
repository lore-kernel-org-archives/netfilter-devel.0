Return-Path: <SRS0=6wcg=YD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0B85ECE596
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 04:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CAFB218AC
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Oct 2019 04:25:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=netronome-com.20150623.gappssmtp.com header.i=@netronome-com.20150623.gappssmtp.com header.b="eZn5FosL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfJJEZG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Oct 2019 00:25:06 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32915 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfJJEZG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Oct 2019 00:25:06 -0400
Received: by mail-pl1-f196.google.com with SMTP id d22so2146375pls.0
        for <netfilter-devel@vger.kernel.org>; Wed, 09 Oct 2019 21:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=F2mWN6iONW+mLLRJyrXLX3Mqwxx68njinFB093kEhkw=;
        b=eZn5FosLXe+fiRRmpB6ryaaoYD1tGLkVUMy4O2wDqlMSTpoyb/ivArjB+DV5gr7+Sf
         9zj1ab4evn+7oQJEETVg0tHAr4v+PSKgH/xW2+3kWA8RmvdAnDX+f48hQhhhXZv77+tB
         vRmd4YNclxFP2s+9bLvWEn0wYs1jQzjt/u3IWYqKo5annaJKePlMXFdfGJqwWUSuTgeL
         T40rWhEFQYaXcVdTio+3mcmH7+pc4yq+hiV/jj+gEmfB3N7LVsKMZocFt3kO4ydEC7c2
         YWhGn9507jTzbrpc8qxWa5UXCY8u/Y7U8MjejDrcMISQQ2LjXT8MpR2HtX+tbsGuRXBE
         QKTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=F2mWN6iONW+mLLRJyrXLX3Mqwxx68njinFB093kEhkw=;
        b=cKpP6fJJp+F0crL+WKQzCrjjeEYF/T0FyeNMF0uK4GlNIBhQcDIn68/9axlS/akQVY
         6doCi5+b2ao2LOlxFQzVqeHcH6mhDZP+SLCVNSUh5xgBCS4J2sNXGvcxd+EMMo6aRu/F
         j8FGwAOAtDgqx/KruKGsapPXgp+mLJ8vY+z21zCn4YmaUl4A8HOxwvaV2ToCNeqvA4Hl
         /0ZUDFoxXBC3OU2GLGpYfI2+STPfxtsWSNVBUglanGcRW3aiSArLth9sxE2USZvM5CkY
         pVehx6g6mqDtAJGfHZd6/N/4SwgbtxfcYjH5Yws0OudQxFl/Ymw1YAJ7Ud8D6ZlvqOHl
         +Miw==
X-Gm-Message-State: APjAAAVttshi0zCmU8IEcImZfcJX1f+4tjhVUVgPYcXrrYVcJaOxpIg4
        g2/rhNZtrvc42yw6ZRaNYmILUw==
X-Google-Smtp-Source: APXvYqynM/govpFUXiDmKtrtBuM+YvQonis/gzdNY0zb3g+8xM5GSCV5XpIVAUZNAKVdywvpRG05Eg==
X-Received: by 2002:a17:902:bc4c:: with SMTP id t12mr6816220plz.53.1570681505624;
        Wed, 09 Oct 2019 21:25:05 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id k93sm7601550pjh.3.2019.10.09.21.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Oct 2019 21:25:05 -0700 (PDT)
Date:   Wed, 9 Oct 2019 21:24:51 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Jozsef Kadlecsik <kadlec@netfilter.org>
Subject: Re: [PATCH net] netfilter: conntrack: avoid possible false sharing
Message-ID: <20191009212451.0522979f@cakuba.netronome.com>
In-Reply-To: <20191009161913.18600-1-edumazet@google.com>
References: <20191009161913.18600-1-edumazet@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed,  9 Oct 2019 09:19:13 -0700, Eric Dumazet wrote:
> As hinted by KCSAN, we need at least one READ_ONCE()
> to prevent a compiler optimization.
> 
> More details on :
> https://github.com/google/ktsan/wiki/READ_ONCE-and-WRITE_ONCE#it-may-improve-performance
> 
> [...]
> 
> Fixes: cc16921351d8 ("netfilter: conntrack: avoid same-timeout update")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Jozsef Kadlecsik <kadlec@netfilter.org>
> Cc: Florian Westphal <fw@strlen.de>

Applied, thank you. 

Not queuing for stable, please let me know if I should.
