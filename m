From: Kuzin Andrey <kuzinandrey@yandex.ru>
Subject: [PATCH]: drop packet without verdict from nfqueue after timeout
Date: Mon, 23 Mar 2009 21:48:23 +0300
Message-ID: <1691181420.20090323214823@yandex.ru>
Reply-To: Kuzin Andrey <kuzinandrey@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from forwards7.yandex.ru ([77.88.61.48]:40584 "EHLO
	forwards7.yandex.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZCWSrV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 14:47:21 -0400
Received: from smtp16.yandex.ru (smtp16.yandex.ru [77.88.61.56])
	by forwards7.yandex.ru (Yandex) with ESMTP id C59DF150C79
	for <netfilter-devel@vger.kernel.org>; Mon, 23 Mar 2009 21:47:17 +0300 (MSK)
Received: from gw-212.mjknet.ru ([212.45.5.114]:25861 "EHLO www1.firststeps.ru"
        smtp-auth: "kuzinandrey" TLS-CIPHER: <none> TLS-PEER-CN1: <none>)
        by mail.yandex.ru with ESMTP id S12992617AbZCWSrL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Mar 2009 21:47:11 +0300
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is patch for problem with stucked packets in nf_queue if
something going wrong in userspace program. Automatically drop packets
without any verdict after timeout defined by NFQNL_TIMEOUT_ENTRY_DROP.

Who may create patch for menu config for this feature ?


diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 8c86011..74fc322 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -169,17 +169,29 @@ __enqueue_entry(struct nfqnl_instance *queue, struct nf_queue_entry *entry)
        queue->queue_total++;
 }

+#define NFQNL_TIMEOUT_ENTRY_DROP 30
+
 static struct nf_queue_entry *
 find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 {
-       struct nf_queue_entry *entry = NULL, *i;
+       struct nf_queue_entry *entry = NULL, *next, *i;
+       ktime_t kt = ktime_get_real();

        spin_lock_bh(&queue->lock);

-       list_for_each_entry(i, &queue->queue_list, list) {
+       list_for_each_entry_safe(i, next, &queue->queue_list, list) {
                if (i->id == id) {
                        entry = i;
                        break;
+                } else {
+                       struct timeval tv = ktime_to_timeval(ktime_sub(kt, i->skb->tstamp));
+                       if (tv.tv_sec > NFQNL_TIMEOUT_ENTRY_DROP) {
+                               printk(KERN_ERR "nf_queue: drop timeouted packet "
+                                       "(queue_num=%u seq_id=%u)\n", queue->queue_num, i->id);
+                               list_del(&i->list);
+                               queue->queue_total--;
+                               nf_reinject(i, NF_DROP);
+                       }
                }
        }

