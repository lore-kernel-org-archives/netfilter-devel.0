From: Eric Leblond <eric@inl.fr>
Subject: ip_queue_vwmark for pom-ng
Date: Thu, 10 Jun 2004 23:31:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1086903111.4794.4.camel@coati>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-VU0EGc4MuCLO7RbPFIu/"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-VU0EGc4MuCLO7RbPFIu/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi everyone,

I finally found the time to port my ip_queue_vwmark patch to pom-ng. I
join a patch to this mail.
Little reminder :
ip_queue_vwmark adds a function to libipq (ipq_set_vwmark for
ipq_set_verdict_with_mark) that permits to put a mark on the packet when
reinjecting it into the kernel.

It is used by the Nufw project (http://www.nufw.org) to mark packet with
user identity thus enabling a per-user QOS.

BR,
-- 
Eric Leblond <eric@inl.fr>
INL

--=-VU0EGc4MuCLO7RbPFIu/
Content-Disposition: attachment; filename=ip_queue_vmark.patch
Content-Type: text/x-patch; name=ip_queue_vmark.patch; charset=us-ascii
Content-Transfer-Encoding: 7bit

diff -uNr patch-o-matic-ng-20040302/ip_queue_vwmark/help patch-o-matic-ng-20040302.new/ip_queue_vwmark/help
--- patch-o-matic-ng-20040302/ip_queue_vwmark/help	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20040302.new/ip_queue_vwmark/help	2004-06-10 22:13:51.000000000 +0200
@@ -0,0 +1,12 @@
+
+Adds the possibility to change mark of a packet in userspace.
+The ip_queue module is changed and a new function is added to 
+libipq to decide and change the mark of a packet. 
+
+This is used by the NuFW project (http://www.nufw.org).
+
+***** WARNING ***** 
+This patch breaks compatibility with the preceding version of libipq
+and ip_queue module.
+This patch also patch the userspace directory which means that you
+you have to recompile and reinstall the iptables package after that.
diff -uNr patch-o-matic-ng-20040302/ip_queue_vwmark/info patch-o-matic-ng-20040302.new/ip_queue_vwmark/info
--- patch-o-matic-ng-20040302/ip_queue_vwmark/info	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20040302.new/ip_queue_vwmark/info	2004-06-10 22:24:59.000000000 +0200
@@ -0,0 +1,5 @@
+Title: Add a function to libipq to put a mark on paquet from userspace
+Author: Eric Leblond <eric@inl.fr>
+Status: It Works For Me.
+Repository: extra
+Recompile: netfilter|iptables
diff -uNr patch-o-matic-ng-20040302/ip_queue_vwmark/iptables.patch patch-o-matic-ng-20040302.new/ip_queue_vwmark/iptables.patch
--- patch-o-matic-ng-20040302/ip_queue_vwmark/iptables.patch	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20040302.new/ip_queue_vwmark/iptables.patch	2004-06-10 22:14:34.000000000 +0200
@@ -0,0 +1,76 @@
+diff -Nru include.orig/libipq/libipq.h include/libipq/libipq.h
+--- userspace/include.orig/libipq/libipq.h	2003-10-16 01:53:08.000000000 +0200
++++ userspace/include/libipq/libipq.h	2003-10-16 23:47:35.000000000 +0200
+@@ -79,6 +79,13 @@
+                     size_t data_len,
+                     unsigned char *buf);
+ 
++int ipq_set_vwmark(const struct ipq_handle *h,
++                    ipq_id_t id,
++                    unsigned int verdict,
++                    unsigned long nfmark,
++                    size_t data_len,
++                    unsigned char *buf);
++
+ int ipq_ctl(const struct ipq_handle *h, int request, ...);
+ 
+ char *ipq_errstr(void);
+
+diff -Nru libipq.orig/libipq.c libipq/libipq.c
+--- userspace/libipq.orig/libipq.c	2003-10-16 01:58:46.000000000 +0200
++++ userspace/libipq/libipq.c	2003-10-16 23:33:10.000000000 +0200
+@@ -348,6 +348,54 @@
+ 	return ipq_netlink_sendmsg(h, &msg, 0);
+ }
+ 
++int ipq_set_vwmark(const struct ipq_handle *h,
++                    ipq_id_t id,
++                    unsigned int verdict,
++                    unsigned long nfmark,
++                    size_t data_len,
++                    unsigned char *buf)
++{
++	unsigned char nvecs;
++	size_t tlen;
++	struct nlmsghdr nlh;
++	ipq_peer_msg_t pm;
++	struct iovec iov[3];
++	struct msghdr msg;
++
++	memset(&nlh, 0, sizeof(nlh));
++	nlh.nlmsg_flags = NLM_F_REQUEST;
++	nlh.nlmsg_type = IPQM_VWMARK;
++	nlh.nlmsg_pid = h->local.nl_pid;
++	memset(&pm, 0, sizeof(pm));
++	pm.msg.vwmark.value = verdict;
++	pm.msg.vwmark.id = id;
++	pm.msg.vwmark.data_len = data_len;
++	pm.msg.vwmark.nfmark = nfmark;
++	iov[0].iov_base = &nlh;
++	iov[0].iov_len = sizeof(nlh);
++	iov[1].iov_base = &pm;
++	iov[1].iov_len = sizeof(pm);
++	tlen = sizeof(nlh) + sizeof(pm);
++	nvecs = 2;
++	if (data_len && buf) {
++		iov[2].iov_base = buf;
++		iov[2].iov_len = data_len;
++		tlen += data_len;
++		nvecs++;
++	}
++	msg.msg_name = (void *)&h->peer;
++	msg.msg_namelen = sizeof(h->peer);
++	msg.msg_iov = iov;
++	msg.msg_iovlen = nvecs;
++	msg.msg_control = NULL;
++	msg.msg_controllen = 0;
++	msg.msg_flags = 0;
++	nlh.nlmsg_len = tlen;
++	return ipq_netlink_sendmsg(h, &msg, 0);
++}
++
++
++
+ /* Not implemented yet */
+ int ipq_ctl(const struct ipq_handle *h, int request, ...)
+ {
diff -uNr patch-o-matic-ng-20040302/ip_queue_vwmark/linux.patch patch-o-matic-ng-20040302.new/ip_queue_vwmark/linux.patch
--- patch-o-matic-ng-20040302/ip_queue_vwmark/linux.patch	1970-01-01 01:00:00.000000000 +0100
+++ patch-o-matic-ng-20040302.new/ip_queue_vwmark/linux.patch	2004-06-10 22:13:51.000000000 +0200
@@ -0,0 +1,85 @@
+diff -uNr linux-2.4.22.orig/include/linux/netfilter_ipv4/ip_queue.h linux-2.4.22/include/linux/netfilter_ipv4/ip_queue.h
+--- linux-2.4.22.orig/include/linux/netfilter_ipv4/ip_queue.h	2000-08-10 21:35:15.000000000 +0200
++++ linux-2.4.22/include/linux/netfilter_ipv4/ip_queue.h	2003-10-21 23:01:36.000000000 +0200
+@@ -47,10 +47,20 @@
+ 	unsigned char payload[0];	/* Optional replacement packet */
+ } ipq_verdict_msg_t;
+ 
++typedef struct ipq_vwmark_msg {
++	unsigned int value;		/* Verdict to hand to netfilter */
++	unsigned long id;		/* Packet ID for this verdict */
++	size_t data_len;		/* Length of replacement data */
++	unsigned char payload[0];	/* Optional replacement packet */
++	unsigned long nfmark;		/* Mark for the Packet */
++} ipq_vwmark_msg_t;
++
++
+ typedef struct ipq_peer_msg {
+ 	union {
+ 		ipq_verdict_msg_t verdict;
+ 		ipq_mode_msg_t mode;
++                ipq_vwmark_msg_t vwmark;
+ 	} msg;
+ } ipq_peer_msg_t;
+ 
+@@ -67,6 +77,7 @@
+ #define IPQM_MODE	(IPQM_BASE + 1)		/* Mode request from peer */
+ #define IPQM_VERDICT	(IPQM_BASE + 2)		/* Verdict from peer */ 
+ #define IPQM_PACKET	(IPQM_BASE + 3)		/* Packet from kernel */
+-#define IPQM_MAX	(IPQM_BASE + 4)
++#define IPQM_VWMARK	(IPQM_BASE + 4)		/* Verdict and mark from peer */
++#define IPQM_MAX	(IPQM_BASE + 5)
+ 
+ #endif /*_IP_QUEUE_H*/
+diff -uNr linux-2.4.22.orig/net/ipv4/netfilter/ip_queue.c linux-2.4.22/net/ipv4/netfilter/ip_queue.c
+--- linux-2.4.22.orig/net/ipv4/netfilter/ip_queue.c	2003-06-13 16:51:39.000000000 +0200
++++ linux-2.4.22/net/ipv4/netfilter/ip_queue.c	2003-10-21 23:01:36.000000000 +0200
+@@ -417,6 +417,33 @@
+ }
+ 
+ static int
++ipq_set_vwmark(struct ipq_vwmark_msg *vmsg, unsigned int len)
++{
++	struct ipq_queue_entry *entry;
++
++	if (vmsg->value > NF_MAX_VERDICT)
++		return -EINVAL;
++
++	entry = ipq_find_dequeue_entry(id_cmp, vmsg->id);
++	if (entry == NULL)
++		return -ENOENT;
++	else {
++		int verdict = vmsg->value;
++		
++		if (vmsg->data_len && vmsg->data_len == len)
++			if (ipq_mangle_ipv4((ipq_verdict_msg_t *)vmsg, entry) < 0)
++				verdict = NF_DROP;
++
++		/* set mark of associated skb */
++		entry->skb->nfmark = vmsg->nfmark;
++		
++		ipq_issue_verdict(entry, verdict);
++		return 0;
++	}
++}
++
++
++static int
+ ipq_receive_peer(struct ipq_peer_msg *pmsg,
+                  unsigned char type, unsigned int len)
+ {
+@@ -438,6 +465,14 @@
+ 			status = ipq_set_verdict(&pmsg->msg.verdict,
+ 			                         len - sizeof(*pmsg));
+ 			break;
++        case IPQM_VWMARK:
++		if (pmsg->msg.verdict.value > NF_MAX_VERDICT)
++			status = -EINVAL;
++		else
++			status = ipq_set_vwmark(&pmsg->msg.vwmark,
++			                         len - sizeof(*pmsg));
++			break;
++
+ 	default:
+ 		status = -EINVAL;
+ 	}

--=-VU0EGc4MuCLO7RbPFIu/--
