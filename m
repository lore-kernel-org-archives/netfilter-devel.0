Return-Path: <SRS0=edwS=ZZ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAB1DC432C0
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 16:07:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8349B2053B
	for <netfilter-devel@archiver.kernel.org>; Tue,  3 Dec 2019 16:07:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=darbyshire-bryant.me.uk header.i=@darbyshire-bryant.me.uk header.b="jrHKe5Kf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726114AbfLCQHw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 3 Dec 2019 11:07:52 -0500
Received: from mail-wm1-f48.google.com ([209.85.128.48]:39801 "EHLO
        mail-wm1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfLCQHw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 3 Dec 2019 11:07:52 -0500
Received: by mail-wm1-f48.google.com with SMTP id s14so4115967wmh.4
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Dec 2019 08:07:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=darbyshire-bryant.me.uk; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jE9G5LUrUEehUhBM3ukrsTythqZyqBqQK60qVTM/Dx4=;
        b=jrHKe5Kf7amaC7rT26sVYVVGtcI3oTa/791cob/8TrLV0r+z6yuPI7qG+XQLn46KTW
         AaUOp2+PGkFXd82r1fT5lpXBLCynxvtV94w23xt56JkhfcDWwt5aHJYeqh1CI0dUvZZw
         H7RWOskQvbeSjsil4kDelbsx5jz6pzTfjM870=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jE9G5LUrUEehUhBM3ukrsTythqZyqBqQK60qVTM/Dx4=;
        b=lXKLdaplW3BLgxudfblk5kgI8kZ/4jQ50b6talPDLZPGOmYR88ybZebzXHb/GK/6pP
         Wff+HyRZSPOndAFQd2YlhnWVpMVT90iPLnspi114hX3szp1OAAAx4T9BiD9Q3x0G3IcV
         lOFut0FFR8CcKlZ9jj5IXo5noaPJtW8QL+o8u8UBlfixPwhZ3CnhTfQcqqqlX1VsUAJE
         bbp8V9Dg60hmZYm5lFs6bYedbBiL8zRmBi6Ms0pW202l12+MDPbn+pW5Oz/yNuG3P+hj
         gbp2UPsrlT+c0xK6PStP7yKeIIjgnSriinfZU9HsBSCXNpU/CTqo0N8XBEHmygUBKNsu
         KqaA==
X-Gm-Message-State: APjAAAVRTfIEnSrZvCRFpYh78v10UdcnRCRiImtVPqIJ2mOldUf7oYam
        tj4MHbFoJBtMvhwyKE2UdxXDoZ+NX/yO4A==
X-Google-Smtp-Source: APXvYqxpQUb1zjGOybYzmmsHNcucfBiyPy20wOvQzpjlL5mN+ZCQu1Ca+LbKAx1DkKTMHXIJLaIGMQ==
X-Received: by 2002:a1c:8086:: with SMTP id b128mr32726493wmd.80.1575389267096;
        Tue, 03 Dec 2019 08:07:47 -0800 (PST)
Received: from Kevins-MBP.lan.darbyshire-bryant.me.uk ([2a02:c7f:1243:8e00::dc83])
        by smtp.gmail.com with ESMTPSA id r6sm4160607wrq.92.2019.12.03.08.07.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Dec 2019 08:07:46 -0800 (PST)
From:   Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     netfilter-devel@vger.kernel.org
Cc:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH 0/1] netfilter: connmark: introduce set-dscpmark
Date:   Tue,  3 Dec 2019 16:06:52 +0000
Message-Id: <20191203160652.44396-1-ldir@darbyshire-bryant.me.uk>
X-Mailer: git-send-email 2.21.0 (Apple Git-122.2)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Greetings.  The following patch is similar to one I submitted as an RFC
quite a while back (April).  Since then I've realised that the option
should have been in the 'set mark' family as opposed to 'save mark'
because 'set' is about setting the ct mark directly, whereas 'save' is
about copying a packet's mark to the ct mark.

Similarly I've been made aware of the revision infrastructure and now
that I understand that a little more have made use of it for this
change.  Hopefully this addresses one of Pablo's concerns.

I've not been able to address the 'I'd like an nftables version'.  Quite
simply it is beyond my knowledge and ability.  I am willing to
contribute financially if someone wishes to step up to the nftables
plate...yes I'd like to see the functionality implemented *that* much.

Kevin Darbyshire-Bryant (1):
  netfilter: connmark: introduce set-dscpmark

 include/uapi/linux/netfilter/xt_connmark.h | 10 ++++
 net/netfilter/xt_connmark.c                | 57 ++++++++++++++++++----
 2 files changed, 58 insertions(+), 9 deletions(-)

-- 
2.21.0 (Apple Git-122.2)

