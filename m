Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1347C05027
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Jan 2023 10:37:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjATKhf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Jan 2023 05:37:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbjATKhb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Jan 2023 05:37:31 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C83AD11
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2023 02:37:31 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qx13so12740819ejb.13
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Jan 2023 02:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QJYeM6PLddYmq1plDtOg0WH4VVExuwloJYSBZft/JyU=;
        b=CCcsVrC75vpb3ehhh7HuVYTfRtVfjyOBLezx2u0jXTGDNrlIH8sgodoPv19BW41ldH
         HMce0L4HJ1clqH/WiPJZhmeico8a2SEKNiAK0tt0YFyM/UNQBDvhAvlyMPWht3xg6uYe
         /unSc367Nhj3ZchSc13SeNk7KFkRplUuRFZolg1cv+WonDF9NOYBtNsXM9uKMLaCM1Fp
         7mE33qj0XkQOcLREpHNUOuDSsXwzHz1iX++TfHbtRZicoSr/EsWvnrFXXxgGxts+fueS
         B2iPzN3QBgUBHJo0c1NCmBED1IE5kQIaWiY02warGJUh4YL2M/grkpPcsUi1BrVv0cwf
         u4eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QJYeM6PLddYmq1plDtOg0WH4VVExuwloJYSBZft/JyU=;
        b=bjx9bu1x4JglmW01wynAWsla40ZBqN1H3tJReJ+RKeta+SuvELL/VdLf5iK5SH9+LS
         /QGYslnRZElEWfKX3vN6H13c2TdY2xjGxYrwGK2pSKQyH83/CodoQmqz/+UTfjJYYxzh
         WUvpEIEvL1bSKSlq5+3+FWhd9u6YQlUcmvv7Jr1iU7+/woBIbzL+NdI8HDtADKaQIqjc
         IQ+ZSMdTrLAUlinTiA2HoJwpZMPdlm2hlSv2tMxO16Yki9gYO5e3TQ+zvQndUZSv0A7c
         kBivIeqb6VTsYPz0tRpxLkyCfaRdgTBlaT4Edd6T7ZWQghg9g7YcwgTJhAByqY5Rp8tQ
         SzTA==
X-Gm-Message-State: AFqh2ko0jNmsQxLfzNkw07sYssde8QDDL2CQCPAxOJ9Aibbn/4mzfDMN
        VI2nYq2GWQAq88zm9Q1YkJ4IMb0ifjtGMnQPnGeQZbViCSQaew==
X-Google-Smtp-Source: AMrXdXuodbvmUhguXx0OwXsgIkO+WX0LyLw9LcrmHJk+vOvTWPFy/Iulru6OGmrdEwTKmvin9iR/XzoUbs3s//k1HiU=
X-Received: by 2002:a17:906:14c1:b0:7c0:b3a8:a5f9 with SMTP id
 y1-20020a17090614c100b007c0b3a8a5f9mr972437ejc.154.1674211049285; Fri, 20 Jan
 2023 02:37:29 -0800 (PST)
MIME-Version: 1.0
From:   Armen Hovhannisyan <harmen.crd@gmail.com>
Date:   Fri, 20 Jan 2023 14:37:18 +0400
Message-ID: <CAJvn+xT2NS_a2KmQixfQ07An+UAyioSqF_yk9TO0f6K6Cuiz=A@mail.gmail.com>
Subject: Stateless load-balancer
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Dear nftables team,

I am trying to configure a stateless load-balancer but having problems
with defining different destination ports for different backends, I
would be grateful if you could help me with the configuration.
Nftables documentation states the following command for stateless
load-balancing:

nft add rule t c tcp dport 80 ip daddr set numgen inc mod 2 map { 0 :
192.168.1.100, 1 : 192.168.1.101 }

However this will forward to both backends on port 80, what I want to
achieve is to receive on port 80, but to forward to port 8081 for one
backend and 8082 for other backend and can't get the correct
configuration for stateless forwarding.

Many thanks in advance for your time.

Kind Regards` Armen
