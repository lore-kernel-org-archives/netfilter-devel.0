Return-Path: <SRS0=0f1v=RX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0CD4C43381
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 10:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29DBA2184D
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Mar 2019 10:30:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tlapnet.cz header.i=@tlapnet.cz header.b="GpuzwmKc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727103AbfCTKaL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Mar 2019 06:30:11 -0400
Received: from mail-yw1-f50.google.com ([209.85.161.50]:35118 "EHLO
        mail-yw1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfCTKaK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Mar 2019 06:30:10 -0400
Received: by mail-yw1-f50.google.com with SMTP id d132so1572225ywa.2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Mar 2019 03:30:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tlapnet.cz; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=JQRP6jmohGsNxyve9cESxTMud6JayCXEgRRd7scg4u0=;
        b=GpuzwmKcp3k1jzQgetf07fCVFxqpls1VS6YIFNnHrTyqYG3Z+QdKp0tLZ+Y8gXdhJT
         /J7x1zGHEmUGY/nKp0XcQmuWpYgDal5HDKCnIA973CtQ4HkzZBdmil14KufrgRee65X2
         X6cdtUtbpjeUF1NWWEzr4cIEPZjONFpfSUrpoYQkTJvEv9A+3SH/6rW3wz4QsIrqpsPq
         cR29K050vZz7sThTwY827dU3iO+gxhOveUfnDP6pc0HqQFP/Ktbcm3nN2YNa2O+WQVrF
         XKYKsa4JmHOd1Sa7LJQ2Z3txv5K2MhA4N+rnQK/2B7AvVJo9fX2dI+MqedKmDyCyjveu
         Yv8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=JQRP6jmohGsNxyve9cESxTMud6JayCXEgRRd7scg4u0=;
        b=pjQ2lb3BwcwJBpG48x3GUkhiPKwhZNVi22I2lg6OY8nPc0W9K4TrpSwCmjEn3jN2Hh
         5AQj6qu/CPmA61wf0FRXQ3S9RDgLUYVpIK/I6Qtzul8H+HYBKKXSb1Cagg1Kp5bJn9wM
         24VPXXSITN5t0GcQhluZ31yhCiMUrprLkNj7pK0JRv3ev/J3a04GgzP9uiDxSWTpZKlN
         yPZ7y7QgJg/VnsHiIQRYE8C/fpWtC93NR7gm8mGvnsvO2Ew1u6HTHDGhtZgYG3di4d2d
         CQQLmYJcwAqwBopBmIqSnR0mLSwQW3/i7RAohIXJS5Px/BDbyZR9eMhxOKCKM8NstQcz
         oJSw==
X-Gm-Message-State: APjAAAXI5QJhvu9O9UkdVtEWr75xZLpay9993tQu9mM7NM5ezctD6+rz
        CboZXhiVUn9Tl4cE9eczz7RZvAUVvqx+A0ce1UilbzAzOviROw==
X-Google-Smtp-Source: APXvYqw4pihtrHY9R8G7p1kUnkVxG/LhqItTkLLMmxUfzMNkKgGY8YWr9y2PUmSxwEOTlGPNeB0yq65YmN03zaaX4mM=
X-Received: by 2002:a0d:cc4d:: with SMTP id o74mr6159176ywd.415.1553077809347;
 Wed, 20 Mar 2019 03:30:09 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?V=C3=A1clav_Zindulka?= <vaclav.zindulka@tlapnet.cz>
Date:   Wed, 20 Mar 2019 11:29:58 +0100
Message-ID: <CANxWus9H+sTaE2Rn=jqc++DqF17EPGKCGDa-TYpoXy1fiMcx1w@mail.gmail.com>
Subject: a2x - unsupported parameter
To:     Netfilter-devel Nftables <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I've noticed a2x being new dependency of nftables. I've installed it
and now I'm getting warnings during doc make. It generates without
problems so it is not real problem.

Making all in doc
make[2]: Entering directory '/usr/local/src/shaperd/extras/nftables/doc'
  GEN      nft.8
  GEN      libnftables.3
  GEN      libnftables-json.5
a2x: WARNING: --destination-dir option is only applicable to HTML based outputs
a2x: WARNING: --destination-dir option is only applicable to HTML based outputs
a2x: WARNING: --destination-dir option is only applicable to HTML based outputs
make[2]: Leaving directory '/usr/local/src/shaperd/extras/nftables/doc'

It is good improvement to have docs built automatically. I remember
some problems a few weeks ago with building it.

Thank you
----
S pozdravem / Best Regards

Vaclav Zindulka
