Return-Path: <SRS0=knZt=22=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB9DC32767
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 00:41:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E1772085B
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 00:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgAEAlZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Jan 2020 19:41:25 -0500
Received: from rain.florz.de ([185.139.32.146]:54129 "EHLO rain.florz.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgAEAlZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Jan 2020 19:41:25 -0500
Received: from [2a07:12c0:1c00:43::121] (port=59252 helo=florz.florz.de)
        by rain.florz.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-SHA256:256)
        (Exim 4.92)
        (envelope-from <florz@florz.de>)
        id 1intys-00048A-FN
        for netfilter-devel@vger.kernel.org; Sun, 05 Jan 2020 01:41:22 +0100
Received: from florz by florz.florz.de with local (Exim 4.92)
        (envelope-from <florz@florz.de>)
        id 1intys-00057F-2X
        for netfilter-devel@vger.kernel.org; Sun, 05 Jan 2020 01:41:22 +0100
Date:   Sun, 5 Jan 2020 01:41:22 +0100
From:   Florian Zumbiehl <florz@florz.de>
To:     netfilter-devel@vger.kernel.org
Subject: [nftables] bug: prefix masks applied to set lookup keys are
 decompiled as a prefix length applied to the set
Message-ID: <20200105004121.GE3854@florz.florz.de>
Mail-Followup-To: netfilter-devel@vger.kernel.org, florz@florz.de
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

I stumbled upon another bug in the Debian buster backports version of nftables:

| # nft 'table ip foobartest { chain c { ip saddr & 0.0.0.0 { 0.0.0.0 }; }; }' 
| # nft list table ip foobartest
| table ip foobartest {
|         chain c {
|                 ip saddr { 0.0.0.0 }/0
|         }
| }

That prefix length suffix after the set both looks a bit strange and
doesn't seem to be valid nft input syntax, so I guess that makes it a bug?

My guess is that the cause is the second case in
relational_binop_postprocess(), which doesn't seem to check for the type of
the right operand?

Regards, Florian
