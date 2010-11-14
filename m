From: =?KOI8-R?B?SWdvciAnTG8nICjpLkwuKQ==?= <bombsiteunrested@gmail.com>
Subject: libnetfilter_queue: extracting TCP options.
Date: Sun, 14 Nov 2010 06:13:10 +0200
Message-ID: <AANLkTimJdQAjc_-r1R8ELN_Y+EVaN5Q30Y=Rzxg-Bg_j@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50683 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0KNENw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Nov 2010 23:13:52 -0500
Received: by yxn35 with SMTP id 35so668491yxn.19
        for <netfilter-devel@vger.kernel.org>; Sat, 13 Nov 2010 20:13:52 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

How one can get TCP packet's options (especially timestamp and MD5)
using only libnetfilter_queue in userspace?
Having a callback routine(struct nfq_q_handle *qh, struct nfgenmsg
*nfmsg, struct nfq_data *nfa, void *data) - which structure may
contain the desired options set?

Most adequate Netfilter-based code to solve this problem was found in
linux/net/netfilter/nf_conntrack_proto_tcp.c - not a best kind of
documentation, but provided a nice method of reading a structure. Now
just need to get a bytes to read.

cheers,
Igor
