From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [PATCH 0/1] netfilter: Ignore bogus SACK option values in TCP conntrack
Date: Mon,  2 Sep 2013 20:57:59 +0200
Message-ID: <1378148280-1153-1-git-send-email-kadlec@blackhole.kfki.hu>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Corey Hickey <bugfood-ml@fatooh.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:58319 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758849Ab3IBS6D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Sep 2013 14:58:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Please consider applying the next patch to nf-next. It's possibly a
candidate for nf too.

Best regards,
Jozsef

Jozsef Kadlecsik (1):
  netfilter: Ignore bogus SACK option values in TCP conntrack

 net/netfilter/nf_conntrack_proto_tcp.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

