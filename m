Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1E51C77B7A
	for <netfilter-devel@archiver.kernel.org>; Wed,  7 Jun 2023 06:22:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234983AbjFGGWE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 7 Jun 2023 02:22:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232580AbjFGGWD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2023 02:22:03 -0400
X-Greylist: delayed 509 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 06 Jun 2023 23:21:58 PDT
Received: from smtp-out.freemail.hu (fmfe39.freemail.hu [46.107.16.244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2FDF11F
        for <netfilter-devel@vger.kernel.org>; Tue,  6 Jun 2023 23:21:58 -0700 (PDT)
Received: from FX4320 (catv-176-63-76-57.catv.fixed.vodafone.hu [176.63.76.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp.freemail.hu (Postfix) with ESMTPSA id 4QbcTQ40DNzLHS
        for <netfilter-devel@vger.kernel.org>; Wed,  7 Jun 2023 08:12:58 +0200 (CEST)
From:   =?iso-8859-2?Q?Ol=E1h_Ambrus_S=E1ndor?= <aolah76@freemail.hu>
To:     <netfilter-devel@vger.kernel.org>
Subject: xtables-addons passes through an IP from RU
Date:   Wed, 7 Jun 2023 08:12:58 +0200
Message-ID: <000001d99907$1c266780$54733680$@freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AdmZBJs9DbOHMqtcQBSOrFo+VPy4Kw==
Content-Language: hu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=simple/relaxed; t=1686118379;
        s=20181004; d=freemail.hu;
        h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding;
        l=1132; bh=CgAH9r2s3QisswPt9YGWb/zpoLOGNBQzxd7jBM43ET0=;
        b=LcFg/zcl8vGSSfHwHCiVMKtnKWDcYooYoqm2JtY1Gin/wOfXHxKq4n/1CWQH/fjy
        O1JrPEqgf5QGjzU7z6fdm+Sp6pJmmplxeSNNdeDws/3LbEoOa67ZszqbOj1HcCu6Jvx
        qGOpKBY+qSpscnIRS8faKYfo0GF59oz75DiyWN3eObaV3a7615vonfa0DixsGRNgFPB
        EzRSyptY8XNiUJztJR5i40tSbv5It9sMaTCFqa5El0IwCNS8uyxEwWJtoQ2GqPgsblw
        4/Z+D7LaFRNmxTjwo1lGCS4UvEbroeZsZXSaUtRKU9VFfMyCsbgB1erChu5szcOuf+M
        Z9YcVS3u+w==
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello netfilter developers,

	I would like to report a possible problem. I have discovered access
attempts from IP address: 83.97.73.89 in my nginx access.log. I have
configured nginx with maxmind mmdb databases, so nginx identifies it as
coming from RU, Russion Federation.
=09
	I have applied the following iptables rule: -A INPUT -i eth0 -m
geoip ! --source-country DE,GB,HU,RO  -j DROP
=09
	I am running debian bullseye. Output of uname -a:
=09
	Linux myhostname 5.10.0-10-686-pae #1 SMP Debian 5.10.84-1
(2021-12-08) i686 GNU/Linux
=09
	I have installed the following stock debian packages:
=09
	xtables-addons-common:i386/stable 3.13-1+deb11u1 uptodate
	xtables-addons-dkms:all/stable 3.13-1+deb11u1 uptodate
      =09
	I am downloading weekly the maxmind geolite2 databases in both mmdb
and csv formats. The csv file contains related IP range of  RU. I am
generating the .iv4 and iv6 files with xt_geoip_build_maxmind script
installed by the above mentioned xtables-addons packages.
     =20
	Could someone support me to investigate this problem? Thank's in
advance!
      =09
	Ambrus Ol=E1h
	Budapest, Hungary


