From: Sam Liddicott <sam@liddicott.com>
Subject: Multiple conntrack tables
Date: Wed, 18 Jun 2014 07:31:59 +0100
Message-ID: <CAOj-5WDepb3pj3=oRms+OhWhScFJ15V-H3QuGUFjScE54-mtMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qg0-f43.google.com ([209.85.192.43]:62645 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756390AbaFRGcA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:32:00 -0400
Received: by mail-qg0-f43.google.com with SMTP id z60so342564qgd.16
        for <netfilter-devel@vger.kernel.org>; Tue, 17 Jun 2014 23:31:59 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I know that a rule in raw can prevent a packet from being processed by
contrack..

I wonder if it could also identify which contrack table it should go in.

This problem first came up when using contrack for some extra iptables
rules with multiple bridges but where different bridges had clients
with the same IP address.

I used to think Mac addresses would need to be part of the contrack
key and did some trial work on that but now I realise that multiple
named or numbered conntrack tables would be better.

I don't need this feature now but it does seem like a good idea.

Sam
