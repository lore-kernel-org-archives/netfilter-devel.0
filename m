From: "Tobias Koeck" <tobias.koeck@gmail.com>
Subject: hooks
Date: Thu, 18 Dec 2008 00:31:55 +0100
Message-ID: <379e30200812171531v506beaccsdfb5c103ec0671d3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:42667 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYLQXb5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:31:57 -0500
Received: by bwz14 with SMTP id 14so599661bwz.13
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Dec 2008 15:31:55 -0800 (PST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

I'm programing  module and in the register function I've included

	.hooks		= (1 << NF_INET_FORWARD),

If I want to append a rule with iptables I get the following error
message in /var/log/syslog:

tron kernel: ip_tables: RARQOS target: bad hook_mask 4/16

I'm using mangle and forwarding

What could be the problem?

Greetings
tobias
