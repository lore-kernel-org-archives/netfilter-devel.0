From: =?UTF-8?B?QWxpbiBOxINzdGFj?= <alin.nastac@gmail.com>
Subject: [helper PATCH] Preserve conntrack helper bound through CT rule
Date: Wed, 26 Mar 2014 13:34:04 +0100
Message-ID: <CAF1oqRC4LDjjq2X1EjRSJr0g0oQk45UMZBviLz0mziTwM8WbRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f177.google.com ([209.85.217.177]:46102 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754118AbaCZMeF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:34:05 -0400
Received: by mail-lb0-f177.google.com with SMTP id z11so1434426lbi.36
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2014 05:34:04 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I've discovered that MASQUERADE target overwrites the CT --helper settings.
The setup I used is the following:
  iptables -t raw -A PREROUTING -i lan -p tcp --dport 2121 -j CT --helper ftp
  iptables -t nat -A POSTROUTING -o wan -s 192.168.1.0/24 -j MASQUERADE

I found out the problem, the helper set in the conntrack template is
overwritten by MASQUERADE target.
This patch fixes the issue:

diff --git a/net/netfilter/nf_conntrack_core.c
b/net/netfilter/nf_conntrack_core.c
index bba14a7..ab7cd3e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1445,7 +1445,7 @@ void nf_conntrack_alter_reply(struct nf_conn *ct,
        nf_ct_dump_tuple(newreply);

        ct->tuplehash[IP_CT_DIR_REPLY].tuple = *newreply;
-       if (ct->master || (help && !hlist_empty(&help->expectations)))
+       if (ct->master || help)
                return;

        rcu_read_lock();

I didn't used the latest kernel, but seems the problem is still present.

Best regs,
Alin
