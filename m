Return-Path: <SRS0=A3Nh=UF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05552C04AB5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 21:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BEC0120B7C
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jun 2019 21:48:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=funio.com header.i=@funio.com header.b="bzLGKUSW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727215AbfFFVsa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jun 2019 17:48:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39101 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfFFVsa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jun 2019 17:48:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so129739wrt.6
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2019 14:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=funio.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1+Kx1mCeFK/NwmXQOQjumuFvK0Kejc+jzL9BXAXAyyI=;
        b=bzLGKUSWzBaQVJ0lxuYO7S6ZqxPZYmVrMi1AjAEk70Be9hIKnf5BrTNoxzKXEjNG7i
         tj20vW3DnvBtV2eulovtMpC74iFxcpETuijVS/QQUmQJm7aoVhrs2jQO0vIvjrtWkfVC
         Fnak1F0P7FCNIxnhREWia3jRUHNxCTEK0Gwn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1+Kx1mCeFK/NwmXQOQjumuFvK0Kejc+jzL9BXAXAyyI=;
        b=goZcKydJ5PLh2+hy6IIL2ANfhaOy4PobpYapFfVp418XeldSGHMtDWhxVX3Pwfqqz+
         90rO7Wsb161EW5DAyAtoRnAGVN1bgeVWbVvYtE1G5qgZcQMkHpoud6OnPPYk9PqjT4JZ
         bkbd2lBrN5vgD9Prl9Ao9ZvOTxgYCnLxSwluZmBdp5nfNjr0LB/KUNKnYw0NAv9ewiU3
         apbgtXq2j4zyl+7bws1FhzdghKoYVLKctxadmKSVdPufF9nom+Zvb9qj13Exaahze7sY
         0pPEjEmrFdASIHGwuPUs9uLH/3v1k2Klff6YJ5Mc0usuVpuKOli383T+OsQCdCMMifyC
         RhoQ==
X-Gm-Message-State: APjAAAUQM+Re+SRtYdDJt7bU4GL6Fs/uI+h6tE2jTSkZxbNPbo6AHWmF
        W3C6fbs7MA/QQMNrep5Ido0y9g==
X-Google-Smtp-Source: APXvYqwci/yC+F8EX5NmH+JEGbPK19PtjO20CU8sUxj4c+fkytSPUdyGRfW9gi840LvBhjqceSh6Dw==
X-Received: by 2002:a5d:5607:: with SMTP id l7mr28102660wrv.228.1559857709142;
        Thu, 06 Jun 2019 14:48:29 -0700 (PDT)
Received: from macfun.corp.internap.com ([72.55.158.120])
        by smtp.gmail.com with ESMTPSA id u25sm133714wmc.3.2019.06.06.14.48.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 14:48:28 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.5 \(3445.9.1\))
Subject: Re: How to use concatenation ipv4_addr . inet_proto . inet_service
From:   Vladimir Khailenko <vkhailenko@funio.com>
In-Reply-To: <20190606205627.uw7i62z5hgaupkyn@breakpoint.cc>
Date:   Thu, 6 Jun 2019 17:48:26 -0400
Cc:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <04A425C2-3BAA-48E3-B7C2-CAC8E943CB22@funio.com>
References: <33D76666-7E5E-47A3-BBCB-F4FB29BA2311@funio.com>
 <20190606205627.uw7i62z5hgaupkyn@breakpoint.cc>
To:     Florian Westphal <fw@strlen.de>
X-Mailer: Apple Mail (2.3445.9.1)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Yes, when I wrote "It works" - it means "no error has been throwed".

Perhaps, it would be better to implement something like "... ip daddr . =
ip protocol . protocol dport @xyz ..."

As workaround we can use (in most cases it is the preferable way):
"... ip daddr . tcp dport @xyz_tcp ..."
"... ip daddr . udp dport @xyz_udp ..."

But because DNS has TCP extension for big answers - we should repeat =
same rules ("1.2.3.4 . 53") in both sets.

It is really funny: you can create a set with concatenated =
ip:proto:port, but you can not use it :)

Vladimir Khailenko

