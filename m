Return-Path: <SRS0=bANH=AA=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD9E5C433E0
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jun 2020 14:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88DE02078D
	for <netfilter-devel@archiver.kernel.org>; Fri, 19 Jun 2020 14:29:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=average.org header.i=@average.org header.b="CdnOGIqK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbgFSO3a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 19 Jun 2020 10:29:30 -0400
Received: from dehost.average.org ([88.198.2.197]:49426 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgFSO3a (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 19 Jun 2020 10:29:30 -0400
Received: from wscross.pb.local (unknown [IPv6:2001:1438:4010:2548:9a90:96ff:fea0:e2f])
        by dehost.average.org (Postfix) with ESMTPSA id F2CD8354AD64
        for <netfilter-devel@vger.kernel.org>; Fri, 19 Jun 2020 16:29:28 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1592576969; bh=kVfLv6NonpIs7tLxfBkDBjBOnT9KFxnleql0feDkZr8=;
        h=From:To:Subject:Date:From;
        b=CdnOGIqKr2fbY7FgnRdixfzF7LB1TrrglsgX5+Wc5xg2zvtU5hNfuzhEFjB2gT+Se
         hGovQk39MYJzUHIunkXKBHaV4tL9AQRZWxqUFz2F5Rkqnrpxs91gRMm00SevcXpG8h
         PbxOHgI1NqAv02a51flljyd++kz8yh8jHYH/Nt7o=
From:   Eugene Crosser <crosser@average.org>
To:     netfilter-devel@vger.kernel.org
Subject: Allow dynamic loading of extentions in ebtables (-m option)
Date:   Fri, 19 Jun 2020 16:29:11 +0200
Message-Id: <20200619142912.19390-1-crosser@average.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

`iptables` command allows to dynamically load an "extension" shared
object by specifying the `-m` option, and thus new extensions can be
added without recompiling the command. In contrast, `ebtables` does
not have `-m` option. It still dynamically loads its extensions, but
the list of extenstions is hardcoded.

Proposed patch adds the option `-m` to `ebtables` command that works
the same way as in `iptables`. Note that

1. Hardcoded list of "standard" extentions is _not_ removed by this
 patch. It is not strictly necessary after this patch, but removing
it would break backwards compatibility, mandating addition of
`-m ext-name` option to existing scripts.

2. Dynamic loading of _target_ extensions already works automatically,
no change is needed.

Please consider adding this.

Thank you,

Eugene

