Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11D9CC76188
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 09:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B79DA20651
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 09:08:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="UuaPaJUT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfGPJI2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 05:08:28 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50144 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727105AbfGPJI2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 05:08:28 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 88E601A0EEF
        for <netfilter-devel@vger.kernel.org>; Tue, 16 Jul 2019 02:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563268107; bh=zBF+GBJYAyhNHGTdBdSk5XHT67Fg802bzPlp1DwVJzU=;
        h=From:To:Cc:Subject:Date:From;
        b=UuaPaJUT+glVEyAj5JglxvYjcwn++eQ90yblaJXNpUVUClLxs8CoAkl2IJAkIQn4G
         tvEv8g0zr9ZzW2i7zDpIezUqx9byeTqqGQx3gFT8E2dDh8zs21MkOUGfMn8ynVTmpQ
         qyaQNsfMdFaEvxfTXHZF4B4r5CNiLy3Xjqpj96E4=
X-Riseup-User-ID: 790BEED6F58501AF70161B593F6341DE25B5BE68723A95C1841C7C90878CAE4E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 5B8F51201ED;
        Tue, 16 Jul 2019 02:08:24 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 0/2 nft WIP] Using variables in chain priority
Date:   Tue, 16 Jul 2019 11:08:10 +0200
Message-Id: <20190716090812.873-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

I am getting the following error when I try to load the following file using "nft -f"

File:
define pri = filter
table inet global {
    chain prerouting {
        type filter hook prerouting priority $pri
        policy accept
    }
}


Error:
priority_test:1:14-19: Error: No symbol type information
define pri = filter
             ^^^^^^
priority_test:4:37-49: Error: invalid priority expression symbol in this context.
        type filter hook prerouting priority $pri
                                    ^^^^^^^^^^^^^

The original idea was to evaluate the prio_expr and check the result expression
datatype. This way we could use variables with number priority number and also
strings. It seems that the symbol does not have symbol type information at the
evaluation phase. I have a workaround that consist in allocating a constant
expression with the symbol identifier in the parser but then we should check
the datatype manually in the evaluation. I don't like that solution at all.

Is there any other way to accomplish that? I would like to find a better
solution. Thanks!

Fernando Fernandez Mancera (2):
  src: introduce prio_expr in chain priority
  src: allow variables in chain priority

 include/rule.h     |  8 ++++----
 src/evaluate.c     | 29 +++++++++++++++++++----------
 src/parser_bison.y | 26 ++++++++++++++++++--------
 src/rule.c         |  4 ++--
 4 files changed, 43 insertions(+), 24 deletions(-)

-- 
2.20.1

