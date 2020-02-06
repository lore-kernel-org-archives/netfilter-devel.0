Return-Path: <SRS0=cCuT=32=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 464AEC2D0B1
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 11:19:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15F73206CC
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Feb 2020 11:19:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QgXX2MOc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727705AbgBFLTP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Feb 2020 06:19:15 -0500
Received: from mail-il1-f179.google.com ([209.85.166.179]:34822 "EHLO
        mail-il1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727607AbgBFLTP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Feb 2020 06:19:15 -0500
Received: by mail-il1-f179.google.com with SMTP id g12so4768541ild.2
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Feb 2020 03:19:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=pz8JlyTI0TQW+4nWjPastDNVI5T0/SftBU/RlKuIxmQ=;
        b=QgXX2MOcL85PcKdIZFJZVW5ASAfwmJ24gfW72+XRML8SBP1BbSsoVoelhqRjJ/nPD1
         Mevsscgi8B9d+MGXkTsaFdFKRKu7GV8lBhIwbF1MVP3BAi1B7G+xVJtYPvVBhM1qwruz
         z+09aqsP5pfSh/Xwt+2MOgr94+rcAdPNW2HOI0BXQri4ZffwlZrpTUTEnIRjv+5t/F/y
         2MIWjLh7qw6M8C7bi/5JSlClg6hMpo/NvgTEtBnGDj7JvpckR3E6eRx9WHAE7mN5Um7X
         IPxlfxvX1CeaWHI+gmuWlCZ0cPOat4/COMyMQBQGwAg6JhYEdnf/3YaRjt60lLpCwOC2
         Zngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pz8JlyTI0TQW+4nWjPastDNVI5T0/SftBU/RlKuIxmQ=;
        b=UTgY2oeMRlUjIX2nOQvbnbfp2hSjKQFAkKptXg3Pl/BGCfLsb6VvK8+1PbJR/OvMTX
         XeCBe1sh3vUAgU24RUoj230gvgy9/GVtQbGTm52BCRuW0LtX7C/50kmc9j9bllKfyCwH
         A0pGCheW3xCTkdfmR+BGsZC5vg3b9eWkeaIDGleikHdHLrkNmRE5YQSEbT2zFlaVaSEP
         Ncx9dsJr9hSRWDFm/YNW3dFFMssY81Y2uU+8UTNN3uTV4XB/YfWJ4NnwJNjyBscEl0yz
         0NUTb14/K+Iwdu9aFG2WRCB0mXbHXIXcf75w6saYec2VIPvWR8D6r7nqU3x2oc1PMzlU
         3nLg==
X-Gm-Message-State: APjAAAWFCEtKfUMfOCZnIBtKffh/iXvQaKBTNj4o+8mPLDqTrRKMYl4F
        YXFEy3+36CWY2b/OBAqVbpWQVTSF8bTqgjEnypqgcCjBhiM=
X-Google-Smtp-Source: APXvYqzTFG6qSoO5Su318dhyYonxGmwcsRtJIw0NJl/W6RyWKcZbB4KYXfbqigOUzaoRDZNwZMVvH9Lwb16zlJVP3Sc=
X-Received: by 2002:a92:50f:: with SMTP id q15mr3362831ile.47.1580987954377;
 Thu, 06 Feb 2020 03:19:14 -0800 (PST)
MIME-Version: 1.0
From:   jean-christophe manciot <actionmystique@gmail.com>
Date:   Thu, 6 Feb 2020 12:19:03 +0100
Message-ID: <CAKcFC3a_dpZEPUnyH_MNUrSpj+aeh=kT=QMV49-jrJMF6qRSWg@mail.gmail.com>
Subject: How to continue to use Maxmind geoip csv in xtables-addons 3.8+
To:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I have realized by digging within xt_geoip_build that the expected
geoip provider has been changed from Maxmind to db-ip since 3.8-1
(debian sid).

This means that running xt_geoip_build with csv downloaded from
Maxmind can no longer work.

I am aware that Maxmind recently introduced "Significant Changes to
Accessing and Using GeoLite2 Databases" and introduced a new end-user
license agreement.

However, is there a way to continue to use Maxmind geoip db with
latest debian xtables-addons for people who detain the required
license key in order to download GeoLite2 databases?

-- 
Jean-Christophe
