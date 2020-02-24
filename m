Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E9B6C35677
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:03:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 479502071C
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 00:03:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgBXADe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Feb 2020 19:03:34 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:46000 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726534AbgBXADe (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Feb 2020 19:03:34 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1j61Df-0004l7-80; Mon, 24 Feb 2020 01:03:31 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     nevola@gmail.com
Subject: [PATCH nft 0/6] allow s/dnat to map to both addr and port
Date:   Mon, 24 Feb 2020 01:03:18 +0100
Message-Id: <20200224000324.9333-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Right now its not possible to use a map with snat/dnat to alter both
address and port at the same time.

This series teaches nft to accept this:

	map y4 {
		type ipv4_addr : ipv4_addr . inet_service
		elements = { 192.168.7.2 : 10.1.1.1 . 4242 }
	}
 	meta l4proto tcp meta nfproto ipv4 dnat ip to ip saddr map @y4

i.e., it allows:
1. A mapping that contains a concatenated expression.
2. nat expression will peek into set type and detect when
   the mapping is of 'addr + port' type.
   Linearization will compute the register that contains the port
   part of the mapping.
3. Delinarization will figure out when this trick was used by looking
   at the length of the mapping: 64 == ipv4addr+service, 160 == ipv6addr+service.

What does not work:
Anonymous mappings, i.e.
meta l4proto tcp meta nfproto ipv4 dnat ip to ip saddr map { 1.2.3.4 : 1.2.3.5 . 53, ..

doesn't work.  When evaluating "1.2.3.4", this is still a symbol and
unlike with named sets, nft doesn't have a properly declared set type.

This is similar to the 'maps-on-LHS-side' issue.
Phil suggested to allow this:
 ...  to ip saddr map { type ipv4_addr : ipv4_addr . inet_service; 1.2.3.4 : 1.2.3.5 . 53, ..

i.e. re-use the declarative syntax from map code.

Another related issue:
"typeof" doesn't work with concatenations so far.

I don't know when I will have time to look into this more.
I have incomplete patches for concat typeof (udata) support
and a patch to extend the grammar for the proposed { type ... in
anon sets (doesn't cause grammar problems).

I will continue to work on it but don't know yet when I will do so, so
I am sending the finished patches I have at this time.


