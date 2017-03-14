From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 0/2] add backend support to define ct helpers
Date: Tue, 14 Mar 2017 20:53:59 +0100
Message-ID: <20170314195401.1334-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42118 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750780AbdCNTxp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 14 Mar 2017 15:53:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds libnftnl support to define connection tracking helpers.
Frontend (nft) support will follow soon.

 include/libnftnl/object.h           |   10 +
 include/linux/netfilter/nf_tables.h |   12 +-
 include/obj.h                       |    6 +
 src/Makefile.am                     |    1 
 src/libnftnl.map                    |    4 
 src/obj/ct_helper.c                 |  210 ++++++++++++++++++++++++++++++++++++
 src/object.c                        |   29 ++++
 7 files changed, 270 insertions(+), 2 deletions(-)

