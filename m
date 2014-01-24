From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: [Question and PATCH] nfconntrack: clear counter at IPCTNL_MSG_CT_DELETE
Date: Fri, 24 Jan 2014 18:45:33 +0900
Message-ID: <CAGCkEt0rwo0+qT1BHXggHN3946yCCSEkhDrEaucqpAxVVF1s5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:38606 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922AbaAXJpe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Jan 2014 04:45:34 -0500
Received: by mail-la0-f43.google.com with SMTP id pv20so2342242lab.2
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Jan 2014 01:45:33 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

  Hello Pablo, all

Could we clear counter at IPCTNL_MSG_CT_DELETE?

Assume we call netlink_dump() twice from
netlink_poll() by mmaped socket. A ct entry which will be dumped at the second
time is deleted just after the first dump, before the second dump. The delete
event makes report its counter and mark it deleting.

It seems that we can read the deleting entry at the second time and will dump
counter value again because it loops in kernel context, Is it right?

thanks,
---
 net/netfilter/nf_conntrack_netlink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c
b/net/netfilter/nf_conntrack_netlink.c
index 08870b8..e162ab0 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -219,7 +219,7 @@ dump_counters(struct sk_buff *skb, struct
nf_conn_acct *acct,
        struct nlattr *nest_count;
        u64 pkts, bytes;

-       if (type == IPCTNL_MSG_CT_GET_CTRZERO) {
+       if (type == IPCTNL_MSG_CT_GET_CTRZERO || type == IPCTNL_MSG_CT_DELETE) {
                pkts = atomic64_xchg(&counter[dir].packets, 0);
                bytes = atomic64_xchg(&counter[dir].bytes, 0);
        } else {
--
1.7.10.4
