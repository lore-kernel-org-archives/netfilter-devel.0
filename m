From: Flavio Pescuma <flavio@marasystems.com>
Subject: New target and match
Date: 01 Aug 2003 17:16:17 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1059750977.17220.46.camel@araceli.marasystems.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-/AisHSZuXnU1/1a9AxN/"
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


--=-/AisHSZuXnU1/1a9AxN/
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi all,

We created a match and target which I have attached to this mail that
helps us to stop ongoing session when they were not longer allowed by
the rule set, after a change in the rule set.  This is very simple if
your rule set is always evaluated for each packet and you are not using
conntrack.  If you are using conntrack you would like to accept packets
form established, related sessions as quickly as possible, though
killing not longer accepted ones. This patch adds one Confirmed bit to
the conntrack table which can be set by the CONFIRMED target, and match
with confirmed match. To clear the bit we did a "quick and dirty" hack
that each time a rule is installed that contains the confirmed match all
sessions in the conntrack gets the confirmed bit cleared.  Since we use
iptables-restore to change our rule set this works quite nice for us. 
The intention to submit this patch is to bring up the issue and look for
better alternatives, though is totally functional and used in all our
products. 

Thanks for iptables,

/flavio

-- 
Flavio Pescuma
MARA Systems AB
P +46 8 681 0840  F +46 681 0841 M +46 733548833
flavio@marasystems.com
http://www.marasystems.com

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=CONFIRMED.patch
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=CONFIRMED.patch; charset=UTF-8

diff -urN linux-2.4.20-uml2/include/linux/netfilter_ipv4/ip_conntrack.h lin=
ux-2.4.20-uml3/include/linux/netfilter_ipv4/ip_conntrack.h
--- linux-2.4.20-uml2/include/linux/netfilter_ipv4/ip_conntrack.h	2003-02-2=
8 00:09:49.000000000 +0100
+++ linux-2.4.20-uml3/include/linux/netfilter_ipv4/ip_conntrack.h	2003-02-2=
8 00:18:16.000000000 +0100
@@ -46,6 +46,10 @@
 	/* Connection is confirmed: originating packet has left box */
 	IPS_CONFIRMED_BIT =3D 3,
 	IPS_CONFIRMED =3D (1 << IPS_CONFIRMED_BIT),
+=09
+	/* Confirm bit after re installing the rule set */
+	IPS_CONFIRMED_RULE_BIT =3D 4,
+	IPS_CONFIRMED_RULE =3D (1 << IPS_CONFIRMED_RULE_BIT),
 };
=20
 #include <linux/netfilter_ipv4/ip_conntrack_tcp.h>
diff -urN linux-2.4.20-uml2/net/ipv4/netfilter/ipt_confirmed.c linux-2.4.20=
-uml3/net/ipv4/netfilter/ipt_confirmed.c
--- linux-2.4.20-uml2/net/ipv4/netfilter/ipt_confirmed.c	1970-01-01 01:00:0=
0.000000000 +0100
+++ linux-2.4.20-uml3/net/ipv4/netfilter/ipt_confirmed.c	2003-02-28 00:19:1=
7.000000000 +0100
@@ -0,0 +1,49 @@
+#include <linux/module.h>
+#include <linux/skbuff.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
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
+	enum ip_conntrack_info ctinfo;
+	struct ip_conntrack *ct =3D ip_conntrack_get((struct sk_buff *)skb, &ctin=
fo);
+	if (!ct)
+	    return 0;
+
+	return (ct->status & IPS_CONFIRMED_RULE);
+}
+
+static int
+checkentry(const char *tablename,
+           const struct ipt_ip *ip,
+           void *matchinfo,
+           unsigned int matchsize,
+           unsigned int hook_mask)
+{
+	return 1;
+}
+
+static struct ipt_match confirmed_match
+=3D { { NULL, NULL }, "confirmed", &match, &checkentry, NULL, THIS_MODULE =
};
+
+static int __init init(void)
+{
+	return ipt_register_match(&confirmed_match);
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_match(&confirmed_match);
+}
+
+module_init(init);
+module_exit(fini);
diff -urN linux-2.4.20-uml2/net/ipv4/netfilter/ipt_CONFIRMED.c linux-2.4.20=
-uml3/net/ipv4/netfilter/ipt_CONFIRMED.c
--- linux-2.4.20-uml2/net/ipv4/netfilter/ipt_CONFIRMED.c	1970-01-01 01:00:0=
0.000000000 +0100
+++ linux-2.4.20-uml3/net/ipv4/netfilter/ipt_CONFIRMED.c	2003-02-28 00:19:3=
0.000000000 +0100
@@ -0,0 +1,59 @@
+#include <linux/module.h>
+#include <linux/skbuff.h>
+#include <linux/ip.h>
+#include <net/checksum.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ip_conntrack.h>
+
+static unsigned int
+target(struct sk_buff **pskb,
+       unsigned int hooknum,
+       const struct net_device *in,
+       const struct net_device *out,
+       const void *targinfo,
+       void *userinfo)
+{
+	enum ip_conntrack_info ctinfo;
+	struct ip_conntrack *ct =3D ip_conntrack_get((*pskb), &ctinfo);
+	if(ct)
+	  set_bit(IPS_CONFIRMED_RULE_BIT, &ct->status);
+	return IPT_CONTINUE;
+}
+
+static inline int
+clear_confirmed (const struct ip_conntrack *i, void *unused) {
+  clear_bit(IPS_CONFIRMED_RULE_BIT, &i->status);=09
+  return 0;
+}
+
+static int
+checkentry(const char *tablename,
+	   const struct ipt_entry *e,
+           void *targinfo,
+           unsigned int targinfosize,
+           unsigned int hook_mask)
+{
+/* loop all conntrack session and set or unset the bit */
+  ip_ct_selective_cleanup(clear_confirmed, NULL);
+  return 1;
+}
+
+static struct ipt_target ipt_confirmed_reg
+=3D { { NULL, NULL }, "CONFIRMED", target, checkentry, NULL, THIS_MODULE }=
;
+
+static int __init init(void)
+{
+	if (ipt_register_target(&ipt_confirmed_reg))
+		return -EINVAL;
+
+	return 0;
+}
+
+static void __exit fini(void)
+{
+	ipt_unregister_target(&ipt_confirmed_reg);
+}
+
+module_init(init);
+module_exit(fini);

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=CONFIRMED.patch.config.in
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=CONFIRMED.patch.config.in; charset=UTF-8

    dep_tristate '  Connection state match support' CONFIG_IP_NF_MATCH_STAT=
E $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES=20
    dep_tristate '  Connection confirm match support' CONFIG_IP_NF_MATCH_CO=
NFIRMED $CONFIG_IP_NF_CONNTRACK $CONFIG_IP_NF_IPTABLES=20

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=CONFIRMED.patch.config.in-2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=CONFIRMED.patch.config.in-2; charset=UTF-8

  dep_tristate '  LOG target support' CONFIG_IP_NF_TARGET_LOG $CONFIG_IP_NF=
_IPTABLES
  dep_tristate '  CONFIRMED target support' CONFIG_IP_NF_TARGET_CONFIRMED $=
CONFIG_IP_NF_IPTABLES

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=CONFIRMED.patch.help
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=CONFIRMED.patch.help; charset=UTF-8

Author: Flavio Pescuma <flavio.pescuma@marasystems.com>
Status: works for me

This patch adds a new virtual conntrack state bit CONFIRMED,
indicating that this connection has been confirmed by the
ruleset.

Usage:

   confirmed
       This  module  matches connections having the CONFIRMED
       bit set.

   CONFIRMED
       This  is  used  to set the CONFIRMED bit on the connection

To do:

   The CONFIRMED bit should probably be automated to become an
   integral part of conntrack.

   The clearing of the CONFIRMED bit should be moved up to iptables
   as an option to the iptables command

   Unconfirmed EXPECTED should be seen as RELATED by the state match.
   Now they are being seen as CONNECTED if the RELATED connection has
   been established I think.

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=CONFIRMED.patch.makefile
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-makefile; name=CONFIRMED.patch.makefile; charset=UTF-8

obj-$(CONFIG_IP_NF_MATCH_STATE) +=3D ipt_state.o
obj-$(CONFIG_IP_NF_MATCH_CONFIRMED) +=3D ipt_confirmed.o

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=CONFIRMED.patch.makefile-2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-makefile; name=CONFIRMED.patch.makefile-2; charset=UTF-8

obj-$(CONFIG_IP_NF_TARGET_LOG) +=3D ipt_LOG.o
obj-$(CONFIG_IP_NF_TARGET_CONFIRMED) +=3D ipt_CONFIRMED.o

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=libipt_CONFIRMED.c
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-c; name=libipt_CONFIRMED.c; charset=UTF-8

/* Shared library add-on to iptables to add CONNMARK target support. */
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>
#include <linux/netfilter_ipv4/ip_tables.h>

/* Function which prints out usage message. */
static void
help(void)
{
	printf(
"CONFIRMED target v%s:\n"
"\n",
IPTABLES_VERSION);
}

static struct option opts[] =3D {
	{ 0 }
};

/* Initialize the target. */
static void
init(struct ipt_entry_target *t, unsigned int *nfcache)
{
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      struct ipt_entry_target **target)
{
	return 1;
}

static void
final_check(unsigned int flags)
{
}

/* Prints out the targinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_target *target,
      int numeric)
{
	printf("CONFIRMED ");
}

/* Saves the union ipt_targinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct ipt_entry_target *target)
{
}

static
struct iptables_target confirmed
=3D { NULL,
    "CONFIRMED",
    IPTABLES_VERSION,
    IPT_ALIGN(0),
    IPT_ALIGN(0),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
	register_target(&confirmed);
}

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=libipt_confirmed.c
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-c; name=libipt_confirmed.c; charset=UTF-8

/* Shared library add-on to iptables to add CONNMARK matching support. */
#include <stdio.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <getopt.h>

#include <iptables.h>

/* Function which prints out usage message. */
static void
help(void)
{
	printf(
"CONFIRMED match v%s:\n"
"\n",
IPTABLES_VERSION);
}

static struct option opts[] =3D {
	{0}
};

/* Initialize the match. */
static void
init(struct ipt_entry_match *m, unsigned int *nfcache)
{
	/* Can't cache this. */
	*nfcache |=3D NFC_UNKNOWN;
}

/* Function which parses command options; returns true if it
   ate an option */
static int
parse(int c, char **argv, int invert, unsigned int *flags,
      const struct ipt_entry *entry,
      unsigned int *nfcache,
      struct ipt_entry_match **match)
{
	return 1;
}

/* Final check; must have specified --mark. */
static void
final_check(unsigned int flags)
{
}

/* Prints out the matchinfo. */
static void
print(const struct ipt_ip *ip,
      const struct ipt_entry_match *match,
      int numeric)
{
	printf("CONFIRMED match");
}

/* Saves the union ipt_matchinfo in parsable form to stdout. */
static void
save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
{
}

static
struct iptables_match confirmed
=3D { NULL,
    "confirmed",
    IPTABLES_VERSION,
    IPT_ALIGN(0),
    IPT_ALIGN(0),
    &help,
    &init,
    &parse,
    &final_check,
    &print,
    &save,
    opts
};

void _init(void)
{
	register_match(&confirmed);
}

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=.CONFIRMED-test
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-sh; name=.CONFIRMED-test; charset=UTF-8

#! /bin/sh
[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_CONFIRMED.c ] && echo CONFIRMED

--=-/AisHSZuXnU1/1a9AxN/
Content-Disposition: attachment; filename=.confirmed-test
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-sh; name=.confirmed-test; charset=UTF-8

#! /bin/sh
[ -f $KERNEL_DIR/net/ipv4/netfilter/ipt_confirmed.c ] && echo confirmed

--=-/AisHSZuXnU1/1a9AxN/--
