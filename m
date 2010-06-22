From: tingwei liu <tingw.liu@gmail.com>
Subject: multi-path route can't keep long time connections
Date: Tue, 22 Jun 2010 09:48:09 +0800
Message-ID: <AANLkTimeYhY-lgY2c5dfYQRDZ2oDLpB1U7TzkvyFQh_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41530 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab0FVBsK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jun 2010 21:48:10 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Because route circularly flush route cache
(/proc/net/sys/ipv4/route/secret_timeval),the multi-path route can't
keep long time connections. The long time connections maybe interrupt
every "secret_timeval" seconds.
Such as:
default nexthop via 192.168.0.1 weight 1
                       via 192.168.1.1 weight 1
                       via 192.168.2.1 weight 1

With a connection cross 192.168.0.1 in the first time."secret_timeval"
seconds later,this connection maybe cross 192.168.1.1,then this
connection will be reconnect.

Anyone can help me?

Your response is pleasure.
