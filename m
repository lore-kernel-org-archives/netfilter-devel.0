From: Patrick McHardy <kaber@trash.net>
Subject: [RFC] updated ctnetlink patches: connmark.diff/ctsynd.c
Date: Wed, 28 May 2003 15:46:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ED4BDB5.1000205@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000407070303020906030208"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------000407070303020906030208
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit



--------------000407070303020906030208
Content-Type: text/plain;
 name="connmark.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="connmark.diff"

# This is a BitKeeper generated patch for the following project:
# Project Name: Linux kernel tree
# This patch format is intended for GNU patch command version 2.5 or higher.
# This patch includes the following deltas:
#	           ChangeSet	1.1229  -> 1.1230 
#	net/ipv4/netfilter/ipt_CONNMARK.c	1.1     -> 1.2    
#
# The following is the BitKeeper ChangeSet Log
# --------------------------------------------
# 03/05/27	kaber@trash.net	1.1230
# CONNMARK changes for conntrack event notifications
# --------------------------------------------
#
diff -Nru a/net/ipv4/netfilter/ipt_CONNMARK.c b/net/ipv4/netfilter/ipt_CONNMARK.c
--- a/net/ipv4/netfilter/ipt_CONNMARK.c	Tue May 27 19:25:03 2003
+++ b/net/ipv4/netfilter/ipt_CONNMARK.c	Tue May 27 19:25:03 2003
@@ -19,16 +19,21 @@
        void *userinfo)
 {
 	const struct ipt_connmark_target_info *markinfo = targinfo;
-
 	enum ip_conntrack_info ctinfo;
 	struct ip_conntrack *ct = ip_conntrack_get((*pskb), &ctinfo);
+	unsigned long oldmark = ct->mark;
+
 	if (ct) {
 	    switch(markinfo->mode) {
 	    case IPT_CONNMARK_SET:
 		ct->mark = markinfo->mark;
+		if (oldmark != ct->mark)
+			ip_conntrack_event(IPCT_MARK, ct);
 		break;
 	    case IPT_CONNMARK_SAVE:
 		ct->mark = (*pskb)->nfmark;
+		if (oldmark != ct->mark)
+			ip_conntrack_event(IPCT_MARK, ct);
 		break;
 	    case IPT_CONNMARK_RESTORE:
 		if (ct->mark != (*pskb)->nfmark) {

--------------000407070303020906030208
Content-Type: text/x-csrc;
 name="ctsyncd.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctsyncd.c"

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include <time.h>
#include <errno.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <sys/uio.h>
#include <asm/types.h>
#include <linux/if.h>
#include <linux/netlink.h>
#include <linux/netfilter_ipv4/ip_nat.h>
#include <linux/netfilter_ipv4/ip_tables.h>
#include <linux/netfilter_ipv4/ip_conntrack.h>
#include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
#include <linux/netfilter_ipv4/ip_conntrack_ftp.h>
#include <linux/netfilter_ipv4/ip_conntrack_icmp.h>
#include <linux/netfilter_ipv4/ip_conntrack_tuple.h>
#include <linux/nfnetlink_conntrack.h>

#include "libctnetlink.h"

#define NETLINK_SOCKBUFSZ	1<<20

int accept_msg(struct sockaddr_nl *who, struct nlmsghdr *n, void *arg)
{
	int udp_sock = *(int *)arg;

	if (send(udp_sock, n, n->nlmsg_len, 0) < 0)
		perror("send\n");

	return 0;
}

int main(int argc, char **argv)
{
	struct nfnl_handle nlh;
	struct sockaddr_in sin;
	int sock_buf_size = NETLINK_SOCKBUFSZ;
	int udp_sock;

	if (argc < 2) {
		fprintf(stderr, "Usage: %s [ <ip> | listen ]\n", argv[0]);
		exit(1);
	}

	if (nfnl_open(&nlh, NFNL_SUBSYS_CTNETLINK, ~NFGRP_IPV4_CT_UDP)) {
		perror("nfnl_open\n");
		exit(1);
	}

	if ((udp_sock = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP)) < 0) {
		perror("socket\n");
		exit(1);
	}

	sin.sin_family = AF_INET;
	sin.sin_port = htons(10000);

	if (strncmp(argv[1], "listen", sizeof("listen")) == 0) {
		char buf[4000];
		struct nlmsghdr *n = (struct nlmsghdr *)buf;
		int len;
		
		sin.sin_addr.s_addr = 0;
		if (bind(udp_sock, (struct sockaddr *)&sin, sizeof(sin)) < 0) {
			perror("bind\n");
			exit(1);
		}

		while ((len = recv(udp_sock, &buf, sizeof(buf), 0))) {
			n->nlmsg_flags = NLM_F_REQUEST|NLM_F_CREATE|NLM_F_EXCL;
			if (nfnl_send(&nlh, n) < 0)
				perror("nfnl_send\n");
		}
		exit(0);
	}

	if (setsockopt(nlh.fd, SOL_SOCKET, SO_RCVBUF,
	               (const char *)&sock_buf_size, sizeof(int)) < 0) {
		perror("setsockopt\n");
		exit(1);
	}

	inet_aton(argv[1],&sin.sin_addr.s_addr);

	if (connect(udp_sock, (struct sockaddr *)&sin, sizeof(sin)) < 0) {
		perror("connect\n");
		exit(1);
	}

	if (nfnl_listen(&nlh, accept_msg, &udp_sock) < 0) {
		perror("nfnl_listen\n");
		exit(1);
	}
}

--------------000407070303020906030208--
