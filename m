From: ruby joker <ruby.joker@op.pl>
Subject: ipt_ULOG delays packets caught by filter
Date: Wed, 23 Jun 2004 23:20:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040623212051.GA202@wonderland>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="dDRMvlgZJXvWKvBx"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline

Harald is a bit busy, so I'm sending this to list, so maybe someone can
check it.

When a packet hits ULOG target, it's stored in a buffer regardless of
qthreshold value. It is copied to userspace only when another packet
arrives (so it will 'push' the queved one) or flushtimeout time will
pass. Delaying packets in logging utility isn't a good idea.

I've attached test code (test.c) if you want to reproduce this
behaviour. It opens a netlink socket and report any packet received.
Before running test, add a rule to netfilter, so that all tcp packets
are caught, like this:
  # iptables -A INPUT -p tcp -j ULOG
  (qthreshold is 1 for default)
Now generate few tcp packets, by using simply:
  $ telnet localhost
By running tcpdump simultaneously you'll notice one packet is lost, when
others are reported at time. Lost packet will be send via netlink 10
secs after last in a row (because of default flushtimeout value).

I'm proposing a patch based on Linux 2.6.6. Any comments welcome.

rj

--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="test.c"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <time.h>
#include <sys/socket.h>
#include <asm/types.h>
#include <linux/netlink.h>


int main(int argc, char *argv[])
{
	struct msghdr hdr;
	struct sockaddr_nl addr;
	struct iovec msg;
	int s, i;
	time_t t;
	char buff[256];

	if ((s = socket(PF_NETLINK, SOCK_DGRAM, NETLINK_NFLOG)) == -1) {
		perror("socket()");
		return 1;
	}

	memset(&addr, 0x0, sizeof(struct sockaddr_nl));
	addr.nl_family = PF_NETLINK;
	addr.nl_groups = 0xffffffff;

	if (bind(s, (struct sockaddr *)&addr, sizeof(struct sockaddr_nl)) == -1) {
		perror("bind()");
		return 1;
	}

	memset(&msg, 0x0, sizeof(struct iovec));
	msg.iov_base = buff;
	msg.iov_len = sizeof(buff);

	memset(&hdr, 0x0, sizeof(struct msghdr));
	memset(&addr, 0x0, sizeof(struct sockaddr_nl));
	hdr.msg_name = (void*)&addr;
	hdr.msg_namelen = sizeof(struct sockaddr_nl);
	hdr.msg_iov = &msg;
	hdr.msg_iovlen = 1;

	while (1) {
		if ((i = recvmsg(s, &hdr, 0)) != -1) {
			t = time(NULL);
			printf("packet caught: size %i -- %s", i, ctime(&t));
		}
		else {
			perror("recvmsg()");
			return 1;
		}
	}

	return 0;
}


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: attachment; filename="ulog-fix.patch"

--- net/ipv4/netfilter/ipt_ULOG.c	2004-05-10 04:32:27.000000000 +0200
+++ net/ipv4/netfilter/ipt_ULOG.c	2004-06-18 20:09:03.000000000 +0200
@@ -97,7 +97,6 @@
 static ulog_buff_t ulog_buffers[ULOG_MAXNLGROUPS];	/* array of buffers */
 
 static struct sock *nflognl;	/* our socket */
-static size_t qlen;		/* current length of multipart-nlmsg */
 DECLARE_LOCK(ulog_lock);	/* spinlock */
 
 /* send one ulog_buff_t to userspace */
@@ -116,7 +115,7 @@
 
 	NETLINK_CB(ub->skb).dst_groups = (1 << nlgroupnum);
 	DEBUGP("ipt_ULOG: throwing %d packets to netlink mask %u\n",
-		ub->qlen, nlgroup);
+		ub->qlen, nlgroupnum);
 	netlink_broadcast(nflognl, ub->skb, 0, (1 << nlgroupnum), GFP_ATOMIC);
 
 	ub->qlen = 0;
@@ -126,7 +125,7 @@
 }
 
 
-/* timer function to flush queue in ULOG_FLUSH_INTERVAL time */
+/* timer function to flush queue in flushtimeout time */
 static void ulog_timer(unsigned long data)
 {
 	DEBUGP("ipt_ULOG: timer function called, calling ulog_send\n");
@@ -257,12 +256,6 @@
 		ub->lastnlh->nlmsg_flags |= NLM_F_MULTI;
 	}
 
-	/* if threshold is reached, send message to userspace */
-	if (qlen >= loginfo->qthreshold) {
-		if (loginfo->qthreshold > 1)
-			nlh->nlmsg_type = NLMSG_DONE;
-	}
-
 	ub->lastnlh = nlh;
 
 	/* if timer isn't already running, start it */
@@ -271,6 +264,13 @@
 		add_timer(&ub->timer);
 	}
 
+	/* if threshold is reached, send message to userspace */
+	if (ub->qlen >= loginfo->qthreshold) {
+		if (loginfo->qthreshold > 1)
+			nlh->nlmsg_type = NLMSG_DONE;
+		ulog_send(groupnum);
+	}
+
 	UNLOCK_BH(&ulog_lock);
 
 	return;

--dDRMvlgZJXvWKvBx--
