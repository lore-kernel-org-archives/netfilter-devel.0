From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [RFC] CONNMARK getsockopt/setsockopt functionality
Date: Fri, 21 May 2004 09:37:56 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1085125075.1782.36.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Iu3qLEQLe3lt3RbM5123"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Iu3qLEQLe3lt3RbM5123
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


  Hi,

  While thinking on problems with traffic control in user-space proxies,
we came to the conclusion, that under some conditions manually setting
the connmark value of an already established connection would be really
useful. (For example, it would be possible to traffic-limit based on
outband authentication decisions.)

  I've created a patch for connmark, which registers a getsockopt() and
a setsockopt() function for getting/setting the connection mark. The
patch is for Linux 2.4.25 + CONNMARK from POM-ng, but theoretically it
should apply on any 2.4.x version plus the newest connmark patch.

  It would be great if this patch could be merged into connmark, as I
think it would be really userful for all kinds of user-space proxies.

  As always, any comments are welcome. The patch is absolutely a
proof-of-concept implementation, so beware... :)

-- 
 Regards,
   Krisztian KOVACS

--=-Iu3qLEQLe3lt3RbM5123
Content-Disposition: attachment; filename=connmark_sockopt.patch
Content-Type: text/x-patch; name=connmark_sockopt.patch; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Index: linux-2.4.25-cmark/include/linux/netfilter_ipv4.h
===================================================================
--- linux-2.4.25-cmark.orig/include/linux/netfilter_ipv4.h	Mon Feb 25 20:38:13 2002
+++ linux-2.4.25-cmark/include/linux/netfilter_ipv4.h	Mon May 17 17:30:40 2004
@@ -64,6 +64,7 @@
 /* 2.2 firewalling (+ masq) went from 64 through 76 */
 /* 2.4 firewalling went 64 through 67. */
 #define SO_ORIGINAL_DST 80
+#define SO_CONNMARK	81
 
 #ifdef __KERNEL__
 #ifdef CONFIG_NETFILTER_DEBUG
Index: linux-2.4.25-cmark/net/ipv4/netfilter/ip_conntrack_core.c
===================================================================
--- linux-2.4.25-cmark.orig/net/ipv4/netfilter/ip_conntrack_core.c	Thu Apr  1 15:42:21 2004
+++ linux-2.4.25-cmark/net/ipv4/netfilter/ip_conntrack_core.c	Tue May 18 16:57:20 2004
@@ -46,6 +46,10 @@
 
 #define IP_CONNTRACK_VERSION	"2.1"
 
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+#include <linux/netfilter_ipv4/ipt_CONNMARK.h>
+#endif
+
 #if 0
 #define DEBUGP printk
 #else
@@ -1294,6 +1298,100 @@
 	}
 }
 
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+static int
+get_sk_proto(struct sock *sk)
+{
+	if (strcmp(sk->proto->name, "TCP") == 0)
+		return IPPROTO_TCP;
+	else if (strcmp(sk->proto->name, "UDP") == 0)
+		return IPPROTO_UDP;
+	else
+		return 0;
+}
+
+static int
+getcmark(struct sock *sk, int optval, void *user, int *len)
+{
+	struct ip_conntrack_tuple_hash *h;
+	struct ip_conntrack_tuple tuple;
+	unsigned long mark;
+
+	IP_CT_TUPLE_U_BLANK(&tuple);
+	tuple.src.ip = sk->rcv_saddr;
+	tuple.src.u.tcp.port = sk->sport;
+	tuple.dst.ip = sk->daddr;
+	tuple.dst.u.tcp.port = sk->dport;
+
+	tuple.dst.protonum = get_sk_proto(sk);
+	if (tuple.dst.protonum == 0) {
+		return -ENOPROTOOPT;
+	}
+
+	if ((unsigned int) *len < sizeof(mark)) {
+		return -EINVAL;
+	}
+
+	h = ip_conntrack_find_get(&tuple, NULL);
+	if (h) {
+		mark = h->ctrack->mark;
+		ip_conntrack_put(h->ctrack);
+
+		if (copy_to_user(user, &mark, sizeof(mark)) != 0)
+			return -EFAULT;
+		else
+			return 0;
+	}
+
+	return -ENOENT;
+}
+
+static int
+setcmark(struct sock *sk, int optval, void *user, int len)
+{
+	struct ip_conntrack_tuple_hash *h;
+	struct ip_conntrack_tuple tuple;
+	struct ipt_connmark_target_info markinfo;
+	unsigned long newmark;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	if ((unsigned int) len < sizeof(markinfo)) {
+		return -EINVAL;
+	}
+
+	if (copy_from_user(&markinfo, user, len))
+		return -EFAULT;
+
+	IP_CT_TUPLE_U_BLANK(&tuple);
+	tuple.src.ip = sk->rcv_saddr;
+	tuple.src.u.tcp.port = sk->sport;
+	tuple.dst.ip = sk->daddr;
+	tuple.dst.u.tcp.port = sk->dport;
+
+	tuple.dst.protonum = get_sk_proto(sk);
+	if (tuple.dst.protonum == 0) {
+		return -ENOPROTOOPT;
+	}
+
+	h = ip_conntrack_find_get(&tuple, NULL);
+	if (h) {
+		if (markinfo.mode == IPT_CONNMARK_SET) {
+			newmark = (h->ctrack->mark & ~markinfo.mask) | markinfo.mark;
+			if (newmark != h->ctrack->mark)
+				h->ctrack->mark = newmark;
+		}
+
+		ip_conntrack_put(h->ctrack);
+
+		return 0;
+	}
+
+	return -ENOENT;
+}
+#endif
+
 /* Fast function for those who don't want to parse /proc (and I don't
    blame them). */
 /* Reversing the socket's dst/src point of view gives us the reply
@@ -1347,10 +1445,46 @@
 	return -ENOENT;
 }
 
-static struct nf_sockopt_ops so_getorigdst
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+static int
+connmark_setsockopt(struct sock *sk, int optval, void *user, unsigned int len)
+{
+	switch (optval) {
+	case SO_CONNMARK:
+		return setcmark(sk, optval, user, len);
+		break;
+	}
+
+	return -EINVAL;
+}
+#endif
+
+static int
+connmark_getsockopt(struct sock *sk, int optval, void *user, int *len)
+{
+	switch (optval) {
+	case SO_ORIGINAL_DST:
+		return getorigdst(sk, optval, user, len);
+		break;
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+	case SO_CONNMARK:
+		return getcmark(sk, optval, user, len);
+		break;
+#endif
+	}
+
+	return -EINVAL;
+}
+
+static struct nf_sockopt_ops so_conntrackops
 = { { NULL, NULL }, PF_INET,
-    0, 0, NULL, /* Setsockopts */
-    SO_ORIGINAL_DST, SO_ORIGINAL_DST+1, &getorigdst,
+#if defined(CONFIG_IP_NF_CONNTRACK_MARK)
+    SO_CONNMARK, SO_CONNMARK+1, &connmark_setsockopt,		/* setsockopts */
+    SO_ORIGINAL_DST, SO_CONNMARK+1, &connmark_getsockopt,	/* getsockopts */
+#else
+    0, 0, NULL,							/* setsockopts */
+    SO_ORIGINAL_DST, SO_ORIGINAL_DST+1, &connmark_getsockopt,	/* getsockopts */
+#endif
     0, NULL };
 
 static int kill_all(const struct ip_conntrack *i, void *data)
@@ -1378,7 +1512,7 @@
 
 	kmem_cache_destroy(ip_conntrack_cachep);
 	vfree(ip_conntrack_hash);
-	nf_unregister_sockopt(&so_getorigdst);
+	nf_unregister_sockopt(&so_conntrackops);
 }
 
 static int hashsize = 0;
@@ -1409,7 +1543,7 @@
 	       ip_conntrack_htable_size, ip_conntrack_max,
 	       sizeof(struct ip_conntrack));
 
-	ret = nf_register_sockopt(&so_getorigdst);
+	ret = nf_register_sockopt(&so_conntrackops);
 	if (ret != 0) {
 		printk(KERN_ERR "Unable to register netfilter socket option\n");
 		return ret;
@@ -1447,7 +1581,7 @@
 err_free_hash:
 	vfree(ip_conntrack_hash);
 err_unreg_sockopt:
-	nf_unregister_sockopt(&so_getorigdst);
+	nf_unregister_sockopt(&so_conntrackops);
 
 	return -ENOMEM;
 }
More recent patches modify files in netfilter_cmarksockopt.

--=-Iu3qLEQLe3lt3RbM5123
Content-Disposition: attachment; filename=connmark_sockopt_test.c
Content-Type: text/x-c; name=connmark_sockopt_test.c; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>

#include <linux/netfilter_ipv4.h>
#include <linux/netfilter_ipv4/ipt_CONNMARK.h>

/* IP address to connect to */
#define DEST_IP  "10.30.0.6"

int main()
{
  int sock;
  struct sockaddr_in sin;
  struct ipt_connmark_target_info markinfo;
  unsigned long mark;
  socklen_t len;
  char ch;
  char buf[] = "almafa, kortefa, szilvafa\n";

  sock = socket(AF_INET, SOCK_STREAM, 0);
  if (sock == -1)
    {
      perror("socket");
      return -1;
    }
  
  sin.sin_family = AF_INET;
  inet_aton(DEST_IP, &sin.sin_addr);
  sin.sin_port = htons(10080);
  if (connect(sock, (struct sockaddr *) &sin, sizeof(sin)) == -1)
    {
      perror("connect");
      return -1;
    }

  /* mark connection */
  markinfo.mark = 42;
  markinfo.mask = 0xff;
  markinfo.mode = IPT_CONNMARK_SET;
  if (setsockopt(sock, SOL_IP, SO_CONNMARK, &markinfo, sizeof(markinfo)) == -1)
    {
      perror("setsockopt(SOL_IP, SO_CONNMARK)");
      return -1;
    }
  
  if (write(sock, buf, strlen(buf)) == -1)
    {
      perror("write");
      return -1;
    }

  /* get mark */
  len = sizeof(mark);
  if (getsockopt(sock, SOL_IP, SO_CONNMARK, &mark, &len) == -1)
    {
      perror("getsockopt(SOL_IP, SO_CONNMARK)");
      return -1;
    }
  fprintf(stderr, "mark: %lu\n", mark);

  while (read(sock, &ch, 1) == 1)
    {
      putchar(ch);
    }
  
  close(sock);

  return 0;
}


--=-Iu3qLEQLe3lt3RbM5123--
