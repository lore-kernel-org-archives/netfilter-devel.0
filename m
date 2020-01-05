Return-Path: <SRS0=knZt=22=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3003EC33C9A
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 14:57:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 061BD20866
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Jan 2020 14:57:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbgAEO5Z (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Jan 2020 09:57:25 -0500
Received: from rain.florz.de ([185.139.32.146]:56931 "EHLO rain.florz.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726293AbgAEO5Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Jan 2020 09:57:24 -0500
Received: from [2a07:12c0:1c00:43::121] (port=59756 helo=florz.florz.de)
        by rain.florz.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-SHA256:256)
        (Exim 4.92)
        (envelope-from <florz@florz.de>)
        id 1io7LE-0005XA-Vf
        for netfilter-devel@vger.kernel.org; Sun, 05 Jan 2020 15:57:21 +0100
Received: from florz by florz.florz.de with local (Exim 4.92)
        (envelope-from <florz@florz.de>)
        id 1io7LB-0006vD-Jp
        for netfilter-devel@vger.kernel.org; Sun, 05 Jan 2020 15:57:17 +0100
Date:   Sun, 5 Jan 2020 15:57:17 +0100
From:   Florian Zumbiehl <florz@florz.de>
To:     netfilter-devel@vger.kernel.org
Subject: [nftables] bug: rejects empty set literals
Message-ID: <20200105145717.GG3854@florz.florz.de>
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

I guess I found another bug:

| # nft 'table ip t { chain c { ip saddr { }; }; }'
| Error: syntax error, unexpected '}'
| table ip t { chain c { ip saddr { }; }; }
|                                   ^

Now, this does match what the documentation says (you have to have at least
one item in a set literal), but I would think that that also should count
as a bug, as (a) it isn't exactly useful to have arbitrary exceptions on
what (set) values can be specified and (b) nftables handles empty sets just
fine, it's just the input syntax that is complicated.

Regards, Florian
