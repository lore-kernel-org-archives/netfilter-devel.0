From: Jan Du Caju <Jan.DuCaju@kuleuven.net>
Subject: RE: IPLIMIT Patch UDP
Date: Fri, 21 Feb 2003 22:54:48 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030221215448.GC19981@kuleuven.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="XMCwj5IQnwKtuyBG"
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


--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

Hi again,

Jan Du Caju wrote:
 > >  Ing. CIP Alejandro Celi Mariategui wrote:
 > >
 > >  (Sorry, but my english is very bad)
 > >  Hi,
 > >  I compile with p-o-m the server kernel with IPLIMIT Patch by Gerd
 > >  Knorr
 > >  [1]<kraxel@bytesex.org>
 > >  It work fine, i can limit ex: max 10 TCP connections on the server,
 > >  but i want to limit the UDP connections to 10 (max).
 > >  How I can do it?

 >    This week I made a updlimit patch (shameless copy of iplimit ;-)
 >    I will post it this afternoon/evening when I have more time (and
 >    a cross post to the netfilter-devel list. Maybe they like it)

Finally found some time. Please find below a patch to limit the number 
of parallel UDP connections to a server per client IP address (or address 
block).

 udplimit.patch
 udplimit.patch.config.in
 udplimit.patch.configure.help
 udplimit.patch.help
 udplimit.patch.makefile
 libipt_udplimit.c

If there is anything unacceptable, I will be most willing to make corrections.

Greetz,
Jan.
--------------------------------------------- KULeuvenNet -----

--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii; name="udplimit.patch"
Content-Disposition: inline; filename="udplimit.patch"

diff -urN -x *~ -x [Cc]onfig.* -x Makefile vanilla-2.4.21-pre4/net/ipv4/netfilter/ipt_udplimit.c linux-2.4.21-pre4/net/ipv4/netfilter/ipt_udplimit.c
--- vanilla-2.4.21-pre4/net/ipv4/netfilter/ipt_udplimit.c	Fri Feb 21 17:20:55 2003
+++ linux-2.4.21-pre4/net/ipv4/netfilter/ipt_udplimit.c	Fri Feb 21 17:17:38 2003
@@ -0,0 +1,215 @@
+/*
+ * netfilter module to limit the number of parallel udp
+ * connections per IP address.
+ * Jan Du Caju <Jan.DuCaju@kuleuven.net>
+ *
+ * based on ...
+ * iplimit (in fact a shameless copy ;-)
+ *   (c) 2000 Gerd Knorr <kraxel@bytesex.org>
+ *   Nov 2002: Martin Bene <martin.bene@icomedias.com>:
+ *		only ignore TIME_WAIT or gone connections
+ *
+ *
+ * Kernel module to match connection tracking information.
+ * GPL (C) 1999  Rusty Russell (rusty@rustcorp.com.au).
+ */
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/list.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+#include <linux/netfilter_ipv4/ip_conntrack_core.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_iplimit.h>
+
+#define DEBUG 0
+
+MODULE_LICENSE("GPL");
+
+/* we'll save the tuples of all connections we care about */
+struct ipt_iplimit_conn
+{
+        struct list_head list;
+	struct ip_conntrack_tuple tuple;
+};
+
+struct ipt_iplimit_data {
+	spinlock_t lock;
+	struct list_head iphash[256];
+};
+
+static int ipt_iphash(u_int32_t addr)
+{
+	int hash;
+
+	hash  =  addr        & 0xff;
+	hash ^= (addr >>  8) & 0xff;
+	hash ^= (addr >> 16) & 0xff;
+	hash ^= (addr >> 24) & 0xff;
+	return hash;
+}
+
+static int count_them(struct ipt_iplimit_data *data,
+		      u_int32_t addr, u_int32_t mask,
+		      struct ip_conntrack *ct)
+{
+	int addit = 1, matches = 0;
+	struct ip_conntrack_tuple tuple;
+	struct ip_conntrack_tuple_hash *found;
+	struct ipt_iplimit_conn *conn;
+	struct list_head *hash,*lh;
+
+	spin_lock(&data->lock);
+	tuple = ct->tuplehash[0].tuple;
+	hash = &data->iphash[ipt_iphash(addr & mask)];
+
+	/* check the saved connections */
+	for (lh = hash->next; lh != hash; lh = lh->next) {
+		conn = list_entry(lh,struct ipt_iplimit_conn,list);
+		found = ip_conntrack_find_get(&conn->tuple,ct);
+		if (0 == memcmp(&conn->tuple,&tuple,sizeof(tuple)) &&
+		    found != NULL) {
+			addit = 0;
+		}
+#if DEBUG
+		printk("ipt_udplimit [%d]: src=%u.%u.%u.%u:%d dst=%u.%u.%u.%u:%d\n",
+		       ipt_iphash(addr & mask),
+		       NIPQUAD(conn->tuple.src.ip), ntohs(conn->tuple.src.u.udp.port),
+		       NIPQUAD(conn->tuple.dst.ip), ntohs(conn->tuple.dst.u.udp.port));
+#endif
+		if (NULL == found) {
+			/* this one is gone */
+			lh = lh->prev;
+			list_del(lh->next);
+			kfree(conn);
+			continue;
+		}
+		if ((addr & mask) == (conn->tuple.src.ip & mask)) {
+			/* same source IP address -> be counted! */
+			matches++;
+		}
+		nf_conntrack_put(&found->ctrack->infos[0]);
+	}
+	if (addit) {
+		/* save the new connection in our list */
+#if DEBUG
+		printk("ipt_udplimit [%d]: src=%u.%u.%u.%u:%d dst=%u.%u.%u.%u:%d new\n",
+		       ipt_iphash(addr & mask),
+		       NIPQUAD(tuple.src.ip), ntohs(tuple.src.u.tcp.port),
+		       NIPQUAD(tuple.dst.ip), ntohs(tuple.dst.u.tcp.port));
+#endif
+		conn = kmalloc(sizeof(*conn),GFP_ATOMIC);
+		if (NULL == conn)
+			return -1;
+		memset(conn,0,sizeof(*conn));
+		INIT_LIST_HEAD(&conn->list);
+		conn->tuple = tuple;
+		list_add(&conn->list,hash);
+		matches++;
+	}
+	spin_unlock(&data->lock);
+	return matches;
+}
+
+static int
+match(const struct sk_buff *skb,
+      const struct net_device *in,
+      const struct net_device *out,
+      const void *matchinfo,
+      int offset,
+      const void *hdr,
+      u_int16_t datalen,
+      int *hotdrop)
+{
+	const struct ipt_iplimit_info *info = matchinfo;
+	int connections, match;
+	struct ip_conntrack *ct;
+	enum ip_conntrack_info ctinfo;
+
+	ct = ip_conntrack_get((struct sk_buff *)skb, &ctinfo);
+	if (NULL == ct) {
+		printk("ipt_udplimit: Oops: invalid ct state ?\n");
+		*hotdrop = 1;
+		return 0;
+	}
+	connections = count_them(info->data,skb->nh.iph->saddr,info->mask,ct);
+	if (-1 == connections) {
+		printk("ipt_udplimit: Hmm, kmalloc failed :-(\n");
+		*hotdrop = 1; /* let's free some memory :-) */
+		return 0;
+	}
+        match = (info->inverse) ? (connections <= info->limit) : (connections > info->limit);
+#if DEBUG
+	printk("ipt_udplimit: src=%u.%u.%u.%u mask=%u.%u.%u.%u "
+	       "connections=%d limit=%d match=%s\n",
+	       NIPQUAD(skb->nh.iph->saddr), NIPQUAD(info->mask),
+	       connections, info->limit, match ? "yes" : "no");
+#endif
+
+	return match;
+}
+
+static int check(const char *tablename,
+		 const struct ipt_ip *ip,
+		 void *matchinfo,
+		 unsigned int matchsize,
+		 unsigned int hook_mask)
+{
+	struct ipt_iplimit_info *info = matchinfo;
+	int i;
+
+	/* verify size */
+	if (matchsize != IPT_ALIGN(sizeof(struct ipt_iplimit_info)))
+		return 0;
+
+	/* refuse anything but udp */
+	if (ip->proto != IPPROTO_UDP)
+		return 0;
+
+	/* init private data */
+	info->data = kmalloc(sizeof(struct ipt_iplimit_data),GFP_KERNEL);
+	spin_lock_init(&(info->data->lock));
+	for (i = 0; i < 256; i++)
+		INIT_LIST_HEAD(&(info->data->iphash[i]));
+	
+	return 1;
+}
+
+static void destroy(void *matchinfo, unsigned int matchinfosize)
+{
+	struct ipt_iplimit_info *info = matchinfo;
+	struct ipt_iplimit_conn *conn;
+	struct list_head *hash;
+	int i;
+
+	/* cleanup */
+	for (i = 0; i < 256; i++) {
+		hash = &(info->data->iphash[i]);
+		while (hash != hash->next) {
+			conn = list_entry(hash->next,struct ipt_iplimit_conn,list);
+			list_del(hash->next);
+			kfree(conn);
+		}
+	}
+	kfree(info->data);
+}
+
+static struct ipt_match udplimit_match
+= { { NULL, NULL }, "udplimit", &match, &check, &destroy, THIS_MODULE };
+
+static int __init init(void)
+{
+	/* NULL if ip_conntrack not a module */
+	if (ip_conntrack_module)
+		__MOD_INC_USE_COUNT(ip_conntrack_module);
+	return ipt_register_match(&udplimit_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&udplimit_match);
+	if (ip_conntrack_module)
+		__MOD_DEC_USE_COUNT(ip_conntrack_module);
+}
+
+module_init(init);
+module_exit(fini);

--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii;
	name="udplimit.patch.config.in"
Content-Disposition: inline; filename="udplimit.patch.config.in"

    dep_tristate '  Connection state match support' CONFIG_IP_NF_MATCH_STATE $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES 
    dep_tristate '  Connections/UDP limit match support' CONFIG_IP_NF_MATCH_UDPLIMIT $CONFIG_IP_NF_IPTABLES

--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii;
	name="udplimit.patch.makefile"
Content-Disposition: inline; filename="udplimit.patch.makefile"

obj-$(CONFIG_IP_NF_MATCH_STATE) += ipt_state.o
obj-$(CONFIG_IP_NF_MATCH_UDPLIMIT) += ipt_udplimit.o

--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii; name="udplimit.patch.help"
Content-Disposition: inline; filename="udplimit.patch.help"

Author: Gerd Knorr <kraxel@bytesex.org>
	Jan Du Caju <Jan.DuCaju@kuleuven.net> (I just made a shameless copy
	of iplimit of Gerd Knorr ;-)
Status: ItWorksForMe[tm]

This adds CONFIG_IP_NF_MATCH_UDPLIMIT match allows you to restrict the
number of parallel UDP connections to a server per client IP address
(or address block).

Examples:

# allow 5 udp connections per client host
iptables -p udp -m udplimit --udplimit-above 5 -j REJECT

# you can also match the other way around:
iptables -p udp -m udplimit ! --udplimit-above 5 -j ACCEPT

# limit the nr of parallel http requests to 16 per class C sized
# network (24 bit netmask)
iptables -p udp --dport 161 -m udplimit --udplimit-above 16		\
	--iplimit-mask 24 -j REJECT

--XMCwj5IQnwKtuyBG
Content-Type: text/plain; charset=us-ascii;
	name="udplimit.patch.configure.help"
Content-Disposition: inline; filename="udplimit.patch.configure.help"

CONFIG_IP_NF_MATCH_STATE
Connections/UDP limit match support
CONFIG_IP_NF_MATCH_UDPLIMIT
  This match allows you to restrict the number of parallel UDP
  connections to a server per client IP address (or address block).

  If you want to compile it as a module, say M here and read
  Documentation/modules.txt.  If unsure, say `N'.

--XMCwj5IQnwKtuyBG
Content-Type: text/x-csrc; charset=us-ascii; name="libipt_udplimit.c"
Content-Disposition: inline; filename="libipt_udplimit.c"

/* Shared library add-on to iptables to add state tracking support. */
#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <stddef.h>
#include <getopt.h>
#include <iptables.h>
#include <linux/netfilter_ipv4/ip_conntrack.h>
#include <linux/netfilter_ipv4/ipt_iplimit.h>

/* Function which prints out usage message. */
static void
help(void)
{
	printf(
"udplimit v%s options:\n"
"[!] --udplimit-above n		match if the number of existing udp connections is (not) above n\n"
" --udplimit-mask n		group hosts using mask\n"
"\n", IPTABLES_VERSION);
}

static struct option opts[] = {
	{ "udplimit-above", 1, 0, '1' },
	{ "udplimit-mask",  1, 0, '2' },
	{0}
};

/* Initialize the match. */
static void
init(struct ipt_entry_match *m, unsigned int *nfcache)
{
	/* Can't cache this */
	*nfcache |= NFC_UNKNOWN;
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      unsigned int *nfcache,
      struct ipt_entry_match **match)
{
	struct ipt_iplimit_info *info = (struct ipt_iplimit_info*)(*match)->data;

	if (0 == (*flags & 2)) {
		/* set default mask unless we've already seen a mask option */
		info->mask = htonl(0xFFFFFFFF);
	}

	switch (c) {
	case '1':
		check_inverse(optarg, &invert, &optind, 0);
		info->limit = atoi(argv[optind-1]);
		info->inverse = invert;
		*flags |= 1;
		break;

	case '2':
		info->mask = htonl(0xFFFFFFFF << (32 - atoi(argv[optind-1])));
		*flags |= 2;
		break;

	default:
		return 0;
	}

	return 1;
}

/* Final check */
static void final_check(unsigned int flags)
{
	if (!flags & 1)
		exit_error(PARAMETER_PROBLEM, "You must specify `--udplimit-above'");
}

static int
count_bits(u_int32_t mask)
{
	int i, bits;

	for (bits = 0, i = 31; i >= 0; i--) {
		if (mask & htonl((u_int32_t)1 << i)) {
			bits++;
			continue;
		}
		break;
	}
	return bits;
}

/* Prints out the matchinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_match *match,
      int numeric)
{
	struct ipt_iplimit_info *info = (struct ipt_iplimit_info*)match->data;

	printf("#conn/%d %s %d ", count_bits(info->mask),
	       info->inverse ? "<" : ">", info->limit);
}

/* Saves the matchinfo in parsable form to stdout. */
static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
{
	struct ipt_iplimit_info *info = (struct ipt_iplimit_info*)match->data;

	printf("%s--udplimit-above %d ",info->inverse ? "! " : "",info->limit);
	printf("--udplimit-mask %d ",count_bits(info->mask));
}

static struct iptables_match udplimit = {
	name:		"udplimit",
	version:	IPTABLES_VERSION,
	size:		IPT_ALIGN(sizeof(struct ipt_iplimit_info)),
	userspacesize:	offsetof(struct ipt_iplimit_info,data),
	help:		help,
	init:		init,
	parse:		parse,
	final_check:	final_check,
	print:		print,
	save: 		save,
	extra_opts:	opts
};

void _init(void)
{
	register_match(&udplimit);
}

--XMCwj5IQnwKtuyBG--
