Return-Path: <SRS0=hDGH=VH=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE2F0C73C7C
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 10:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67EA62054F
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 Jul 2019 10:06:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="iyEQvdJf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726132AbfGJKGZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 Jul 2019 06:06:25 -0400
Received: from mx1.riseup.net ([198.252.153.129]:43786 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726097AbfGJKGZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 Jul 2019 06:06:25 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 225641A0B2A
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Jul 2019 03:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1562753184; bh=pyjhtAYBb4Zl7TFUwrrZ7BxF5twMOguARQId249whEg=;
        h=From:To:Cc:Subject:Date:From;
        b=iyEQvdJf0ZNk0S7sPR94XJ8XTmOKYdqpKHjKP64SszD84YjsC+ND6e8Vx1kLNvUPX
         5gKTpP7znLRma//MTEMI+wN9Rth8IJO5/3t0XgQFq3KIHmLpzx4ywDGFRoyFuhElJR
         qpa3DbVN3GNl6TBDZYkyuj7O34ddpQTqU8LHmPuk=
X-Riseup-User-ID: 81E7E64B197D006A356D6C18222E9B86B6006BDDC24F7886B9C80BFE5FB2BD34
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 6713B223259;
        Wed, 10 Jul 2019 03:06:22 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 0/2 nf-next] Fix mss value announced to the client
Date:   Wed, 10 Jul 2019 12:05:55 +0200
Message-Id: <20190710100556.25307-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a port of Ibrahim's patch. It includes all the changes requested and it
also fixes the mss value announced in the nftables synproxy module. Maybe it
would be a good idea to squash it so please feel free to do it. :-)

Fernando Fernandez Mancera (2):
  netfilter: synproxy: fix erroneous tcp mss option
  netfilter: synproxy: rename mss synproxy_options field

 include/net/netfilter/nf_conntrack_synproxy.h |  3 ++-
 net/ipv4/netfilter/ipt_SYNPROXY.c             |  2 ++
 net/ipv6/netfilter/ip6t_SYNPROXY.c            |  2 ++
 net/netfilter/nf_synproxy_core.c              | 12 ++++++------
 net/netfilter/nft_synproxy.c                  |  2 ++
 5 files changed, 14 insertions(+), 7 deletions(-)

-- 
2.20.1

