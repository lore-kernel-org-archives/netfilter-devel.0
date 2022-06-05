Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E639DC43334
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jun 2022 19:43:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237899AbiFETnw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jun 2022 15:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbiFETnv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jun 2022 15:43:51 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDFEF17043
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Jun 2022 12:43:49 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id e11so11170490pfj.5
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Jun 2022 12:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=scottdw2-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=W4VeMa0Zos14TPlaDO2JItiAP9LPIsQcURvu//dXRlg=;
        b=BYeLE+SXluk7j6tlBhicnYmkvyXurbq2qb8lnl98ET2R818Z4MVLxzn4RsJUfSHz57
         k+nZ2NwYwpBvpwZuAncuAoKI6SgRYJ9cdqcK3DlMNeayPOtNMYOAuIGuCgKHNm0I7Trn
         GmQMWj2XMpZz3V494juMz/165HPTOk0n83QQ0036f4sS1e43CrW4v20yw+EFHV2PGzwt
         Hx2RLKQb7qVScUB8vY2H1CrRrY8TUbbg9LyupYei2MoqO0USv4WLNm4+tCQG0dOqEQl8
         IUqO0dw5MJg+GjwPHQngTqX38tNH7QUvgZ9uUJrR4C1Ay5mFxLW4VQO+DJ5Z6ufZapbI
         7SWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=W4VeMa0Zos14TPlaDO2JItiAP9LPIsQcURvu//dXRlg=;
        b=ZL0rvNonRe1JN+fqm3Pndj75oTD6IuAF4YV39iXvPn/raYBq/ijZ/Ux3nUUktSKJC5
         xhtdYOVK925a/0juE9RcEBjzqTUow1lT5yEqGpj/D/sX0cRpmKEMAIeleoH6kFVuBz/r
         JrC/SFAEF3K8Y2JRJHm6p5ScdjCM+0YSSLw0I/aZpi9UHsswWQIYpRzLOuSJyoEHPW11
         0sT/isfRm9PqFTP6K0TS9ElokpyUrepDeuheZXIDqnP7PK1uMvVzyuA1AL0yHm00z6KK
         dK7YLXObGRMxGN2FxqgERwThVzQamH85L12jKG0c7v90l0ADGCqBlFX81Cltae+6Vm02
         mpxg==
X-Gm-Message-State: AOAM533ZS61UbgbiYrxrGy2wrI6IWE8TKcJuE9LUYR523xmv02PHF6AS
        VP9Ip2i38zHRIE8rkyJptHv3SbryoB+08jVNVe0Ipxm5bA2MIw==
X-Google-Smtp-Source: ABdhPJzh4nwnszr1neAnVLvbU68I9J8WpVOViFrmXO7PCIknEyIUgs60aGWmRG5chQuYfBWxi8mGnG+V2tiDwtz0n5Q=
X-Received: by 2002:a05:6a00:cca:b0:51b:ed40:b08a with SMTP id
 b10-20020a056a000cca00b0051bed40b08amr11098788pfv.19.1654458229047; Sun, 05
 Jun 2022 12:43:49 -0700 (PDT)
MIME-Version: 1.0
From:   Scott Wisniewski <scott@scottdw2.com>
Date:   Sun, 5 Jun 2022 12:43:37 -0700
Message-ID: <CAO=7uoa2_4+soqK+9k+BJ4AjCbL3T7xQxNtKZ_VgRYi3ZpXb8Q@mail.gmail.com>
Subject: Expired Cert
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Just a quick heads up, it looks like the cert used by

bugzilla.netfilter.org
and
people.netfilter.org

Expired back on 6/3. You might want to rotate the cert.

-Scott
