Return-Path: <SRS0=LKiS=YY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB2F3CA9EC3
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 10:45:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 87B8520862
	for <netfilter-devel@archiver.kernel.org>; Thu, 31 Oct 2019 10:45:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727137AbfJaKpx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 31 Oct 2019 06:45:53 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:46936 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbfJaKpx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 31 Oct 2019 06:45:53 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iQ7xe-0002M0-Rj; Thu, 31 Oct 2019 11:45:50 +0100
Date:   Thu, 31 Oct 2019 11:45:50 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Christian =?utf-8?B?R8O2dHRzY2hl?= <cgzones@googlemail.com>
Cc:     netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: nft: secmark output not understood by parser
Message-ID: <20191031104550.GA8531@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Christian =?utf-8?B?R8O2dHRzY2hl?= <cgzones@googlemail.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

Looks like secmark support is broken:

| # nft add table t
| # nft add chain t c
| # nft add secmark t ssh  \"system_u:object_r:ssh_server_packet_t:s0\"
| # nft add rule t c tcp dport 22 meta secmark set ssh
| # nft list ruleset
| table ip t {
| 	secmark ssh {
| 		"system_u:object_r:ssh_server_packet_t:s0"
| 	}
| 
| 	chain c {
| 		tcp dport 22 secmark name "ssh"
| 	}
| }
| # nft list ruleset >/tmp/nft.dump
| # nft -f /tmp/nft.dump
| /tmp/nft.dump:7:16-22: Error: syntax error, unexpected secmark, expecting newline or semicolon
| 		tcp dport 22 secmark name "ssh"
|		             ^^^^^^^

Output should ideally match input or at least be accepted by nft when
fed back. Could you please have a look?

Apart from the above, this should be documented in nft.8 and
libnftables-json.5. Adding a test would help as well, at least in
tests/shell. AFAICT, integration into tests/py might be more work since
this thing does not support anonymous secmark objects, right?

Thanks, Phil
