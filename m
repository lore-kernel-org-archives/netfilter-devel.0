Return-Path: <SRS0=DSQd=3Y=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A289BC35247
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 02:00:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7943520732
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Feb 2020 02:00:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgBDCAS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 21:00:18 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42693 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726992AbgBDCAS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 21:00:18 -0500
Received: from dimstar.local.net (n175-34-107-236.sun1.vic.optusnet.com.au [175.34.107.236])
        by mail104.syd.optusnet.com.au (Postfix) with SMTP id 0B7AD43FFE1
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Feb 2020 13:00:04 +1100 (AEDT)
Received: (qmail 6520 invoked by uid 501); 4 Feb 2020 02:00:03 -0000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH libnetfilter_queue 0/1] src: Add nfq_hdr_put to library
Date:   Tue,  4 Feb 2020 13:00:02 +1100
Message-Id: <20200204020003.6478-1-duncan_roe@optusnet.com.au>
X-Mailer: git-send-email 2.14.5
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=HhxO2xtGR2hgo/TglJkeQA==:117 a=HhxO2xtGR2hgo/TglJkeQA==:17
        a=l697ptgUJYAA:10 a=RSmzAf-M6YYA:10 a=5iomr8f3Faa-7hstMUAA:9
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is the first of a number of proposed additions to libnetfilter_queue.

The plan is to minimise the need for direct calls to libmnl functions in a
libnetfilter_queue program.

 - example program nf-queue.c is shorter
 - calling sequences are simplaer
 - documentation is mostly in one place

Other planned functions include:

 Function                  Purpose
 ========                  =======
 nfq_socket_sendto         Eliminate mnl_socket_sendto arg 3 (nlh->nlmsg_len)
 nfq_socket_open           Eliminate mnl_socket_open arg (NETLINK_NETFILTER)
 nfq_socket_bind           Eliminate mnl_socket_bind args 2 & 3
                           (0, MNL_SOCKET_AUTOPID)
 nfq_socket_setsockopt     Eliminate mnl_socket_setsockopt args 3 & 4
                           (&ret, sizeof(int))
 nfq_cb_run                Eliminate mnl_cb_run arg 3 (0). Also:
                           Replace mnl_cb_run arg 4 (unsigned int portid) with
                           (struct nlmsghdr *nlh). This eliminates the call to
                           mnl_socket_get_portid and the need to declare portid
 nfq_attr_put_config_flags Avoid having to call mnl_attr_put_u32 twice, also
                           avoid having to use htonl.
                           Implementation note: copy nfq_set_queue_flags
                                                documentation
 nfq_attr_put_u32          Avoid call to htonl
 nfq_attr_get_u32          Avoid call to ntohl

Leading eventually to the new top-level module:

Library Setup [CURRENT]

Duncan Roe (1):
  src: move static nfq_hdr_put from examples/nf-queue.c into the library
    since everyone is going to want it.

 examples/nf-queue.c                             | 15 -------------
 include/libnetfilter_queue/libnetfilter_queue.h |  1 +
 src/nlmsg.c                                     | 28 ++++++++++++++++++++++---
 3 files changed, 26 insertions(+), 18 deletions(-)

-- 
2.14.5

