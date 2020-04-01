Return-Path: <SRS0=ovZY=5R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73803C43331
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 15:48:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46ECF20B1F
	for <netfilter-devel@archiver.kernel.org>; Wed,  1 Apr 2020 15:48:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dIfpPWfN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732925AbgDAPsT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 1 Apr 2020 11:48:19 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44757 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbgDAPsT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Apr 2020 11:48:19 -0400
Received: by mail-ed1-f67.google.com with SMTP id i16so429749edy.11
        for <netfilter-devel@vger.kernel.org>; Wed, 01 Apr 2020 08:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=DFEvvX752a+z0QMIfV2F9J/0ileEyQROzO7m9l7u4Uo=;
        b=dIfpPWfN3BIuoVX3qezpOuBQincCwZXL1ujFbxBNzBW36OO76xOq9lhNhOeER/RFkb
         b0aaM/lqyGcQIpBIjrcM9W9K7395D9q2kKL/pseklriAlz4RHcQcVbdJW+9HFx3OnCwE
         bS/9t8Q7LNgocqh4Wtc09kuxE7RYmGP3twKWIPlWdeSbyxeHpkgkmCpLX4APaEUsSr+b
         NwpfdJPoeDgG8f87fSO6bSA3nyY629SauAztZnqb4ByRRD9ed5E/1AprxL6CP4Sm/N9I
         Z64QBx/xNpSRFFOq0osjueemWuJPf981ITiMkNJ1APmguCnYOSvaDm4wkALPeICfRbBp
         QmNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=DFEvvX752a+z0QMIfV2F9J/0ileEyQROzO7m9l7u4Uo=;
        b=Vh8qBhewsvZauMtIjfpOFU4HxfMpBGYPxC5iMXoCAzc36vOp9+7ZZmPXg0/qiBGP2f
         nCRK5IKnvv9WZ91KYpisvuaw8iuDBy2xNRg0HO+a9DtHTrgS4U1+K4i1CeF4syRxzreB
         BvXAdDYsB7Xe2uTWXyv7w2+u9XW831Ug+6In6bED5LgEvIpZYcHh/Riffhn32C8MU6/4
         zD6PqPOw5nMGQUc0qI9m7/zohzJ3D4uLN/YkANcmuHrOiY8L8c9odohWHibLaHtuhkRf
         M1Pg2e4nJZavZF9d1b3/6lvT8JQ1QWB8qT6WI1KRRZzeiriBO9zPZRap7cS9H3iMsq7w
         2xrQ==
X-Gm-Message-State: ANhLgQ2yi3O5ZmWH6BhZt95wYhQOHJl6LiZmsGraEwkuYky7opS/9GwR
        1zYQdOrYk8rf58kdBpddF+Vqdm11zhA=
X-Google-Smtp-Source: ADFU+vt8zBir9IHNreGyC+9bcDxesyQkHddrJhxRO99QxW50FAm2tFILKM1a4ptpduJcLBJ7fyuh5Q==
X-Received: by 2002:aa7:d2cb:: with SMTP id k11mr21975863edr.128.1585756097375;
        Wed, 01 Apr 2020 08:48:17 -0700 (PDT)
Received: from nevthink ([91.126.71.22])
        by smtp.gmail.com with ESMTPSA id s7sm628107ejx.28.2020.04.01.08.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 08:48:16 -0700 (PDT)
Date:   Wed, 1 Apr 2020 17:48:13 +0200
From:   Laura Garcia Liebana <nevola@gmail.com>
To:     netfilter-devel@vger.kernel.org
Cc:     pablo@netfilter.org
Subject: [PATCH nft] doc: add hashing expressions description
Message-ID: <20200401154813.GA12209@nevthink>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The hashing expressions jhash and symhash are missing in the
nft manual.

Signed-off-by: Laura Garcia Liebana <nevola@gmail.com>
---
 doc/primary-expression.txt | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/doc/primary-expression.txt b/doc/primary-expression.txt
index b5488790..48a7609d 100644
--- a/doc/primary-expression.txt
+++ b/doc/primary-expression.txt
@@ -430,3 +430,32 @@ add rule nat prerouting dnat to numgen inc mod 2 map \
 add rule nat prerouting dnat to numgen random mod 10 map \
         { 0-2 : 192.168.10.100, 3-9 : 192.168.20.200 }
 ------------------------
+
+HASH EXPRESSIONS
+~~~~~~~~~~~~~~~~
+
+[verse]
+*jhash* {*ip saddr* | *ip6 daddr* | *tcp dport* | *udp sport* | *ether saddr*} [*.* ...] *mod* 'NUM' [ *seed* 'NUM' ] [ *offset* 'NUM' ]
+*symhash* *mod* 'NUM' [ *offset* 'NUM' ]
+
+Use a hashing function to generate a number. The functions available are
+*jhash*, known as Jenkins Hash, and *symhash*, for Symmetric Hash. The
+*jhash* requires an expression to determine the parameters of the packet
+header to apply the hashing, concatenations are possible as well. The value
+after *mod* keyword specifies an upper boundary (read: modulus) which is
+not reached by returned numbers. The optional *seed* is used to specify an
+init value used as seed in the hashing function. The optional *offset*
+allows to increment the returned value by a fixed offset.
+
+A typical use-case for *jhash* and *symhash* is load-balancing:
+
+.Using hash expressions
+------------------------
+# load balance based on source ip between 2 ip addresses:
+add rule nat prerouting dnat to jhash ip saddr mod 2 map \
+	{ 0 : 192.168.10.100, 1 : 192.168.20.200 }
+
+# symmetric load balancing between 2 ip addresses:
+add rule nat prerouting dnat to symhash mod 2 map \
+        { 0 : 192.168.10.100, 1 : 192.168.20.200 }
+------------------------
-- 
2.20.1

