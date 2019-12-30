Return-Path: <SRS0=r9U9=2U=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9875BC2D0C3
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 21:19:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FC66206DB
	for <netfilter-devel@archiver.kernel.org>; Mon, 30 Dec 2019 21:19:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="l5//uJbc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbfL3VT3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 30 Dec 2019 16:19:29 -0500
Received: from mx1.riseup.net ([198.252.153.129]:48756 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727691AbfL3VT3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 30 Dec 2019 16:19:29 -0500
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 47mr0c6XLYzDsNq
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 13:19:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1577740768; bh=v3i5VjJROkvzM9UMa+r5CUIBMR7cYI4sUoKGFSzQYi8=;
        h=From:To:Subject:Date:From;
        b=l5//uJbcr9vuegfNSYbvzMm4q1JmXaZdf2w1sTGnYq0a3236bYdS6kcUD8ISs56AA
         T+qTqgdWoH2ro8GA+Hi6p67Bm2d6lYUx3gEfa4NPiAfh2Vx8dijVW7PokwD30pYPwu
         p7c3yLje2KA75LuNheTAndBM+CTFohJeTcAiXoxw=
X-Riseup-User-ID: 211ADD6C34A7E41F71264FC598550F503368ECE476EBBBE0E654BB148E82CB11
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 47mr0c2DZnzJr1q
        for <netfilter-devel@vger.kernel.org>; Mon, 30 Dec 2019 13:19:28 -0800 (PST)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nftables geoip 0/1] contrib: geoip: add geoip python script
Date:   Mon, 30 Dec 2019 22:19:02 +0100
Message-Id: <cover.1577738918.git.guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds a python script which generates .nft files that
contains mappings between the IP address and its geolocation.

It requires two csv files:

1) location database, this is stored in the location.csv file. This
   is currently a modified version of

https://github.com/lukes/ISO-3166-Countries-with-Regional-Codes/blob/master/all/all.csv

   You can specify the location database path via the --file-location

2) geoip database. Provided by db-ip.com. This csv file can be downloaded
   with the --download option.
   You can also specify the file through --file-address

This script generates the following output files:

    geoip-def-*.nft: contains definitions for countries of a continent to its
    2-digit iso-3166 code

    geoip-ipv{4/6}.nft: contains maps for ip blocks mapped to the 2-digit
    iso-3166 value of the country.


Output directory can be specified with '-o' option. It must be an
existing directory.

Example, a counter of input packets from Spanish addresses, (there is a
folder named "test-geoip" in the current directory):

./nft_geoip.py -o test-geoip/ --file-location location.csv --download

Then you can include the country definitions "geoip-def-all.nft" and geoip
"geoip-ipv{4,6}.nft".

table filter {
    include "./geoip-def-all.nft"
    include "./geoip-ipv4.nft"
    include "./geoip-ipv6.nft"

    chain input {
	    type filter hook input priority filter; policy accept;
	    meta mark set ip saddr map @geoip4
	    meta mark $ES counter
    }

}

Jose M. Guisado Gomez (1):
  contrib: geoip: add geoip python script

 contrib/geoip/location.csv | 251 ++++++++++++++++++++++++++++++
 contrib/geoip/nft_geoip.py | 310 +++++++++++++++++++++++++++++++++++++
 2 files changed, 561 insertions(+)
 create mode 100644 contrib/geoip/location.csv
 create mode 100755 contrib/geoip/nft_geoip.py

-- 
2.23.0

