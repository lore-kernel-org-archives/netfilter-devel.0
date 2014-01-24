From: James Chapman <jchapman@katalix.com>
Subject: nftables: how to parse optional packet header fields?
Date: Fri, 24 Jan 2014 17:24:08 +0000
Message-ID: <52E2A1B8.4060008@katalix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from katalix.com ([82.103.140.233]:47827 "EHLO bert.katalix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbaAXRYM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:24:12 -0500
Received: from [192.168.1.10] (80-229-146-170.plus.com [80.229.146.170])
	(Authenticated sender: james)
	by bert.katalix.com (Postfix) with ESMTPSA id 519F04A7AA
	for <netfilter-devel@vger.kernel.org>; Fri, 24 Jan 2014 17:24:10 +0000 (GMT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'm working on adding L2TP support to nftables. L2TP has some optional
header fields which affect the offset of fields that nftables packet
filters need to match.

One possibility could be to define fixed header structures for all
possible L2TP field offset combinations and have the nft L2TP parser add
rules for all of the possible layout combinations when matching fields
which can be at a variable offset, i.e.

struct l2tpv2_hdr {
    uint16_t flags;
    uint16_t len;       /* present if L bit in flags is set */
    uint16_t tunnel_id;
    uint16_t session_id;
};

struct l2tpv2_nolen_hdr {
    uint16_t flags;
    uint16_t tunnel_id;
    uint16_t session_id;
};

L2TP users don't know or care if the L2TPv2 header includes the length
field, so it would be best not to expose this as a nft rule parameter.
Its presence is determined by a bit in the flags field of the header.

Is there a better way to handle packet header layouts where the field
offsets depend on other field values?

Thanks
James


