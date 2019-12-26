Return-Path: <SRS0=nsnV=2Q=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F06C2D0C8
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 03:05:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C0F207FF
	for <netfilter-devel@archiver.kernel.org>; Thu, 26 Dec 2019 03:05:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lmFcDDBZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726995AbfLZDFr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Dec 2019 22:05:47 -0500
Received: from mail-ed1-f48.google.com ([209.85.208.48]:36205 "EHLO
        mail-ed1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726903AbfLZDFr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Dec 2019 22:05:47 -0500
Received: by mail-ed1-f48.google.com with SMTP id j17so21468108edp.3;
        Wed, 25 Dec 2019 19:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=j6vQieOj30ZsdktwZCgehiukeP99fsS6BnJ4QLRdT5s=;
        b=lmFcDDBZT9QZOp9sA93YVsAjP6ByKbEMqKSJ1AUQPtt2nJe9tLfM1ynFAmF/bxUiaa
         7N9iu1y4BuNAeq3dzCYlwhCqQEs7g+7Nx15yf3OiYHcjUcUkDxoeiR4AAqCQ0dFrhwm4
         5eWDLliiysD44hWtiPLHL2nH59LtB5EuJBtqEENRWWW74SemaGzRTf6cjPJMTT56LQWB
         epFxnWtFDTn+VhnNgnA66GwIevr0by9LcSHqhz7OdghWfqTW+OUXHSb6IYd1uiIRUyHR
         m8BBwjzTfMRfuqaNhG9Wn+CxMStsn/sfcloHZJ6yqGT8J0ajKUqKbcfP9MRezkryjoas
         kt9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=j6vQieOj30ZsdktwZCgehiukeP99fsS6BnJ4QLRdT5s=;
        b=MQPcrehFucx2NpJEx6yDvhuXCesdUpUghrFoflq+LEyTP3GUNWJ7/+UUFFwCraKy6V
         anXExRPCIV85+VaQZ9q7VUVKSFhUxkwtiqK168RL7b7kK5l7tcFmcUEdHE9zi71kdqlj
         pcD+iAMlj2L53VWjZZ3KhNifEPSSs2sce13G2Sd3hz3RDVg6MkSmLaozYRlC8RJnBS+9
         8LhHVk/eNbpBABHrD6EITvhl8YJn2DRwdjsMTNdNTbVJBdBb4ohB4l84CTF8fe57WOIO
         G90g8TtWLaDrkNIH+ErLyhlB7j57QYuhtTe9w3GrFFsWFt99MwI+i/QL69GjChiD3gfu
         KdHw==
X-Gm-Message-State: APjAAAXM/Rsb3bCOhHzPdQEIH0499mDdxXmJ1s5ISIDEymz/TS3o6ZK+
        X/CwvB2M+cqASLaxOwJZyvMESSfHja94c214OoELMdAa
X-Google-Smtp-Source: APXvYqzfeBmJTMtTo2bhjqYTQNVJkyHtjKv+40FLlUSBzkb89e7aHaPs7yXzVRD+lvXcVxlyXAwTZWkLQk9/PmSIulY=
X-Received: by 2002:a17:906:4dc1:: with SMTP id f1mr47065348ejw.105.1577329544573;
 Wed, 25 Dec 2019 19:05:44 -0800 (PST)
MIME-Version: 1.0
From:   Tom Yan <tom.ty89@gmail.com>
Date:   Thu, 26 Dec 2019 11:05:33 +0800
Message-ID: <CAGnHSEkvf0zieVJtPyneZ6PfnzeANmfFxTb=0JpgVb1FXVk0-w@mail.gmail.com>
Subject: Weird/High CPU usage caused by LOG target
To:     netfilter-devel@vger.kernel.org
Cc:     netfilter@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi all,

So I was trying to log all traffics in the FORWARD chain with the LOG
target in iptables (while I say all, it's just some VPN server/client
that is used by only me, and the tests were just opening some
website).

I notice that the logging causes high CPU usage (so it goes up only
when there are traffics). In (h)top, the usage shows up as openvpn's
if the forwarding involves their tuns. Say I am forwarding from one
tun to another, each of the openvpn instance will max out one core on
my raspberry pi 3 b+. (And that actually slows the whole system down,
like ssh/bash responsiveness, and stalls the traffic flow.) If I do
not log, or log with the NFLOG target instead, their CPU usage will be
less than 1%.

Interestingly, the problem seems to be way less obvious if I am using
it on higher end devices (like my Haswell PC, or even a raspberry pi
4). There are still "spikes" as well, but it won't make me "notice"
the problem, at least not when I am just doing some trivial web
browsing.

Let me know how I can further help debugging, if any of you are
interested in fixing this.

Regards,
Tom
