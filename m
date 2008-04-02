From: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: [PATCH] NETFILTER:  Remove superfluous __KERNEL__ tests from unexported
 headers.
Date: Wed, 2 Apr 2008 09:48:13 -0400 (EDT)
Message-ID: <alpine.LFD.1.00.0804020946430.18913@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from astoria.ccjclearline.com ([64.235.106.9]:53681 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752563AbYDBNsS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Apr 2008 09:48:18 -0400
Received: from cpe001d60ad7267-cm001225dbafb6.cpe.net.cable.rogers.com ([99.236.100.208] helo=crashcourse.ca)
	by astoria.ccjclearline.com with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.68)
	(envelope-from <rpjday@crashcourse.ca>)
	id 1Jh3K4-00022I-At
	for netfilter-devel@vger.kernel.org; Wed, 02 Apr 2008 09:48:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

 include/linux/netfilter/nf_conntrack_h323.h      |    4 ----
 include/linux/netfilter/nf_conntrack_irc.h       |    3 ---
 include/linux/netfilter/nf_conntrack_pptp.h      |    3 ---
 include/linux/netfilter/nf_conntrack_proto_gre.h |    2 --
 include/linux/netfilter/nf_conntrack_sane.h      |    4 ----
 include/linux/netfilter/nf_conntrack_sip.h       |    2 --
 6 files changed, 18 deletions(-)

diff --git a/include/linux/netfilter/nf_conntrack_h323.h b/include/linux/netfilter/nf_conntrack_h323.h
index 26f9226..6d4ddd5 100644
--- a/include/linux/netfilter/nf_conntrack_h323.h
+++ b/include/linux/netfilter/nf_conntrack_h323.h
@@ -1,8 +1,6 @@
 #ifndef _NF_CONNTRACK_H323_H
 #define _NF_CONNTRACK_H323_H

-#ifdef __KERNEL__
-
 #include <linux/netfilter/nf_conntrack_h323_asn1.h>

 #define RAS_PORT 1719
@@ -88,5 +86,3 @@ extern int (*nat_q931_hook) (struct sk_buff *skb, struct nf_conn *ct,
 			     struct nf_conntrack_expect *exp);

 #endif
-
-#endif
diff --git a/include/linux/netfilter/nf_conntrack_irc.h b/include/linux/netfilter/nf_conntrack_irc.h
index 36282bf..99a2cdb 100644
--- a/include/linux/netfilter/nf_conntrack_irc.h
+++ b/include/linux/netfilter/nf_conntrack_irc.h
@@ -1,8 +1,6 @@
 #ifndef _NF_CONNTRACK_IRC_H
 #define _NF_CONNTRACK_IRC_H

-#ifdef __KERNEL__
-
 #define IRC_PORT	6667

 extern unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
@@ -11,5 +9,4 @@ extern unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
 				       unsigned int matchlen,
 				       struct nf_conntrack_expect *exp);

-#endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_IRC_H */
diff --git a/include/linux/netfilter/nf_conntrack_pptp.h b/include/linux/netfilter/nf_conntrack_pptp.h
index 3bbde0c..12efb31 100644
--- a/include/linux/netfilter/nf_conntrack_pptp.h
+++ b/include/linux/netfilter/nf_conntrack_pptp.h
@@ -44,8 +44,6 @@ struct nf_nat_pptp {
 	__be16 pac_call_id;			/* NAT'ed PAC call id */
 };

-#ifdef __KERNEL__
-
 #define PPTP_CONTROL_PORT	1723

 #define PPTP_PACKET_CONTROL	1
@@ -320,5 +318,4 @@ extern void
 (*nf_nat_pptp_hook_expectfn)(struct nf_conn *ct,
 			     struct nf_conntrack_expect *exp);

-#endif /* __KERNEL__ */
 #endif /* _NF_CONNTRACK_PPTP_H */
diff --git a/include/linux/netfilter/nf_conntrack_proto_gre.h b/include/linux/netfilter/nf_conntrack_proto_gre.h
index 535e421..082974b 100644
--- a/include/linux/netfilter/nf_conntrack_proto_gre.h
+++ b/include/linux/netfilter/nf_conntrack_proto_gre.h
@@ -69,7 +69,6 @@ struct nf_ct_gre {
 	unsigned int timeout;
 };

-#ifdef __KERNEL__
 #include <net/netfilter/nf_conntrack_tuple.h>

 struct nf_conn;
@@ -90,5 +89,4 @@ void nf_ct_gre_keymap_destroy(struct nf_conn *ct);
 extern void nf_ct_gre_keymap_flush(void);
 extern void nf_nat_need_gre(void);

-#endif /* __KERNEL__ */
 #endif /* _CONNTRACK_PROTO_GRE_H */
diff --git a/include/linux/netfilter/nf_conntrack_sane.h b/include/linux/netfilter/nf_conntrack_sane.h
index 4767d6e..1c8c4f7 100644
--- a/include/linux/netfilter/nf_conntrack_sane.h
+++ b/include/linux/netfilter/nf_conntrack_sane.h
@@ -2,8 +2,6 @@
 #define _NF_CONNTRACK_SANE_H
 /* SANE tracking. */

-#ifdef __KERNEL__
-
 #define SANE_PORT	6566

 enum sane_state {
@@ -16,6 +14,4 @@ struct nf_ct_sane_master {
 	enum sane_state state;
 };

-#endif /* __KERNEL__ */
-
 #endif /* _NF_CONNTRACK_SANE_H */
diff --git a/include/linux/netfilter/nf_conntrack_sip.h b/include/linux/netfilter/nf_conntrack_sip.h
index 8e5ce1c..4aee42b 100644
--- a/include/linux/netfilter/nf_conntrack_sip.h
+++ b/include/linux/netfilter/nf_conntrack_sip.h
@@ -1,6 +1,5 @@
 #ifndef __NF_CONNTRACK_SIP_H__
 #define __NF_CONNTRACK_SIP_H__
-#ifdef __KERNEL__

 #define SIP_PORT	5060
 #define SIP_TIMEOUT	3600
@@ -37,5 +36,4 @@ extern int ct_sip_lnlen(const char *line, const char *limit);
 extern const char *ct_sip_search(const char *needle, const char *haystack,
 				 size_t needle_len, size_t haystack_len,
 				 int case_sensitive);
-#endif /* __KERNEL__ */
 #endif /* __NF_CONNTRACK_SIP_H__ */


========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
