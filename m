From: Phuong Cao <phuong.m.cao@gmail.com>
Subject: How to generate statistics for a TCP flow using netfilter conntrack?
Date: Fri, 3 Oct 2014 08:36:15 -0700
Message-ID: <CAKMo2zZWZbCnK1EnWEmR4QTh2VXBn5cAcKGb+8UvM48p2+ws3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:56759 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbaJCPg5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:36:57 -0400
Received: by mail-lb0-f178.google.com with SMTP id w7so1202707lbi.23
        for <netfilter-devel@vger.kernel.org>; Fri, 03 Oct 2014 08:36:55 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

I am asking for your instructions to generate statistics for a TCP
flow using conntrack?
In my use case, a TCP flow consists of packets from host_a:port_a to
host_b:port_b and statistics could be average packet size or average
window size, per TCP flow.

My plan is to add a hook into TCP connection tracking module
(nf_conntrack_proto_tcp.c) and collect statistics per TCP flow.
However, I don't know how conntrack relates to netfilter. Can I write
a netfilter hook and access the tcp_conntracks table? Or should I  put
the hook in the tcp_new() function in nf_conntrack_proto_tcp.c?

Please let me know your suggestions on this issue.

Thanks!
- PC
