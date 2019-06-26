Return-Path: <SRS0=TDc5=UZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E982FC48BD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 11:07:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4DDE20656
	for <netfilter-devel@archiver.kernel.org>; Wed, 26 Jun 2019 11:07:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Xhnj6sHv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbfFZLHF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 26 Jun 2019 07:07:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44899 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbfFZLHF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Jun 2019 07:07:05 -0400
Received: by mail-wr1-f66.google.com with SMTP id r16so2206435wrl.11;
        Wed, 26 Jun 2019 04:07:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=m90tKDbIoQ6CgI7EuX/tJe0WMVlu0RpWKVwGqLrxzg0=;
        b=Xhnj6sHva5UgsbQUfTH3AGwsXB5sHyc7flB/orpM2Uc3SBKpX8A12ny3WjMpvVTWaP
         iWkR61qaItmgLRydDB1KtD7ELxeoxlagk8C/+ouGutlJLkEpn9r7yj9JJSDAioDARr3N
         zxQAOWJSL0V8zU6saDbOHBUG1vsMS4q0tK2JF0ta+hgF9QTq4MMO4a+qKlhekU7W0JNw
         s94teqE5PKmGLMTXb7T5+LxJW9+KEETa6ViEuQFLYJW4WBqYZ7mBDUmPJQPTpH7BJeyQ
         RI/Hmr9Z0VxpIl7lS3lknTKMqW3F98sF3PeK7KYbhDUF73mBKF0Rrmyh1/eRkoS3T7Mo
         DlGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=m90tKDbIoQ6CgI7EuX/tJe0WMVlu0RpWKVwGqLrxzg0=;
        b=Qx01WFUv4LBCLsHNCRzbmaFVNyNGYlUhKAc8q23l9sod9XqoNdXf0f8OPKuYlP35C0
         aR3ujteuKLi09OOgkIHQX/RCC1cRwh6EJyFPOvakAp64At0sVDPTLbH7q98+AY/Q7tEo
         PA5alhJemuvsfif6tIDY2HjdIl2DjkKgO4ybRd3inQDyTCqd9Tff2U3bDKR/szt+JvlB
         THK5MWKsgBjQdKjqACow9PDHz5eEncxo8FKBExg/0xbvvZRcpWMU4pMVTbJKsNXP2uDN
         Gr5ZsZi0oy8W54QlLdL7YrHQpXqb9cY6FT9XZLuZbBsL6KbwTtzHXA+jLrmUGbGayQkJ
         zDjg==
X-Gm-Message-State: APjAAAVunh2ivLdpBd+3a9m8C1S5pmJjZ9P8NSgh0jyZnjYGvMXki/C9
        eI12xDykyhrUR4Jghv0VOQv3Vp1t/yWbLRl8EJmz0L0z
X-Google-Smtp-Source: APXvYqyTQNDusmVKdMMUQCnFWE9y3N0o32CPXogs3sJSXm2xup3rhUscuMYwuHM8Mb1prmVQc7cmQCFcQuU6DjdyheY=
X-Received: by 2002:a5d:63cb:: with SMTP id c11mr3263377wrw.65.1561547222059;
 Wed, 26 Jun 2019 04:07:02 -0700 (PDT)
MIME-Version: 1.0
From:   Naruto Nguyen <narutonguyen2018@gmail.com>
Date:   Wed, 26 Jun 2019 18:06:45 +0700
Message-ID: <CANpxKHHXzrEpJPSj3x83+WE23G1W0KPz9XbG=fCVzS21+-BpfQ@mail.gmail.com>
Subject: Question about nf_conntrack_proto for IPsec
To:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi everyone,

In linux/latest/source/net/netfilter/ folder, I only see we have
nf_conntrack_proto_tcp.c, nf_conntrack_proto_udp.c and some other
conntrack implementations for other protocols but I do not see
nf_conntrack_proto for IPsec, so does it mean connection tracking
cannot track ESP or AH protocol as a connection. I mean when I use
"conntrack -L" command, I will not see ESP or AH  connection is saved
in conntrack list. Could you please help me to understand if conntrack
supports that and any reasons if it does not support?

Thanks a lot,
Brs,
Naruto
