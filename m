Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A8CAC11F66
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 09:47:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE9B161DAB
	for <netfilter-devel@archiver.kernel.org>; Tue, 29 Jun 2021 09:47:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhF2Jtq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 29 Jun 2021 05:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbhF2Jtq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 29 Jun 2021 05:49:46 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C397C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jun 2021 02:47:18 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id yy20so27538667ejb.6
        for <netfilter-devel@vger.kernel.org>; Tue, 29 Jun 2021 02:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=P/SG1Jtqx9NLWmMGQ8rHCeP+E6DhmTO9zl7VQJM6aq0=;
        b=RtSsdRcWEtlaSqA5ey0a329kVCaeGNQ0jGlXOG/z+FwSvF5sqISiwiOImtDez1RJ90
         Jfn7XbDnSXTgZnk/sL5wrxAhey8HtBJV3thbXw3kodDLDGKbbpZg+6949Ohx5Lw7rb2q
         pRYDq5mOYjK9l8YzanHEYWTRLWi+chulTSILsFGSOvy4+Qni/fHux7X7UZ0oXfdNgq6K
         +eTVN2DgA9tuPWBUQ1bpDIqUOGB+nbArY4KnXZbufN4fUQnIxXdLkYJq278GvEzVThq4
         4a56QITMNpYIRgx+fPS4xUvX/qN42ObHq5WffSF39MlGJJbHGJ5F8i7GKrSoxgL1soLv
         J52w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=P/SG1Jtqx9NLWmMGQ8rHCeP+E6DhmTO9zl7VQJM6aq0=;
        b=PQ48Yw5kj3yRYQdi/gKp3r0rUJpvEln734Fii8m/b2ANx0K6VXdKXUjtsf739dtl+t
         t3kr4PWxtbYlyeoDXE5l/lVoadu8aNXexZj3yYt/MhW99rK59gMLgXzpk1gouDqmi0al
         2adyf1eABCaaAX3P6Sp7JSzzAhgsYerK9Qvg0rycx2SCcySoOaml7rrDjRw83WBTTvNX
         e1ikTd9WDeL7J6TtOPzX5KtvdssPnwyY6iGm5KhjOyDZfy599miTL5hC2OzJAckm3WE4
         2iKBHK3K9M84lcOQm8sW+DMmy5ctPPhBaQRh+AeQ+4WkHvYKVs99QdozrvQA4G0XM4Ik
         Jczw==
X-Gm-Message-State: AOAM533v56LyNjgMlGuTqqEiNxexjqMfLv5VhOHMtCZDKTbCIkuxkVoU
        cvyOvEX+FxWynq65Vxxy6iEPmzFxcBBA1kZFfIneHmJygCoTKQ==
X-Google-Smtp-Source: ABdhPJz8wmFAWfu4pzDya4TgWl2r4PDP3VM7IWTQc/Sa1hzif/Dc5usJZk0l8XNKnQS3BCC3N+x74U5tByefoFayRjQ=
X-Received: by 2002:a17:907:d03:: with SMTP id gn3mr29459780ejc.516.1624960037011;
 Tue, 29 Jun 2021 02:47:17 -0700 (PDT)
MIME-Version: 1.0
From:   rakesh goyal <goyal.rakesh@gmail.com>
Date:   Tue, 29 Jun 2021 15:17:05 +0530
Message-ID: <CANaqFbrR_BjWzuJkFwWvsTnTsGufEbMecfjU1dAVyQe5HW8VVA@mail.gmail.com>
Subject: Netfilter rules to replicate, consume ingress packet locally and
 forward clone packet.
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,
I am looking for netfilter rules to accomplish the following requirements.
1. every UDP packet received on the interface i.e. eht0 should be
consumed locally.
 2. replicate same packet and Forward to other interface i.e. enp7s0

experiment done.
1 .Host PC IP 192.168.1.3 which is connected to DUT eth0.
2. DUT  eth0 - 192.168.1.4
         enp7s0  10.40.197.108
3. Another Host which is in 10.40... network having IP 10.40.198.9
connected to     enp7s0 of DUT.

Rules :
sudo iptables -t mangle -A PREROUTING -d 192.168.1.4  -j TEE --gateway
10.40.198.9
sudo iptables -t nat -A OUTPUT -s 192.168.1.3 -j DNAT --to-destination
10.40.198.9
sudo iptables -t mangle -A INPUT -s 192.168.1.3  -j ACCEPT

Issue Seen with this rule:
1. packets from #1 Host PC get cloned until TTL becomes 1/0. So there
are multiple replications.

please help here to understand the correct rules for the requirement.

Regards,
Rakesh
