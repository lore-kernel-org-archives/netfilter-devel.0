From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/5] netfilter: NAT sequence number adjustment fixes/improvements
Date: Sun, 28 Jul 2013 22:54:06 +0200
Message-ID: <1375044851-12471-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45251 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab3G1VCn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Jul 2013 17:02:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

the following patches from my SYNPROXY tree contain some fixes and improvements
for netfilter sequence number adjustment handling and two unrelated minor
patches:

- Remove net_ratelimit() for LOG_INVALID: ratelimiting explicitly enabled
  packet logging is inconsistent with other netfilter logging behaviour and
  makes debugging harder

- Constify nf_ct_attach() source skb argument

- Fix locking in nf_nat_seq_adjust(): we need to take nf_nat_seqofs lock
  to protect against concurrent changes to the sequence adjustment data

- Increase sequence number offset size to 32 bits. When many adjustments
  happen in a single connection, the offsets can overflow and break the
  connection.

- Use per-conntrack locks to protect sequence number adjustment data.
  Should increase scalability and additionally saves one lock/unlock operation
  per TCP packet.

Please apply. thanks.
