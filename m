From: Harald Welte <laforge@netfilter.org>
Subject: [PATCH] Numerous ct_sync updates.
Date: Thu, 14 Oct 2004 21:16:24 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20041014191624.GH12694@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RMedoP2+Pr6Rq0N2"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-failover@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--RMedoP2+Pr6Rq0N2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Below is a patch with numerous ct_sync updates that I just committed to
svn.netfilter.org.  The patches adress numerous issues that were found
during ct_sync testing during the last week.

Debugging ct_sync should become easier due to the added statistics and
the ethereal dissector plugin for the ctsync protocol, which is now also
on
https://svn.netfilter.org/netfilter/trunk/netfilter-ha/ethereal-plugin

Any comments / tests / ... welcome.

Cheers,
	Harald


----- patch follows

Large number of ct_sync updates:
- add verbose statistics to /proc/net/stat (for lnstat usage)
- implement new version 2 of protocol
	- add flags to cts_proto_packet and sync message
- explicitly specify the value in all enumerations
- introduce new CT_SYNC_DEBUG2 macro (only printed if CTSYNC_DEBUG >=3D2)
- comment out some DUMP_TUPLE messages
- replace strcmp() for empty strings with check of zero-byte at offset 0
- INIT_LIST_HEAD the bysource.list and byipsproto.list for debugging
- do not set bysource.conntrack and byipsproto.conntrack since
  place_in_hashes() does this for us
- give shorter lengt to some functions (updateconntrack)
- add some messages for
	- received NEW conntrack, but we already know it
	- received UPDATE conntrack, but we don't know it
- break some over-length lines (80 char wide terminals)
- send MASTER_ANNOUNCE when initsync starts in order to=20
  tell slave(s) about current sequence number
- send empty SYNC message with F_INITSYNC set, even if we have an=20
  empty conntrack hash (to let slave(s) know that we're done)
- retransmit INITSYNC request every five seconds to avoid race condition
  with short 'no master' situation in case of failover
- add PKT_F_RECOVER to indicate that a packet is part of a requested
  recovery
- only learn initial sequence number from MASTER_ANNOUNCE message
- comment out INITSYNC_FOLLOWS code, it shouldn't be needed anymore

All changes by Harald Welte.

diff --exclude .svn -Nru netfilter-ha/ct_sync/ct_sync.h ct_sync-2/ct_sync.h
--- netfilter-ha/ct_sync/ct_sync.h	2004-10-10 13:41:21.000000000 +0200
+++ ct_sync-2/ct_sync.h	2004-10-14 20:54:38.034990704 +0200
@@ -58,9 +58,11 @@
 #if (CTSYNC_DEBUG >=3D 2)
 #define CT_SYNC_ENTER()		CT_SYNC_DEBUG("enter\n")=20
 #define CT_SYNC_LEAVE()		CT_SYNC_DEBUG("leave\n")
+#define CT_SYNC_DEBUG2(x, args...) printk (KERN_DEBUG "ct_sync: %s " x, __=
FUNCTION__ , ## args)
 #else
 #define CT_SYNC_ENTER()
 #define CT_SYNC_LEAVE()
+#define CT_SYNC_DEBUG2(x, args...)
 #endif
=20
 #define CT_SYNC_ERR(x, args...) printk(KERN_ERR "ct_sync: %s " x, __FUNCTI=
ON__ , ## args)
@@ -78,22 +80,29 @@
 {
 	__u8		version;		/* version number */
 	__u8		pkttype;		/* type of packet: sync/NACK */
-	__u16		pktseq;			/* packet sequence number */
 	__u8		node_id;		/* id of the sender node */
 	__u8		count;			/* number of msgs in packet */
+	__u16		pktseq;			/* packet sequence number */
 	__u16		minseq;			/* min seqno master has */
-	__u32		__reserved;		/* placeholder :) */
+	__u8		flags;			/* flags: 1 =3D=3D recover */
+	__u8		__reserved;		/* placeholder :) */
+	__u16		__reserved2;		/* placeholder :) */
 };
=20
 /* packet types */
 enum ct_sync_pkttype_t
 {
-	CT_SYNC_PKT_UNKNOWN,			/* not defined, illegal */
-	CT_SYNC_PKT_MASTER_ANNOUNCE,
-	CT_SYNC_PKT_SLAVE_INITSYNC,
-	CT_SYNC_PKT_SYNC,			/* normal sync packet */
-	CT_SYNC_PKT_NACK,			/* negative ack packet */
-	CT_SYNC_PKT_INITSYNC_FOLLOWS,		/* a full re-sync follows */
+	CT_SYNC_PKT_UNKNOWN 		=3D 0x00,	/* not defined, illegal */
+	CT_SYNC_PKT_MASTER_ANNOUNCE	=3D 0x01,
+	CT_SYNC_PKT_SLAVE_INITSYNC	=3D 0x02,
+	CT_SYNC_PKT_SYNC		=3D 0x03,	/* normal sync packet */
+	CT_SYNC_PKT_NACK		=3D 0x04,	/* negative ack packet */
+	CT_SYNC_PKT_INITSYNC_FOLLOWS	=3D 0x05,	/* a full re-sync follows */
+};
+
+enum ct_sync_pkt_flag_t
+{
+	CT_SYNC_PKT_F_RECOVER 		=3D 0x01,
 };
=20
 /* CT_SYNC_PKT_MASTER_ANNOUNCE */
@@ -124,21 +133,30 @@
 	__u8		resource;	/* which table? */
 	__u8		type;		/* type of message: ct_sync_msgtype_t */
 	__u16		len;		/* length of message */
+	__u8		flags;		/* sync flags */
+	__u8		res1;
+	__u16		res2;
 };
=20
 /* CT_SYNC_PKT_SYNC: message types */
 enum ct_sync_msgtype_t
 {
-	CT_SYNC_MSG_UPDATE =3D 0,			/* update conntrack entry=20
-						   (or create if not exists) */
-	CT_SYNC_MSG_DELETE,			/* delete conntrack entry */
+	CT_SYNC_MSG_UPDATE	=3D 0x01,	/* update conntrack entry=20
+					   (or create if not exists) */
+	CT_SYNC_MSG_DELETE	=3D 0x02,	/* delete conntrack entry */
 };
=20
 /* CT_SYNC_PKT_SYNC: ressources */
 enum ct_sync_resource_t
 {
-	CT_SYNC_RES_CONNTRACK =3D 0,
-	CT_SYNC_RES_EXPECT,
+	CT_SYNC_RES_CONNTRACK	=3D 0x01,
+	CT_SYNC_RES_EXPECT	=3D 0x02,
+};
+
+enum ct_sync_upd_flag_t
+{
+	CTS_UPD_F_NEW 		=3D 0x01,	/* creates new conntrack */
+	CTS_UPD_F_INITSYNC	=3D 0x02,	/* part of initial sync */
 };
=20
 /* linearized conntrack data */
@@ -199,6 +217,48 @@
 	int (*function)(void *);	/* function to run in the new thread */
 };
=20
+/* statistics */
+struct ct_sync_st
+{
+	unsigned long pkts_tot;		/* total packets */
+	unsigned long pkts_ooseq;	/* rx only: total out-of-sequence */
+	unsigned long pkts_recover;	/* total recover pkts */
+
+	unsigned long msgs;		/* total messages */
+	unsigned long error;		/* total invalid msgs */
+
+	unsigned long upd_tot;		/* total update messages */
+	unsigned long upd_new; 		/* total new updates */
+	unsigned long upd_initial;	/* total initsync updates */
+
+	unsigned long upd_newbutexist;	/* rx only: new but already exists  */
+	unsigned long upd_nothere;	/* rx only: not new but not here */
+
+	unsigned long del_tot;		/* total deletes */
+	unsigned long del_nothere;	/* rx only: delete but not here */
+
+	unsigned long exp_upd_tot;	/* total expect updates */
+	unsigned long exp_del_tot;	/* total delete updates */
+};
+
+
+struct ct_sync_stat
+{
+	struct ct_sync_st rx;
+	struct ct_sync_st tx;
+
+	unsigned long slave2master;	/* slave->master transitions */
+	unsigned long master2slave;	/* master->slave transitions */
+	unsigned long master2slave_auto;
+=09
+	unsigned long initsyncs;	/* master: started initsyncs */
+
+};
+
+extern struct ct_sync_stat ct_sync_stats[NR_CPUS];
+
+#define CTS_STAT_INC(field)	(ct_sync_stats[smp_processor_id()].field++)
+
 #endif /* _KERNEL_ */
=20
 #endif
diff --exclude .svn -Nru netfilter-ha/ct_sync/ct_sync_main.c ct_sync-2/ct_s=
ync_main.c
--- netfilter-ha/ct_sync/ct_sync_main.c	2004-10-10 13:41:21.000000000 +0200
+++ ct_sync-2/ct_sync_main.c	2004-10-14 20:54:35.945308384 +0200
@@ -29,6 +29,7 @@
 #include <linux/skbuff.h>
 #include <linux/notifier.h>
 #include <linux/sysctl.h>
+#include <linux/seq_file.h>
 #include <net/sock.h>
=20
 #include <linux/netdevice.h>
@@ -98,6 +99,8 @@
 static DECLARE_WAIT_QUEUE_HEAD(stop_ct_initsync_thread_wait);
 static atomic_t stop_ct_initsync_thread =3D ATOMIC_INIT(0);
=20
+struct ct_sync_stat ct_sync_stats[NR_CPUS];
+
 /* configuration data */
 static struct ct_sync_cfg
 {
@@ -153,7 +156,7 @@
 }
=20
 static int
-fill_ctmsg(void *buff, __u8 event, struct ip_conntrack *ct)
+fill_ctmsg(void *buff, __u8 event, struct ip_conntrack *ct, __u8 flags)
 {
 	struct ct_sync_msghdr *hdr =3D buff;
 	struct ct_sync_conntrack *sct =3D buff + sizeof(*hdr);
@@ -167,9 +170,10 @@
 	hdr->type =3D event;
 	hdr->resource =3D CT_SYNC_RES_CONNTRACK;
 	hdr->len =3D __constant_htons(sizeof(*sct));
+	hdr->flags =3D flags;
=20
-	CT_SYNC_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	CT_SYNC_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	//CT_SYNC_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	//CT_SYNC_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
=20
 	/* copy data from conntrack struct */
 	memset(sct, 0, sizeof(*sct));
@@ -283,12 +287,12 @@
 				    &sct->orig, sizeof(sct->orig)) =3D=3D 0);
 		CT_SYNC_ASSERT(memcmp(&ct->tuplehash[IP_CT_DIR_REPLY].tuple,
 				    &sct->reply, sizeof(sct->reply)) =3D=3D 0);
-		CT_SYNC_DUMP_TUPLE(&sct->orig);
-		CT_SYNC_DUMP_TUPLE(&sct->reply);
+		//CT_SYNC_DUMP_TUPLE(&sct->orig);
+		//CT_SYNC_DUMP_TUPLE(&sct->reply);
 	}
=20
-	CT_SYNC_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
-	CT_SYNC_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
+	//CT_SYNC_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
+	//CT_SYNC_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_REPLY].tuple);
=20
 	/* optimization: done by conntrack_alloc */
 	//ct->tuplehash[IP_CT_DIR_ORIGINAL].ctrack =3D ct;
@@ -331,14 +335,15 @@
 #endif
=20
 	/* conntrack helper */
-	if (unlikely(strcmp(sct->helper, ""))) {
+	if (unlikely(sct->helper[0] !=3D '\0')) {
 		READ_LOCK(&ip_conntrack_lock);
 		helper =3D LIST_FIND(&ip_conntrack_helpers,=20
 				   _helper_name_cmp,
 				   struct ip_conntrack_helper *,
 				   sct->helper);
 		if (unlikely(!helper)) {
-			CT_SYNC_ERR("Unknown helper, ignoring.\n");
+			CT_SYNC_ERR("Unknown conntrack helper `%s', "
+				    "ignoring.\n", sct->helper);
 			ct->helper =3D NULL;
 		} else {
 			ct->helper =3D helper;
@@ -354,6 +359,14 @@
=20
 	/* NAT */
 #ifdef CONFIG_IP_NF_NAT_NEEDED
+
+	{
+		struct ip_nat_info *nat =3D &ct->nat.info;
+		/* DEBUG: initialize list heads to avoid oops */
+		INIT_LIST_HEAD(&nat->bysource.list);
+		INIT_LIST_HEAD(&nat->byipsproto.list);
+	}
+
 	//if (likely(sct->nat_initialized && sct->nat_num_manips)) {
 	if (likely(sct->nat_initialized )) {
 		struct ip_nat_info *nat =3D &ct->nat.info;
@@ -367,13 +380,11 @@
=20
 		if (new) {
 			nat->initialized =3D sct->nat_initialized;
-			nat->bysource.conntrack =3D ct;
-			nat->byipsproto.conntrack =3D ct;
+			/* do not set .conntrack, place_in_hashes will do */
 			nat->num_manips =3D sct->nat_num_manips;
 			memcpy(&nat->manips, sct->nat_manips,=20
 				(sct->nat_num_manips * sizeof(struct ip_nat_info_manip)));
-
-			if (unlikely(strcmp(sct->nat_helper, ""))) {
+			if (unlikely(sct->nat_helper[0] !=3D '\0')) {
 				struct ip_nat_helper *helper;
 				/* look up nat helper */
 				READ_LOCK(&ip_nat_lock);
@@ -381,7 +394,7 @@
 						   struct ip_nat_helper *,
 						   sct->nat_helper);
 				if (unlikely(!helper)) {
-					CT_SYNC_ERR("Unknown NAT helper, ignoring\n");
+					CT_SYNC_ERR("Unknown NAT helper `%s', ignoring\n", sct->nat_helper);
 					nat->helper =3D NULL;
 					memset(&ct->nat.help, 0, sizeof(ct->nat.help));
 				} else {
@@ -430,7 +443,9 @@
 				WRITE_LOCK(&ip_nat_lock);
 				place_in_hashes(ct, &ct->nat.info);
 				WRITE_UNLOCK(&ip_nat_lock);
-			}
+			} else
+				CT_SYNC_INFO("sct->nat_initialized =3D=3D 0\n");
+
 		} else {
 			CT_SYNC_ERR("want to put conntrack in hash but is already there\n");
 		}
@@ -643,7 +658,8 @@
=20
 /* process messages */
 static int
-ct_sync_msg_process_updateconntrack(void *data, u16 len)
+ct_sync_msg_process_update_ct(struct ct_sync_msghdr *msghdr,=20
+			       void *data, u16 len)
 {
 	struct ct_sync_conntrack *sct =3D (struct ct_sync_conntrack *)data;
 	struct ip_conntrack_tuple_hash *h;
@@ -654,7 +670,10 @@
 	CT_SYNC_ENTER();
=20
 	if (unlikely(len < sizeof(struct ct_sync_conntrack))) {
-		CT_SYNC_ERR("Illegal message size: %u\n", len);
+		if (len !=3D 0) {
+			CTS_STAT_INC(rx.error);
+			CT_SYNC_ERR("Illegal message size: %u\n", len);
+		}
 		CT_SYNC_LEAVE();
 		return -1;
 	}
@@ -673,11 +692,21 @@
 		new =3D 1;
 	}
=20
+	if (unlikely(h && msghdr->flags & CTS_UPD_F_NEW)) {
+		CTS_STAT_INC(rx.upd_newbutexist);
+		CT_SYNC_ERR("received NEW conntrack, but we already know it: ");
+		DUMP_TUPLE(&sct->orig);
+	} else if (unlikely(!h && !(msghdr->flags & CTS_UPD_F_NEW))) {
+		CTS_STAT_INC(rx.upd_nothere);
+		CT_SYNC_ERR("received UPD conntrack, but we don't know it: ");
+		DUMP_TUPLE(&sct->orig);
+	}
+
 	_ct_sync_update_conntrack(ct, sct, new);
=20
 	ip_conntrack_put(ct);
=20
-	CT_SYNC_DEBUG("updated conntrack: ");
+	CT_SYNC_DEBUG("%s conntrack: ", new ? "new" : "upd");
 	CT_SYNC_DUMP_TUPLE(&ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple);
=20
 	CT_SYNC_LEAVE();
@@ -686,7 +715,8 @@
 }
=20
 static int
-ct_sync_msg_process_delconntrack(void *data, u16 len)
+ct_sync_msg_process_del_ct(struct ct_sync_msghdr *msghdr,=20
+			   void *data, u16 len)
 {
 	struct ip_conntrack_tuple *t =3D (struct ip_conntrack_tuple * ) data;
 	struct ip_conntrack_tuple_hash *h;
@@ -694,6 +724,7 @@
 	CT_SYNC_ENTER();
=20
 	if (unlikely(len < sizeof(*t))) {
+		CTS_STAT_INC(rx.error);
 		CT_SYNC_ERR("Illegal message size: %u\n", len);
 		CT_SYNC_LEAVE();
 		return -1;
@@ -706,6 +737,7 @@
 		CT_SYNC_DUMP_TUPLE(t);
 		ip_conntrack_put(h->ctrack);
 	} else {
+		CTS_STAT_INC(rx.del_nothere);
 		CT_SYNC_DEBUG("Cannot delete nonexistent conntrack:");
 		CT_SYNC_DUMP_TUPLE(t);
 	}
@@ -723,6 +755,7 @@
 	CT_SYNC_ENTER();
=20
 	if (unlikely(len < sizeof(struct ct_sync_expect))) {
+		CTS_STAT_INC(rx.error);
 		CT_SYNC_ERR("Illegal message size: %u\n", len);
 		CT_SYNC_LEAVE();
 		return -1;
@@ -742,6 +775,7 @@
 	CT_SYNC_ENTER();
=20
 	if (unlikely(len < sizeof(struct ct_sync_expect))) {
+		CTS_STAT_INC(rx.error);
 		CT_SYNC_ERR("Illegal message size: %u\n", len);
 		CT_SYNC_LEAVE();
 		return -1;
@@ -788,19 +822,23 @@
 	case CT_SYNC_RES_CONNTRACK:
 		switch (msghdr->type) {
 		case CT_SYNC_MSG_UPDATE:
-			ret =3D ct_sync_msg_process_updateconntrack(data, len);
+			CTS_STAT_INC(rx.upd_tot);
+			ret =3D ct_sync_msg_process_update_ct(msghdr, data, len);
 			break;
 		case CT_SYNC_MSG_DELETE:
-			ret =3D ct_sync_msg_process_delconntrack(data, len);
+			CTS_STAT_INC(rx.del_tot);
+			ret =3D ct_sync_msg_process_del_ct(msghdr, data, len);
 			break;
 		}
 		break;
 	case CT_SYNC_RES_EXPECT:
 		switch(msghdr->type) {
 		case CT_SYNC_MSG_UPDATE:
+			CTS_STAT_INC(rx.exp_upd_tot);
 			ret =3D ct_sync_msg_process_updateexpect(data, len);
 			break;
 		case CT_SYNC_MSG_DELETE:
+			CTS_STAT_INC(rx.exp_del_tot);
 			ret =3D ct_sync_msg_process_delexpect(data, len);
 			break;
 		}
@@ -850,9 +888,10 @@
 ct_sync_start_initsync(struct cts_protoh *cph)
 {
 	CT_SYNC_ENTER();
-=09
+
 	if (cts_proto_is_master(cts_cfg.protoh) &&
 	    !atomic_read(&ct_sync_initsync_active)) {
+		CTS_STAT_INC(initsyncs);
 		/* signal that an initsync is to follow */
 		if (cts_proto_initsync_follows(cph) < 0) {
 			CT_SYNC_LEAVE();
@@ -880,7 +919,7 @@
 	mm_segment_t oldmm;
 	unsigned long remaining;
 	DECLARE_WAITQUEUE(wait, current);
-=09
+
 	CT_SYNC_ENTER();
=20
 	/* daemonize kernel thread, set values */
@@ -908,20 +947,22 @@
 				break;
 		}
=20
+		cts_proto_initsync_retransmit(cts_cfg.protoh);
+
 		__set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&ct_sync_send_wait, &wait);
-		CT_SYNC_DEBUG("falling asleep\n");
+		CT_SYNC_DEBUG2("falling asleep\n");
 		remaining =3D schedule_timeout(HZ);
 		remove_wait_queue(&ct_sync_send_wait, &wait);
 		__set_current_state(TASK_RUNNING);
=20
 		if (remaining <=3D 0) {
 			/* we had a timeout, try to advance buffer even if it's not full */
-			CT_SYNC_DEBUG("woken up because schedule_timeout() timed out\n");
+			CT_SYNC_DEBUG2("woken up because schedule_timeout() timed out\n");
 			if (cts_proto_advance_timeout(cts_cfg.protoh) < 0)
 				CT_SYNC_ERR("advancing current csb failed\n");
 		} else
-			CT_SYNC_DEBUG("woken up after schedule_timeout() because we had an even=
t\n");
+			CT_SYNC_DEBUG2("woken up after schedule_timeout() because we had an eve=
nt\n");
         }
=20
 	set_fs(oldmm);
@@ -971,12 +1012,13 @@
 		while (cts_proto_recv_pending(cts_cfg.protoh)) {
 			switch (cts_proto_recv_pkt(cts_cfg.protoh)) {
 			case CTS_PROTO_RCV_ERROR:
-				/* FIXME: unrecoverable error, should complain, but=20
-				 * should not exit! */
+				/* FIXME: unrecoverable error, should complain,
+ 				 * but should not exit! */
 				goto error;
 				break;
 			case CTS_PROTO_RCV_SYNC:
-				/* we'll handle this later when dequeuing messages */
+				/* we'll handle this later when=20
+				 * dequeuing messages */
 				pkts_enqueued++;
 				break;
 			case CTS_PROTO_RCV_INITSYNC:
@@ -984,12 +1026,13 @@
 				ct_sync_start_initsync(cts_cfg.protoh);
 				break;
 			default:
-				/* the protocol layer handled other cases, and dropped
-				 * the packet */
+				/* the protocol layer handled other cases,=20
+				   and dropped the packet */
 				break;
 			}
 		=09
 			pkts_received++;
+			CTS_STAT_INC(rx.pkts_tot);
 			if (pkts_received >=3D CT_SYNC_RECV_BURST)
 				break;
 		}
@@ -999,6 +1042,7 @@
 			while ((msghdr =3D cts_proto_recvmsg(cts_cfg.protoh,=20
 								&pkthdr))) {
 				msgs_received++;
+				CTS_STAT_INC(rx.msgs);
=20
 				if (cts_proto_is_master(cts_cfg.protoh))
 					ct_sync_msg_process_master(msghdr,=20
@@ -1050,12 +1094,36 @@
 			CT_SYNC_ERR("unable to store create event\n");
 			return 1;
 		}
-		fill_ctmsg(buff, CT_SYNC_MSG_UPDATE, ct);
+		fill_ctmsg(buff, CT_SYNC_MSG_UPDATE, ct, CTS_UPD_F_INITSYNC);
 		csb_use_dec(cts_cfg.protoh, csb);
 		(*num)++;
 	}
=20
 	return 0;
+}=20
+
+static int _send_empty_initsync(void)
+{
+	struct cts_buff *csb;
+	struct ct_sync_msghdr *hdr;
+
+	CT_SYNC_ENTER();
+
+	(char *) hdr =3D cts_proto_want_enqueue(cts_cfg.protoh, &csb, CTMSG_SIZEO=
F(0));
+	if (unlikely(!hdr)) {
+		CT_SYNC_ERR("unable to store create event\n");
+		return 1;
+	}
+
+	/* fill event header */
+	hdr->type =3D CT_SYNC_MSG_UPDATE;
+	hdr->resource =3D CT_SYNC_RES_CONNTRACK;
+	hdr->len =3D 0;
+	hdr->flags =3D CTS_UPD_F_INITSYNC;
+
+	csb_use_dec(cts_cfg.protoh, csb);
+
+	return 0;
 }
=20
 /* sync kernel thread: recover */
@@ -1080,6 +1148,7 @@
=20
 	for (;;) {
 		int i;=20
+		int num_sent_total;
=20
 		__set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&ct_sync_initsync_wait, &wait);
@@ -1094,6 +1163,9 @@
 			break;
=20
 		CT_SYNC_INFO("starting initsync dump\n");
+		/* Send master announce in order to assure slave(s)
+		 * learn about current (correct) seqno */
+		cts_proto_master_announce(cts_cfg.protoh);
=20
 		/* speed: 40 conntracks per schedule, 100 schedules per
 		   second: 4000 conntracks per second.  This makes about
@@ -1102,6 +1174,7 @@
 		   see something like 1000 packets per second, or in
 		   other words: 1.5mbits */
=20
+		num_sent_total =3D 0;
 		atomic_set(&ct_sync_initsync_active, 1);
 		for (i =3D 0; i < ip_conntrack_htable_size; i++) {
 			unsigned int num_sent =3D 0;
@@ -1125,12 +1198,20 @@
 			}
 			READ_UNLOCK(&ip_conntrack_lock);
=20
-			CT_SYNC_DEBUG("going to sleep, sent %u\n", num_sent);
+			num_sent_total +=3D num_sent;
+
+			CT_SYNC_DEBUG2("going to sleep, sent %u\n", num_sent);
 			/* schedule until the next bucket */
 			__set_current_state(TASK_INTERRUPTIBLE);
 			schedule_timeout(HZ/100);
 			__set_current_state(TASK_RUNNING);
-			CT_SYNC_DEBUG("woken up\n");
+			CT_SYNC_DEBUG2("woken up\n");
+		}
+		if (!num_sent_total) {
+			/* need to send an empty PKT_SYCN/UPD_F_INITSYNC
+			 * packet in order to provoke state transition
+			 * in slave */
+			_send_empty_initsync();
 		}
 		atomic_set(&ct_sync_initsync_active, 0);
=20
@@ -1171,12 +1252,16 @@
=20
 /* conntrack notify 'create' function */
 static void=20
-ct_sync_create(struct ip_conntrack *ct)
+ct_sync_create(struct ip_conntrack *ct, int new)
 {
 	struct cts_buff *csb;
=20
 	CT_SYNC_ENTER();
=20
+	CTS_STAT_INC(tx.upd_tot);
+	if (new)
+		CTS_STAT_INC(tx.upd_new);
+
 	if (cts_proto_is_master(cts_cfg.protoh)=20
 		   && is_confirmed(ct)
 #ifdef CONFIG_IP_NF_CONNTRACK_MARK
@@ -1194,7 +1279,7 @@
 			CT_SYNC_LEAVE();
 			return;
 		}
-		fill_ctmsg(buff, CT_SYNC_MSG_UPDATE, ct);
+		fill_ctmsg(buff, CT_SYNC_MSG_UPDATE, ct, new ? CTS_UPD_F_NEW:0);
 		csb_use_dec(cts_cfg.protoh, csb);
 	}
=20
@@ -1212,13 +1297,17 @@
 	if (cts_proto_is_master(cts_cfg.protoh)=20
 		   && is_confirmed(ct)
 #ifdef CONFIG_IP_NF_CONNTRACK_MARK
-		   /* generate a message only if the conntrack is synchronized */
+		   /* generate a message only if the conntrack is to be
+		    * synchronized */
 		   && test_bit(cmarkbit, &ct->mark)
 #endif
 	) {
 		unsigned char *buff;
 		struct ct_sync_msghdr *hdr;
 		struct ip_conntrack_tuple *t;
+
+		CTS_STAT_INC(tx.del_tot);
+
 		buff =3D cts_proto_want_enqueue(cts_cfg.protoh, &csb,
 				CTMSG_SIZEOF(*t));
 		if (unlikely(!buff)) {
@@ -1307,20 +1396,20 @@
 ct_sync_notify(struct notifier_block *this,
 	       unsigned long events, void *ct)
 {
-	//CT_SYNC_ENTER();
-
 	if ((struct ip_conntrack *)ct =3D=3D &ip_conntrack_untracked)
 		return NOTIFY_DONE;
=20
-	if (events & (EVENT(IPCT_NEW) | EVENT(IPCT_STATUS) | EVENT(IPCT_PROTOINFO=
) |
+	if (events & EVENT(IPCT_NEW)) {
+		ct_sync_create((struct ip_conntrack *)ct, 1);
+
+	} else if (events & (EVENT(IPCT_STATUS) | EVENT(IPCT_PROTOINFO) |
 		      EVENT(IPCT_HELPINFO) | EVENT(IPCT_NATINFO))) {
-		CT_SYNC_DEBUG("event: %ld\n", events);
-		ct_sync_create((struct ip_conntrack *)ct);
-	}
-	else if (events & EVENT(IPCT_DESTROY))
+		ct_sync_create((struct ip_conntrack *)ct, 0);
+
+	} else if (events & EVENT(IPCT_DESTROY)) {
 		ct_sync_destroy((struct ip_conntrack *)ct);
=20
-	//CT_SYNC_LEAVE();
+	}
=20
 	return NOTIFY_DONE;
 }
@@ -1424,6 +1513,7 @@
 	CT_SYNC_ENTER();
=20
 	if ((state =3D=3D 0) && cts_proto_is_master(cts_cfg.protoh)) {
+		CTS_STAT_INC(master2slave);
 		CT_SYNC_ERR("cannot switch active master to client!\n");
 		CT_SYNC_LEAVE();
 		return -EINVAL;
@@ -1552,6 +1642,93 @@
 }
=20
 /***********************************************************************
+ * STATISTICS
+ ***********************************************************************/
+
+static void *cts_stat_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	int lcpu;
+
+	if (*pos =3D=3D 0)
+		return SEQ_START_TOKEN;
+
+	for (lcpu =3D *pos-1; lcpu < smp_num_cpus; ++lcpu) {
+		int i =3D cpu_logical_map(lcpu);
+		*pos =3D lcpu+1;
+		return &ct_sync_stats[i];
+	}
+	return NULL;
+}
+
+static void *cts_stat_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+{
+	int lcpu;
+=09
+	for (lcpu =3D *pos; lcpu < smp_num_cpus; ++lcpu) {
+		int i =3D cpu_logical_map(lcpu);
+		*pos =3D lcpu+1;
+		return &ct_sync_stats[i];
+	}
+	return NULL;
+}
+
+static void cts_stat_seq_stop(struct seq_file *seq, void *v)
+{
+}
+
+static void cts_stat_seq_show_st(struct seq_file *seq, struct ct_sync_st *=
s)
+{
+	seq_printf(seq, "%lu %lu %lu %lu %lu %lu %lu "
+			"%lu %lu %lu %lu %lu %lu %lu  ",
+		   s->pkts_tot, s->pkts_ooseq, s->pkts_recover,
+		   s->msgs, s->error,
+		   s->upd_tot, s->upd_new, s->upd_initial,
+		   s->upd_newbutexist, s->upd_nothere,
+		   s->del_tot, s->del_nothere,
+		   s->exp_upd_tot, s->exp_del_tot);
+}
+
+static int cts_stat_seq_show(struct seq_file *seq, void *v)
+{
+	struct ct_sync_stat *stats =3D v;
+
+	if (v =3D=3D SEQ_START_TOKEN) {
+		seq_printf(seq, "tx_pkts_tot tx_pkts_ooseq tx_pkts_recover tx_msgs tx_er=
ror tx_upd_tot tx_upd_new tx_upd_initial tx_upd_newbutexist tx_upd_nothere =
tx_del_tot tx_del_nothere tx_exp_upd_tot tx_exp_del_tot  ");
+		seq_printf(seq, "rx_pkts_tot rx_pkts_ooseq rx_pkts_recover rx_msgs rx_er=
ror rx_upd_tot rx_upd_new rx_upd_initial rx_upd_newbutexist rx_upd_nothere =
rx_del_tot rx_del_nothere rx_exp_upd_tot rx_exp_del_tot  ");
+		seq_printf(seq, "slave2master master2slave master2slave_auto initsyncs\n=
");
+		return 0;
+	}
+
+	cts_stat_seq_show_st(seq, &stats->tx);
+	cts_stat_seq_show_st(seq, &stats->rx);
+	seq_printf(seq, "%lu %lu %lu %lu\n",=20
+		   stats->slave2master, stats->master2slave,
+		   stats->master2slave_auto, stats->initsyncs);
+	return 0;
+}
+
+static struct seq_operations cts_stat_seq_ops =3D {
+	.start  =3D cts_stat_seq_start,
+	.next   =3D cts_stat_seq_next,
+	.stop   =3D cts_stat_seq_stop,
+	.show   =3D cts_stat_seq_show,
+};
+
+static int cts_stat_seq_open(struct inode *inode, struct file *file)
+{
+	return seq_open(file, &cts_stat_seq_ops);
+}
+
+static struct file_operations cts_stat_seq_fops =3D {
+       .owner   =3D THIS_MODULE,
+       .open    =3D cts_stat_seq_open,
+       .read    =3D seq_read,
+       .llseek  =3D seq_lseek,
+       .release =3D seq_release,
+};
+
+
+/***********************************************************************
  * MODULE INITIALIZATION
  ***********************************************************************/
=20
@@ -1564,16 +1741,22 @@
 	DECLARE_WAITQUEUE(wait, current);
 	DECLARE_COMPLETION(ct_thread_comp);
 	struct net_device *sync_netdev;
+	struct proc_dir_entry *ct_sync_stat;
=20
 	if (fini)
 		goto cleanup;
=20
 	/* informational messages */
-	CT_SYNC_DEBUG("ip_ct_tuple: %d bytes\n", sizeof(struct ip_conntrack_tuple=
));
-	CT_SYNC_DEBUG("ct_sync_conntrack: %d bytes\n", sizeof(struct ct_sync_conn=
track));
-	CT_SYNC_DEBUG("ct_sync_expect: %d bytes\n", sizeof(struct ct_sync_expect)=
);
-	CT_SYNC_DEBUG("ct_sync_pkthdr: %d bytes\n", sizeof(struct ct_sync_pkthdr)=
);
-	CT_SYNC_DEBUG("ct_sync_msghdr: %d bytes\n", sizeof(struct ct_sync_msghdr)=
);
+	CT_SYNC_DEBUG("ip_ct_tuple: %d bytes\n",=20
+			sizeof(struct ip_conntrack_tuple));
+	CT_SYNC_DEBUG("ct_sync_conntrack: %d bytes\n",=20
+			sizeof(struct ct_sync_conntrack));
+	CT_SYNC_DEBUG("ct_sync_expect: %d bytes\n",=20
+			sizeof(struct ct_sync_expect));
+	CT_SYNC_DEBUG("ct_sync_pkthdr: %d bytes\n",=20
+			sizeof(struct ct_sync_pkthdr));
+	CT_SYNC_DEBUG("ct_sync_msghdr: %d bytes\n",=20
+			sizeof(struct ct_sync_msghdr));
 	CT_SYNC_DEBUG("cmarkbit: %d\n", cmarkbit);
 	if (id =3D=3D -1) {
 		CT_SYNC_ERR("Required parameter id is missing.\n");
@@ -1584,7 +1767,8 @@
 		return -1;
 	}
 	if (state =3D=3D -1) {
-		CT_SYNC_ERR("Required parameter state is missing; give 1 for master and =
0 for slave.\n");
+		CT_SYNC_ERR("Required parameter state is missing; "
+			    " give 1 for master and 0 for slave.\n");
 		return -1;
 	}
 	if (state !=3D 0 && state !=3D 1) {
@@ -1596,14 +1780,16 @@
 	strcpy(cts_cfg.devname, syncdev);
 	cts_cfg.addr.sin_family =3D AF_INET;
 	cts_cfg.addr.sin_port =3D __constant_htons(1999);
-	cts_cfg.addr.sin_addr.s_addr =3D __constant_htonl(0xe0000052); /* 224.0.0=
=2E82 */
+	cts_cfg.addr.sin_addr.s_addr =3D=20
+			__constant_htonl(0xe0000052); /* 224.0.0.82 */
=20
 	/* Get ifindex of the sync device, used by the l2drop hook */
 	if ((sync_netdev =3D dev_get_by_name(cts_cfg.devname)) !=3D NULL) {
 		cts_cfg.ifindex =3D sync_netdev->ifindex;
 		dev_put(sync_netdev);
 	} else {
-		CT_SYNC_ERR("Lookup for network interface '%s' failed\n", cts_cfg.devnam=
e);
+		CT_SYNC_ERR("Lookup for network interface '%s' failed\n",=20
+			    cts_cfg.devname);
 		return -1;
 	}
=20
@@ -1636,6 +1822,13 @@
 	if (ct_sync_sysctl_header =3D=3D NULL)
 		goto error_hook3;
=20
+	/* register statistics */
+	ct_sync_stat =3D create_proc_entry("ct_sync", 0, proc_net_stat);
+	printk("proc_net_stat=3D%p, ct_sync_stat=3D%p\n", proc_net_stat, ct_sync_=
stat);
+	if (!ct_sync_stat)
+		goto error_proc;
+	ct_sync_stat->proc_fops =3D &cts_stat_seq_fops;
+
 	/* start threads */
 	startup.completion =3D &ct_thread_comp;
 	startup.function =3D ct_sync_send_thread_main;
@@ -1643,7 +1836,7 @@
 	{
 		CT_SYNC_ERR("Failed to start fork thread.\n");
 		ret =3D pid;
-		goto error_proc;
+		goto error_stat;
 	}
 	if ((ret =3D waitpid(pid, NULL, __WCLONE)) !=3D pid)
 	{
@@ -1745,6 +1938,8 @@
 	schedule();
 	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&stop_ct_send_thread_wait, &wait);
+error_stat:
+	remove_proc_entry("ct_sync_stat", proc_net_stat);
 error_proc:
 	CT_SYNC_DEBUG("removing sysctl entry\n");
 	unregister_sysctl_table(ct_sync_sysctl_header);
diff --exclude .svn -Nru netfilter-ha/ct_sync/ct_sync_proto.c ct_sync-2/ct_=
sync_proto.c
--- netfilter-ha/ct_sync/ct_sync_proto.c	2004-10-10 13:41:21.000000000 +0200
+++ ct_sync-2/ct_sync_proto.c	2004-10-14 20:54:35.951307472 +0200
@@ -9,7 +9,7 @@
  * it under the terms of the GNU General Public License version 2 as
  * published by the Free Software Foundation.
  *
- * $Id: ct_sync_proto.c 1521 2004-08-30 11:05:46Z hidden $
+ * $Id: ct_sync_proto.c,v 1.39 2004/08/30 11:05:46 hidden Exp $
  *
  */
=20
@@ -109,6 +109,11 @@
 			cts_proto_statenames[state]);
 }
=20
+char *cts_proto_get_state_name(struct cts_protoh *cph)
+{
+	return cts_proto_statenames[atomic_read(&cph->state)];
+}
+
 /***********************************************************************
  * CTS_BUFF / CSB_RING util functions
  ***********************************************************************/
@@ -116,7 +121,7 @@
 csb_hdr_fill(struct cts_protoh *cph, struct ct_sync_pkthdr *hdr,=20
 	     __u8 type, __u16 seq)
 {
-	hdr->version =3D 1;
+	hdr->version =3D 2;
 	hdr->pkttype =3D type;
 	hdr->pktseq =3D htons(seq);
 	hdr->node_id =3D cph->nodeid;
@@ -333,7 +338,7 @@
=20
=20
 /* we have just been told to become master; tell other nodes */
-static int
+int
 cts_proto_master_announce(struct cts_protoh *cph)
 {
 	size_t len;
@@ -344,8 +349,11 @@
=20
 	CT_SYNC_ENTER();
=20
+	CT_SYNC_DEBUG("sending master_announce with seqno=3D%u\n",
+		      cph->send.ring.seqno);
+
 	csb_hdr_fill(cph, &pkt.hdr, CT_SYNC_PKT_MASTER_ANNOUNCE,=20
-		     cph->send.ring.seqno++);
+		     cph->send.ring.seqno);
=20
 	/* FIXME: wraps every five days */
 	pkt.ma.upsince =3D htonl(jiffies);
@@ -369,6 +377,8 @@
 {
 	CT_SYNC_ENTER();
=20
+	CTS_STAT_INC(slave2master);
+
 	set_state(cph, CT_SYNC_PSTATE_MASTER_INIT);
=20
 	if (unlikely(cts_proto_master_announce(cph) < 0)) {
@@ -411,7 +421,6 @@
 	return 0;
 }
=20
-/* we have just started as new slave, request initial sync from master */
 int
 cts_proto_request_initsync(struct cts_protoh *cph)
 {
@@ -423,15 +432,23 @@
=20
 	CT_SYNC_ENTER();
=20
-	set_state(cph, CT_SYNC_PSTATE_SLAVE_INIT);
+	if (atomic_read(&cph->state) !=3D CT_SYNC_PSTATE_SLAVE_INIT) {
+		CT_SYNC_DEBUG("not sending initsync request from wrong state\n");
+		CT_SYNC_LEAVE();
+		return 0;
+	}
+=09
+	CTS_STAT_INC(initsyncs);
+
+	CT_SYNC_DEBUG("sending INITSYNC request\n");
=20
 	csb_hdr_fill(cph, &pkt.hdr, CT_SYNC_PKT_SLAVE_INITSYNC, 0);
-
 	pkt.is.master =3D 0;
=20
-	len =3D cts_sock_send(cph->send.socket, (unsigned char *)&pkt, sizeof(pkt=
));
+	len =3D cts_sock_send(cph->send.socket, (unsigned char*)&pkt, sizeof(pkt)=
);
 	if (unlikely(len < sizeof(pkt))) {
-		CT_SYNC_ERR("Send failed, returned %d.\n", len);
+		CT_SYNC_ERR("Send failed, only sent %d of %u.\n",
+			    len, sizeof(pkt));
 		CT_SYNC_LEAVE();
 		return -1;
 	}
@@ -441,6 +458,24 @@
 	return 0;
 }
=20
+int
+cts_proto_initsync_retransmit(struct cts_protoh *cph)
+{
+	static unsigned long last_initsync;
+
+	if (atomic_read(&cph->state) =3D=3D CT_SYNC_PSTATE_NONE)
+		atomic_set(&cph->state, CT_SYNC_PSTATE_SLAVE_INIT);
+
+	/* if we are waiting for a reply to an initial sync,
+	 * retransmit request */
+	if (atomic_read(&cph->state) =3D=3D CT_SYNC_PSTATE_SLAVE_INIT
+	    && jiffies >=3D last_initsync + 5*HZ) {
+		cts_proto_request_initsync(cph);
+		last_initsync =3D jiffies;
+	}
+	return 0;
+}
+
 /* protocol has detected another master.  we have to tell our user
  * that we just became slave */
 static void
@@ -448,6 +483,8 @@
 {
 	CT_SYNC_ENTER();
=20
+	CTS_STAT_INC(master2slave_auto);
+
 	set_state(cph, CT_SYNC_PSTATE_SLAVE_RUNNING);
 	if (likely(cph->became_slave !=3D NULL))
 		cph->became_slave(cph, cph->became_slave_arg);
@@ -613,7 +650,7 @@
=20
 	csb_use_inc(tmp);
 =09
-	CT_SYNC_DEBUG("using buffer %p: ", tmp);
+	CT_SYNC_DEBUG2("using buffer %p: ", tmp);
 	DUMP_CTS_BUFF(tmp);
=20
 	/* increment msg count in packet */
@@ -663,7 +700,7 @@
 	if (cph->send.ring.sent =3D=3D cph->send.ring.cur) {
 		spin_unlock(&cph->send.ring.lock);
 		/* no pending entries to be sent */
-		CT_SYNC_DEBUG("no pending entries to be sent, returning\n");
+		CT_SYNC_DEBUG2("no pending entries to be sent, returning\n");
 		CT_SYNC_LEAVE();
 		return -2;
 	}
@@ -673,7 +710,7 @@
=20
 	if (likely(cts_proto_is_master(cph))) {
 		/* send packet */
-		CT_SYNC_DEBUG("sending csb=3D%p, len=3D%u\n", csb, csb_len(csb));
+		CT_SYNC_DEBUG2("sending csb=3D%p, len=3D%u\n", csb, csb_len(csb));
 		len =3D cts_sock_send(cph->send.socket, (char *) &csb->pkt,=20
 				    csb_len(csb));
 		if (len < csb_len(csb)) {
@@ -783,6 +820,7 @@
 			CT_SYNC_DEBUG("failed to dup csb\n");
 			continue;
 		}
+		ncsb->pkt.hdr.flags |=3D CT_SYNC_PKT_F_RECOVER;
 		list_add(&ncsb->list, &q);
 	}
=20
@@ -791,6 +829,8 @@
 	list_for_each_safe(i, t, &q) {
 		struct cts_buff *csb =3D (struct cts_buff *) i;
=20
+		CTS_STAT_INC(tx.pkts_recover);
+
 		/* resend packet */
 		size_t len =3D cts_sock_send(cph->send.socket, (char *) &csb->pkt,=20
 					csb_len(csb));
@@ -955,6 +995,7 @@
 				sizeof(struct ct_sync_pkthdr));
 		goto done_ignore;
 	}
+=09
 	/* tail points to last byte of received data */
 	csb->tail =3D (char *)&csb->pkt + len;
 	csb->parsed =3D (char *)&csb->pkt.data[0];
@@ -962,12 +1003,15 @@
 	CT_SYNC_DEBUG("filled csb: %p: ", csb);
 	DUMP_CTS_BUFF(csb);
=20
-	if (unlikely(csb->pkt.hdr.version !=3D 1)) {
+	if (unlikely(csb->pkt.hdr.version !=3D 2)) {
 		CT_SYNC_ERR("invalid protocol version %u\n",=20
 			    csb->pkt.hdr.version);
 		goto done_ignore;
 	}
=20
+	if (csb->pkt.hdr.flags & CT_SYNC_PKT_F_RECOVER)
+		CTS_STAT_INC(rx.pkts_recover);
+
 	switch (csb->pkt.hdr.pkttype) {
 		__u16 recover_seq;
=20
@@ -978,9 +1022,13 @@
 			/* do we really want to accept sync pkts before we
 			 * requested them? For now, fallthrough */
 		case CT_SYNC_PSTATE_SLAVE_SYNSENT:
+			break;
 			/* set initial seqno */
-			csr->seqno =3D ntohs(csb->pkt.hdr.pktseq) - 1;
-			set_state(cph, CT_SYNC_PSTATE_SLAVE_SYNRECV);
+			//csr->seqno =3D ntohs(csb->pkt.hdr.pktseq) - 1;
+			csr->seqno =3D ntohs(csb->pkt.hdr.pktseq);
+			printk(KERN_DEBUG "setting initial seqno to %u\n",
+				csr->seqno);
+			set_state(cph, CT_SYNC_PSTATE_SLAVE_SYNRECV);
 			break;
 		case CT_SYNC_PSTATE_SLAVE_SYNRECV:
 		case CT_SYNC_PSTATE_SLAVE_RUNNING:
@@ -995,16 +1043,22 @@
 					(__u16)((csr->seqno + 1) & 0xffff))) {
 			int sdiff;
=20
-			CT_SYNC_INFO("received out-of-sequence sync pkt (rcv:%u, exp:%u)\n",
+			CTS_STAT_INC(rx.pkts_ooseq);
+
+			CT_SYNC_INFO("received out-of-sequence sync pkt "
+				     "(rcv:%u, exp:%u)\n",
 				     ntohs(csb->pkt.hdr.pktseq), csr->seqno+1);
-			sdiff =3D cts_seqno_cmp(ntohs(csb->pkt.hdr.pktseq), csr->seqno);
+			sdiff =3D cts_seqno_cmp(ntohs(csb->pkt.hdr.pktseq),=20
+					      csr->seqno);
=20
 			if (sdiff > 0) {
 				/* we have lost some packages, try to recover */
-				cts_proto_request_recovery(cph, csr->seqno, sdiff);
+				cts_proto_request_recovery(cph, csr->seqno,=20
+							   sdiff);
 			} else {
 				/* we've already seen this, let's drop it */
-				CT_SYNC_DEBUG("dropping duplicate, diff %d\n", sdiff);
+				CT_SYNC_DEBUG("dropping duplicate, diff %d\n",=20
+					      sdiff);
 			}
 			goto done_ignore;
 		} else {
@@ -1049,7 +1103,13 @@
 		default:
 			/* we have a new master, we have to update our receiver's
 			 * sequence number */
-			CT_SYNC_INFO("received master announcement while being client; staying =
cool\n");
+			CT_SYNC_INFO("received master announcement, "
+				     "setting initial seqno to %u\n",=20
+				     csr->seqno);
+			/* csr->seqno is last received seqno, thus we expect
+			 * csr->seqno+1 in next SYNC packet. Sender tells us
+			 * the sequence number it is about to send with the
+			 * next packet, so we need to subtract 1 ?!?  */
 			csr->seqno =3D ntohs(csb->pkt.hdr.pktseq);
 			break;
 		}
@@ -1075,6 +1135,7 @@
 		break;
=20
 	case CT_SYNC_PKT_INITSYNC_FOLLOWS:
+#if 0
 		switch (atomic_read(&cph->state)) {
 		case CT_SYNC_PSTATE_MASTER_INIT:
 		case CT_SYNC_PSTATE_MASTER_ADVSENT:
@@ -1092,6 +1153,7 @@
 			set_state(cph, CT_SYNC_PSTATE_SLAVE_INIT);
 			break;
 		}
+#endif
 		goto done_ignore;
 		break;
=20
@@ -1181,9 +1243,16 @@
 		break;
 	}
=20
+	CT_SYNC_ASSERT(msghdr);
+
 	csr_print(csr);
 	spin_unlock(&csr->lock);
=20
+	if (unlikely(msghdr->type =3D=3D CT_SYNC_MSG_UPDATE
+	             && msghdr->flags & CTS_UPD_F_INITSYNC
+		     && atomic_read(&cph->state) =3D=3D CT_SYNC_PSTATE_SLAVE_INIT))
+		set_state(cph, CT_SYNC_PSTATE_SLAVE_SYNRECV);
+
 	CT_SYNC_LEAVE();
=20
 	return msghdr;
diff --exclude .svn -Nru netfilter-ha/ct_sync/ct_sync_proto.h ct_sync-2/ct_=
sync_proto.h
--- netfilter-ha/ct_sync/ct_sync_proto.h	2004-10-10 13:41:21.000000000 +0200
+++ ct_sync-2/ct_sync_proto.h	2004-10-14 20:54:38.036990400 +0200
@@ -23,11 +23,14 @@
 /* tell protocol to make local node master */
 int cts_proto_become_master(struct cts_protoh *cph);
=20
+int cts_proto_master_announce(struct cts_protoh *cph);
+
 /* signal that an initsync is to follow */
 int cts_proto_initsync_follows(struct cts_protoh *cph);
=20
 /* request initial re-sync from master */
 int cts_proto_request_initsync(struct cts_protoh *cph);
+int cts_proto_initsync_retransmit(struct cts_protoh *cph);
=20
 /* SENDER */
=20
diff --exclude .svn -Nru netfilter-ha/ct_sync/ct_sync_sock.c ct_sync-2/ct_s=
ync_sock.c
--- netfilter-ha/ct_sync/ct_sync_sock.c	2004-10-10 13:41:21.000000000 +0200
+++ ct_sync-2/ct_sync_sock.c	2004-10-14 20:54:35.996300632 +0200
@@ -212,6 +212,8 @@
=20
 	CT_SYNC_ENTER();
=20
+	CTS_STAT_INC(tx.pkts_tot);
+
 	oldfs =3D get_fs(); set_fs(KERNEL_DS);
 	len =3D sock_sendmsg(sock, msg, length);
 	set_fs(oldfs);
@@ -261,6 +263,8 @@
=20
 	CT_SYNC_ENTER();
=20
+	CTS_STAT_INC(rx.pkts_tot);
+
 	iov.iov_base	=3D buffer;
 	iov.iov_len	=3D buflen;
 	msg.msg_name	=3D 0;
diff --exclude .svn -Nru netfilter-ha/ct_sync/cts_buff.h ct_sync-2/cts_buff=
=2Eh
--- netfilter-ha/ct_sync/cts_buff.h	2004-10-10 13:41:21.000000000 +0200
+++ ct_sync-2/cts_buff.h	2004-10-14 20:54:38.039989944 +0200
@@ -107,7 +107,7 @@
 	return (csb->tail - (char *) &csb->pkt);
 }
=20
-static inline void csb_use_inc(const struct cts_buff *csb)
+static inline void csb_use_inc(struct cts_buff *csb)
 {
 	atomic_inc(&csb->use);
 }

--=20
- Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie

--RMedoP2+Pr6Rq0N2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBbtCHXaXGVTD0i/8RAn5rAJ9UY49HXvGuH71UXKLJoseHdvfspACgpndb
x+DbTsfNEQSRkz/Ws1vtJzo=
=mdIN
-----END PGP SIGNATURE-----

--RMedoP2+Pr6Rq0N2--
