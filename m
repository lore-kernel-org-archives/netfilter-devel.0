From: fender <frozenspot@gmail.com>
Subject: Couldn't load match `pknock':(null)
Date: Tue, 18 Aug 2009 19:31:09 -0300
Message-ID: <7e36c7130908181531r3262c9b6kf3f038f9092cc34f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f215.google.com ([209.85.220.215]:52807 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZHRWbK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:31:10 -0400
Received: by fxm11 with SMTP id 11so580722fxm.39
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Aug 2009 15:31:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi people,

I've just applied some patches to the pknock match module to work with
kernel > 2.6.28 and iptables 1.4.x.

What I get when I try to execute this module is:

# iptables -m pknock --help
iptables v1.4.3: Couldn't load match `pknock':(null)


Does anyone have any clue about this issue?

The updated code is below.

Thanks in advance,


--- /dev/null   2009-04-20 11:00:06.000000000 -0300
+++ libipt_pknock.c     2009-08-18 19:04:20.000000000 -0300
@@ -0,0 +1,351 @@
+/*
+ * Shared library add-on to iptables to add Port Knocking and SPA matching
+ * support.
+ *
+ * (C) 2006-2009 J. Federico Hernandez <fede.hernandez@gmail.com>
+ * (C) 2006 Luis Floreani <luis.floreani@gmail.com>
+ *
+ * $Id: libipt_pknock.c 462 2009-07-01 16:17:16Z fender $
+ *
+ * This program is released under the terms of GNU GPL version 2.
+ */
+#include <getopt.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+
+#include <xtables.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter_ipv4/ip_tables.h>
+//#include <linux/netfilter_ipv4/ipt_pknock.h>
+#include "../kernel/ipt_pknock.h"
+
+static const struct option pknock_opts[] = {
+       /* .name, .has_arg, .flag, .val */
+       { "knockports", 1,      0, 'k' },
+       { "t",                  1,      0, 't' },
+       { "time",               1,      0, 't' },
+       { "name",               1,      0, 'n' },
+       { "opensecret", 1,      0, 'a' },
+       { "closesecret",1,      0, 'z' },
+       { "strict",             0,      0, 'x' },
+       { "checkip",    0,      0, 'c' },
+       { "chkip",              0,      0, 'c' },
+       { .name = NULL }
+};
+
+/* Function which prints out usage message. */
+static void pknock_help(void)
+{
+       printf("pknock match options:\n"
+               " --knockports port[,port,port,...]     "
+                       "Matches destination port(s).\n"
+               " --time seconds\n"
+               " --t ...                               "
+                       "Time between port match.\n"
+               " --secure                              "
+                       "hmac must be in the packets.\n"
+               " --strict                              "
+                       "Knocks sequence must be exact.\n"
+               " --name rule_name                      "
+                       "Rule name.\n"
+               " --checkip                             "
+                       "Matches if the source ip is in the list.\n"
+               " --chkip\n");
+}
+
+static unsigned int
+parse_ports(const char *portstring, u_int16_t *ports, const char *proto)
+{
+       char *buffer, *cp, *next;
+       unsigned int i;
+
+       buffer = strdup(portstring);
+       if (!buffer) xtables_error(OTHER_PROBLEM, "strdup failed");
+
+       for (cp=buffer, i=0; cp && i<IPT_PKNOCK_MAX_PORTS; cp=next, i++)
+       {
+               next=strchr(cp, ',');
+               if (next) *next++='\0';
+               ports[i] = xtables_parse_port(cp, proto);
+       }
+
+       if (cp) xtables_error(PARAMETER_PROBLEM, "too many ports specified");
+
+       free(buffer);
+       return i;
+}
+
+static char *
+proto_to_name(u_int8_t proto)
+{
+       switch (proto) {
+       case IPPROTO_TCP:
+               return "tcp";
+       case IPPROTO_UDP:
+               return "udp";
+       default:
+               return NULL;
+       }
+}
+
+static const char *
+check_proto(u_int16_t pnum, u_int8_t invflags)
+{
+       char *proto;
+
+       if (invflags & XT_INV_PROTO)
+               xtables_error(PARAMETER_PROBLEM, PKNOCK "only works
with TCP and UDP.");
+
+       if ((proto = proto_to_name(pnum)) != NULL)
+               return proto;
+       else if (!pnum)
+               xtables_error(PARAMETER_PROBLEM, PKNOCK "needs `-p
tcp' or `-p udp'");
+       else
+               xtables_error(PARAMETER_PROBLEM, PKNOCK "only works
with TCP and UDP.");
+}
+
+/* Function which parses command options; returns true if it ate an option */
+static int
+__pknock_parse(int c, char **argv, int invert, unsigned int *flags,
+               struct xt_entry_match **match, u_int16_t pnum,
+               u_int16_t invflags)
+{
+       const char *proto;
+       struct ipt_pknock *info = (struct ipt_pknock *) (*match)->data;
+
+       switch (c) {
+       case 'k': /* --knockports */
+               if (*flags & IPT_PKNOCK_KNOCKPORT)
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot use --knockports twice.\n");
+
+               xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+               proto = check_proto(pnum, invflags);
+
+               info->ports_count = parse_ports(optarg, info->port, proto);
+               info->option |= IPT_PKNOCK_KNOCKPORT;
+               *flags |= IPT_PKNOCK_KNOCKPORT;
+#if DEBUG
+               printf("ports_count: %d\n", info->ports_count);
+#endif
+               break;
+
+       case 't': /* --time */
+               if (*flags & IPT_PKNOCK_TIME)
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot use --time twice.\n");
+
+               xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+
+               info->max_time = atoi(optarg);
+               info->option |= IPT_PKNOCK_TIME;
+               *flags |= IPT_PKNOCK_TIME;
+               break;
+
+       case 'n': /* --name */
+               if (*flags & IPT_PKNOCK_NAME)
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot use --name twice.\n");
+
+               xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+
+               memset(info->rule_name, 0, IPT_PKNOCK_MAX_BUF_LEN + 1);
+               strncpy(info->rule_name, optarg, IPT_PKNOCK_MAX_BUF_LEN);
+
+               info->rule_name_len = strlen(info->rule_name);
+               info->option |= IPT_PKNOCK_NAME;
+               *flags |= IPT_PKNOCK_NAME;
+#if DEBUG
+               printf("info->rule_name: %s\n", info->rule_name);
+#endif
+               break;
+
+       case 'a': /* --opensecret */
+               if (*flags & IPT_PKNOCK_OPENSECRET)
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot use --opensecret twice.\n");
+
+               xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+
+               memset(info->open_secret, 0, IPT_PKNOCK_MAX_PASSWD_LEN + 1);
+               strncpy(info->open_secret, optarg, IPT_PKNOCK_MAX_PASSWD_LEN);
+
+               info->open_secret_len = strlen(info->open_secret);
+               info->option |= IPT_PKNOCK_OPENSECRET;
+               *flags |= IPT_PKNOCK_OPENSECRET;
+               break;
+
+       case 'z': /* --closesecret */
+               if (*flags & IPT_PKNOCK_CLOSESECRET)
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot use --closesecret twice.\n");
+
+               xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+
+               memset(info->close_secret, 0, IPT_PKNOCK_MAX_PASSWD_LEN + 1);
+               strncpy(info->close_secret, optarg, IPT_PKNOCK_MAX_PASSWD_LEN);
+
+               info->close_secret_len = strlen(info->close_secret);
+               info->option |= IPT_PKNOCK_CLOSESECRET;
+               *flags |= IPT_PKNOCK_CLOSESECRET;
+               break;
+
+       case 'c': /* --checkip */
+               if (*flags & IPT_PKNOCK_CHECKIP)
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot use --checkip twice.\n");
+
+               xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+
+               info->option |= IPT_PKNOCK_CHECKIP;
+               *flags |= IPT_PKNOCK_CHECKIP;
+               break;
+
+       case 'x': /* --strict */
+               if (*flags & IPT_PKNOCK_STRICT)
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot use --strict twice.\n");
+
+               xtables_check_inverse(argv[optind-1], &invert, &optind, 0);
+
+               info->option |= IPT_PKNOCK_STRICT;
+               *flags |= IPT_PKNOCK_STRICT;
+               break;
+
+       default:
+               return 0;
+       }
+
+       if (invert)
+               xtables_error(PARAMETER_PROBLEM, PKNOCK "does not
support invert.");
+
+       return 1;
+}
+
+static int pknock_parse(int c, char **argv, int invert, unsigned int *flags,
+                               const void *e, struct xt_entry_match **match)
+{
+       const struct ipt_entry *entry = e;
+       return __pknock_parse(c, argv, invert, flags, match,
+                       entry->ip.proto, entry->ip.invflags);
+}
+
+/* Final check. */
+static void pknock_check(unsigned int flags)
+{
+       if (!flags)
+               xtables_error(PARAMETER_PROBLEM, PKNOCK "expection an
option.\n");
+
+       if (!(flags & IPT_PKNOCK_NAME))
+               xtables_error(PARAMETER_PROBLEM, PKNOCK
+                       "--name option is required.\n");
+
+       if (flags & IPT_PKNOCK_KNOCKPORT) {
+               if (flags & IPT_PKNOCK_CHECKIP) {
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot specify --knockports with
--checkip.\n");
+               }
+               if ((flags & IPT_PKNOCK_OPENSECRET)
+                       && !(flags & IPT_PKNOCK_CLOSESECRET))
+               {
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "--opensecret must go with --closesecret.\n");
+               }
+               if ((flags & IPT_PKNOCK_CLOSESECRET)
+                       && !(flags & IPT_PKNOCK_OPENSECRET))
+               {
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "--closesecret must go with --opensecret.\n");
+               }
+       }
+
+       if (flags & IPT_PKNOCK_CHECKIP) {
+               if (flags & IPT_PKNOCK_KNOCKPORT) {
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot specify --checkip with
--knockports.\n");
+               }
+               if ((flags & IPT_PKNOCK_OPENSECRET)
+                       || (flags & IPT_PKNOCK_CLOSESECRET))
+               {
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot specify --opensecret and"
+                               " --closesecret with --checkip.\n");
+               }
+               if (flags & IPT_PKNOCK_TIME) {
+                       xtables_error(PARAMETER_PROBLEM, PKNOCK
+                               "cannot specify --time with --checkip.\n");
+               }
+       }
+}
+
+/* Prints out the matchinfo. */
+static void pknock_print(const void *ip,
+                                               const struct
xt_entry_match *match, int numeric)
+{
+       const struct ipt_pknock *info;
+       int i;
+
+       info = (const struct ipt_pknock *)match->data;
+
+       printf("pknock ");
+       if (info->option & IPT_PKNOCK_KNOCKPORT) {
+               printf("knockports ");
+               for (i=0; i<info->ports_count; i++)
+                       printf("%s%d", i ? "," : "", info->port[i]);
+               printf(" ");
+       }
+       if (info->option & IPT_PKNOCK_TIME)
+               printf("time %ld ", info->max_time);
+       if (info->option & IPT_PKNOCK_NAME)
+               printf("name %s ", info->rule_name);
+       if (info->option & IPT_PKNOCK_OPENSECRET)
+               printf("opensecret ");
+       if (info->option & IPT_PKNOCK_CLOSESECRET)
+               printf("closesecret ");
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void pknock_save(const void *ip, const struct xt_entry_match *match)
+{
+       int i;
+       const struct ipt_pknock *info = (const struct ipt_pknock *)match->data;
+
+       if (info->option & IPT_PKNOCK_KNOCKPORT) {
+               printf("--knockports ");
+               for (i=0; i<info->ports_count; i++)
+                       printf("%s%d", i ? "," : "", info->port[i]);
+               printf(" ");
+       }
+       if (info->option & IPT_PKNOCK_TIME)
+               printf("--time %ld ", info->max_time);
+       if (info->option & IPT_PKNOCK_NAME)
+               printf("--name %s ", info->rule_name);
+       if (info->option & IPT_PKNOCK_OPENSECRET)
+               printf("--opensecret ");
+       if (info->option & IPT_PKNOCK_CLOSESECRET)
+               printf("--closesecret ");
+       if (info->option & IPT_PKNOCK_STRICT)
+               printf("--strict ");
+       if (info->option & IPT_PKNOCK_CHECKIP)
+               printf("--checkip ");
+}
+
+static struct xtables_match pknock_match = {
+       .name                   = "pknock",
+       .version                = XTABLES_VERSION,
+       .family                 = NFPROTO_IPV4,
+       .size                   = XT_ALIGN(sizeof (struct ipt_pknock)),
+       .userspacesize  = XT_ALIGN(sizeof (struct ipt_pknock)),
+       .help                   = pknock_help,
+       .parse                  = pknock_parse,
+       .final_check    = pknock_check,
+       .print                  = pknock_print,
+       .save                   = pknock_save,
+       .extra_opts             = pknock_opts
+};
+
+void _init(void)
+{
+       xtables_register_match(&pknock_match);
+}


--- pknock-0.5/kernel/ipt_pknock.c      2008-08-24 22:53:32.000000000 -0300
+++ pknock-0.6/kernel/ipt_pknock.c      2009-08-18 18:33:09.000000000 -0300
@@ -1,10 +1,10 @@
 /*
  * Kernel module to implement Port Knocking and SPA matching support.
  *
- * (C) 2006-2008 J. Federico Hernandez
+ * (C) 2006-2009 J. Federico Hernandez
  * (C) 2006 Luis A. Floreani
  *
- * $Id$
+ * $Id: ipt_pknock.c 461 2009-07-01 14:55:11Z fender $
  *
  * This program is released under the terms of GNU GPL version 2.
  */
@@ -28,16 +28,13 @@
 #include <linux/connector.h>

 #include <linux/netfilter/x_tables.h>
-
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
-#include <net/net_namespace.h>
-#endif
-
+#include <linux/netfilter_ipv4/ip_tables.h>
+//#include <linux/netfilter_ipv4/ipt_pknock.h>
 #include "ipt_pknock.h"

+MODULE_LICENSE("GPL");
 MODULE_AUTHOR("J. Federico Hernandez Scarso, Luis A. Floreani");
 MODULE_DESCRIPTION("netfilter match for Port Knocking and SPA");
-MODULE_LICENSE("GPL");

 enum {
        GC_EXPIRATION_TIME      = 65000, /* in msecs */
@@ -50,7 +47,7 @@
                list_for_each_safe((pos), (n), (&head[(i)]))

 #if DEBUG
-       #define DEBUGP(msg, peer) printk(KERN_INFO MOD               \
+       #define DEBUGP(msg, peer) printk(KERN_INFO PKNOCK       \
                        "(S) peer: %u.%u.%u.%u - %s.\n",
                      \
                        NIPQUAD((peer)->ip), msg)
        #define duprintf(format, args...) printk(format, ## args);
@@ -120,8 +117,8 @@
        unsigned int i;

        if ((hash = kmalloc(sizeof(*hash) * size, GFP_ATOMIC)) == NULL) {
-               printk(KERN_ERR MOD "kmalloc() error in alloc_hashtable() "
-                        "function.\n");
+               printk(KERN_ERR PKNOCK
+                                               "kmalloc() error in
alloc_hashtable() function.\n");
                return NULL;
        }

@@ -144,8 +141,8 @@
                case ST_INIT:     return "INIT";
                case ST_MATCHING: return "MATCHING";
                case ST_ALLOWED:  return "ALLOWED";
+               default:                        return "UNKNOWN";
        }
-       return "UNKNOWN";
 }

 /**
@@ -274,8 +271,7 @@
        if (timer_pending(&rule->timer))
                del_timer(&rule->timer);

-       rule->timer.expires = jiffies +
-                                msecs_to_jiffies(ipt_pknock_gc_expir_time);
+       rule->timer.expires = jiffies +
msecs_to_jiffies(ipt_pknock_gc_expir_time);
        add_timer(&rule->timer);
 }

@@ -315,8 +311,9 @@

        hashtable_for_each_safe(pos, n, rule->peer_head, peer_hashsize, i) {
                peer = list_entry(pos, struct peer, head);
-               if (!has_logged_during_this_minute(peer)
-                        && is_time_exceeded(peer, rule->max_time))
+
+               if (!has_logged_during_this_minute(peer) &&
+                                               is_time_exceeded(peer,
rule->max_time))
                {
                         DEBUGP("DESTROYED", peer);
                        list_del(pos);
@@ -333,7 +330,7 @@
  * @return: 0 equals, 1 otherwise
  */
 static inline int
-rulecmp(const struct ipt_pknock_info *info, const struct ipt_pknock_rule *rule)
+rulecmp(const struct ipt_pknock *info, const struct ipt_pknock_rule *rule)
 {
        if (info->rule_name_len != rule->rule_name_len)
                return 1;
@@ -349,7 +346,7 @@
  * @return: rule or NULL
  */
 static inline struct ipt_pknock_rule *
-search_rule(const struct ipt_pknock_info *info)
+search_rule(const struct ipt_pknock *info)
 {
        struct ipt_pknock_rule *rule = NULL;
        struct list_head *pos = NULL, *n = NULL;
@@ -371,7 +368,7 @@
  * @return: 1 success, 0 failure
  */
 static bool
-add_rule(struct ipt_pknock_info *info)
+add_rule(struct ipt_pknock *info)
 {
        struct ipt_pknock_rule *rule = NULL;
        struct list_head *pos = NULL, *n = NULL;
@@ -385,7 +382,7 @@
                        rule->ref_count++;
 #if DEBUG
                        if (info->option & IPT_PKNOCK_CHECKIP) {
-                               printk(KERN_DEBUG MOD "add_rule() (AC)"
+                               printk(KERN_DEBUG PKNOCK "add_rule() (AC)"
                                        " rule found: %s - "
                                        "ref_count: %d\n",
                                        rule->rule_name,
@@ -397,7 +394,7 @@
        }

        if ((rule = kmalloc(sizeof (*rule), GFP_ATOMIC)) == NULL) {
-               printk(KERN_ERR MOD "kmalloc() error in add_rule().\n");
+               printk(KERN_ERR PKNOCK "kmalloc() error in add_rule().\n");
                return false;
        }

@@ -411,7 +408,7 @@
        rule->max_time  = info->max_time;

        if (!(rule->peer_head = alloc_hashtable(peer_hashsize))) {
-               printk(KERN_ERR MOD "alloc_hashtable() error in add_rule().\n");
+               printk(KERN_ERR PKNOCK "alloc_hashtable() error in
add_rule().\n");
                return false;
        }

@@ -421,7 +418,7 @@

        rule->status_proc = create_proc_entry(info->rule_name, 0, pde);
        if (!rule->status_proc) {
-               printk(KERN_ERR MOD "create_proc_entry() error in add_rule()"
+               printk(KERN_ERR PKNOCK "create_proc_entry() error in add_rule()"
                         " function.\n");
                 kfree(rule);
                 return false;
@@ -432,7 +429,7 @@

        list_add(&rule->head, &rule_hashtable[hash]);
 #if DEBUG
-       printk(KERN_INFO MOD "(A) rule_name: %s - created.\n", rule->rule_name);
+       printk(KERN_INFO PKNOCK "(A) rule_name: %s - created.\n",
rule->rule_name);
 #endif
        return true;
 }
@@ -443,7 +440,7 @@
  * @info
  */
 static void
-remove_rule(struct ipt_pknock_info *info)
+remove_rule(struct ipt_pknock *info)
 {
        struct ipt_pknock_rule *rule = NULL;
        struct list_head *pos = NULL, *n = NULL;
@@ -470,27 +467,25 @@
        }
 #if DEBUG
        if (!found) {
-               printk(KERN_INFO MOD "(N) rule not found: %s.\n",
-                        info->rule_name);
+               printk(KERN_INFO PKNOCK "(N) rule not found: %s.\n",
info->rule_name);
                return;
        }
 #endif
        if (rule && rule->ref_count == 0) {
-               hashtable_for_each_safe(pos, n, rule->peer_head,
-                        peer_hashsize, i) {
-
+               hashtable_for_each_safe(pos, n, rule->peer_head,
peer_hashsize, i) {
                         peer = list_entry(pos, struct peer, head);
+
                        if (peer != NULL) {
                                DEBUGP("DELETED", peer);
                                list_del(pos);
                                kfree(peer);
                        }
                }
+
                if (rule->status_proc)
                         remove_proc_entry(info->rule_name, pde);
 #if DEBUG
-               printk(KERN_INFO MOD "(D) rule deleted: %s.\n",
-                        rule->rule_name);
+               printk(KERN_INFO PKNOCK "(D) rule deleted: %s.\n",
rule->rule_name);
 #endif
                if (timer_pending(&rule->timer))
                        del_timer(&rule->timer);
@@ -552,7 +547,7 @@
        struct peer *peer = NULL;

        if ((peer = kmalloc(sizeof (*peer), GFP_ATOMIC)) == NULL) {
-               printk(KERN_ERR MOD "kmalloc() error in new_peer().\n");
+               printk(KERN_ERR PKNOCK "kmalloc() error in new_peer().\n");
                return NULL;
        }

@@ -599,7 +594,7 @@
  * @return: 1 success, 0 failure
  */
 static inline bool
-is_first_knock(const struct peer *peer, const struct ipt_pknock_info *info,
+is_first_knock(const struct peer *peer, const struct ipt_pknock *info,
                 u_int16_t port)
 {
        return (peer == NULL && info->port[0] == port) ? 1 : 0;
@@ -612,7 +607,7 @@
  * @return: 1 success, 0 failure
  */
 static inline bool
-is_wrong_knock(const struct peer *peer, const struct ipt_pknock_info *info,
+is_wrong_knock(const struct peer *peer, const struct ipt_pknock *info,
                u_int16_t port)
 {
        return peer && (info->port[peer->id_port_knocked-1] != port);
@@ -624,9 +619,9 @@
  * @return: 1 success, 0 failure
  */
 static inline bool
-is_last_knock(const struct peer *peer, const struct ipt_pknock_info *info)
+is_last_knock(const struct peer *peer, const struct ipt_pknock *info)
 {
-       return peer && (peer->id_port_knocked-1 == info->count_ports);
+       return peer && (peer->id_port_knocked-1 == info->ports_count);
 }

 /**
@@ -647,7 +642,7 @@
  * @return: 1 success, 0 otherwise
  */
 static bool
-msg_to_userspace_nl(const struct ipt_pknock_info *info,
+msg_to_userspace_nl(const struct ipt_pknock *info,
                 const struct peer *peer, int multicast_group)
 {
        struct cn_msg *m;
@@ -655,7 +650,7 @@

        m = kmalloc(sizeof(*m) + sizeof(msg), GFP_ATOMIC);
        if (!m) {
-               printk(KERN_ERR MOD "kmalloc() error in "
+               printk(KERN_ERR PKNOCK "kmalloc() error in "
                         "msg_to_userspace_nl().\n");
                return false;
        }
@@ -672,7 +667,6 @@
        cn_netlink_send(m, multicast_group, GFP_ATOMIC);

        kfree(m);
-
        return true;
 }

@@ -731,7 +725,7 @@

        hexresult = kmalloc(sizeof(char) * hexa_size, GFP_ATOMIC);
        if (hexresult == NULL) {
-               printk(KERN_ERR MOD "kmalloc() error in has_secret().\n");
+               printk(KERN_ERR PKNOCK "kmalloc() error in has_secret().\n");
                return 0;
        }

@@ -764,7 +758,7 @@

        if (memcmp(hexresult, payload, hexa_size) != 0) {
 #if DEBUG
-               printk(KERN_INFO MOD "secret match failed\n");
+               printk(KERN_INFO PKNOCK "secret match failed\n");
 #endif
                goto out;
        }
@@ -777,7 +771,7 @@
 }

 /**
- * If the peer pass the security policy
+ * If the peer pass the security policy.
  *
  * @peer
  * @info
@@ -786,7 +780,7 @@
  * @return: 1 if pass security, 0 otherwise
  */
 static bool
-pass_security(struct peer *peer, const struct ipt_pknock_info *info,
+pass_security(struct peer *peer, const struct ipt_pknock *info,
         unsigned char *payload, int payload_len)
 {
        if (is_allowed(peer))
@@ -817,7 +811,7 @@
  * @return: 1 if allowed, 0 otherwise
  */
 static bool
-update_peer(struct peer *peer, const struct ipt_pknock_info *info,
+update_peer(struct peer *peer, const struct ipt_pknock *info,
                struct ipt_pknock_rule *rule,
                const struct transport_data *hdr)
 {
@@ -837,9 +831,7 @@
                if (hdr->proto != IPPROTO_UDP)
                        return false;

-               if (!pass_security(peer, info, hdr->payload,
-                        hdr->payload_len))
-               {
+               if (!pass_security(peer, info, hdr->payload,
hdr->payload_len)) {
                         return false;
                }
        }
@@ -869,7 +861,7 @@
 #if DEBUG
                        DEBUGP("TIME EXCEEDED", peer);
                        DEBUGP("DESTROYED", peer);
-                       printk(KERN_INFO MOD "max_time: %ld - time: %ld\n",
+                       printk(KERN_INFO PKNOCK "max_time: %ld - time: %ld\n",
                                        peer->timestamp + info->max_time,
                                        time);
 #endif
@@ -894,7 +886,7 @@
  * @return: 1 if close knock, 0 otherwise
  */
 static inline bool
-is_close_knock(const struct peer *peer, const struct ipt_pknock_info *info,
+is_close_knock(const struct peer *peer, const struct ipt_pknock *info,
                unsigned char *payload, int payload_len)
 {
        /* Check for CLOSE secret. */
@@ -914,6 +906,9 @@
 static int
 #endif
 match(const struct sk_buff *skb,
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+       const struct xt_match_param *par
+#else
        const struct net_device *in,
        const struct net_device *out,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
@@ -924,9 +919,15 @@
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,16)
         unsigned int protoff,
 #endif
-       bool *hotdrop)
+       bool *hotdrop
+#endif
+)
 {
-       const struct ipt_pknock_info *info = matchinfo;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+       const struct ipt_pknock *info = par->matchinfo;
+#else
+       const struct ipt_pknock *info = matchinfo;
+#endif
        struct ipt_pknock_rule *rule = NULL;
        struct peer *peer = NULL;
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
@@ -943,7 +944,11 @@
        int ret = 0;
 #endif

+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+       pptr = skb_header_pointer(skb, par->thoff, sizeof _ports, &_ports);
+#else
        pptr = skb_header_pointer(skb, protoff, sizeof _ports, &_ports);
+#endif

        if (pptr == NULL) {
                /* We've been asked to examine this packet, and we
@@ -951,7 +956,11 @@
                 */
                duprintf("Dropping evil offset=0 tinygram.\n");
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+               *par->hotdrop = true;
+#else
                *hotdrop = true;
+#endif
                return false;
 #else
                *hotdrop = 1;
@@ -970,8 +979,8 @@
                        break;

                default:
-                       printk(KERN_INFO MOD "IP payload protocol "
-                                       "is neither tcp nor udp.\n");
+               printk(KERN_INFO PKNOCK
+                                               "IP payload protocol
is neither tcp nor udp.\n");
                        return false;
        }

@@ -979,7 +988,7 @@

        /* Searches a rule from the list depending on info structure options. */
        if ((rule = search_rule(info)) == NULL) {
-               printk(KERN_INFO MOD "The rule %s doesn't exist.\n",
+               printk(KERN_INFO PKNOCK "The rule %s doesn't exist.\n",
                                info->rule_name);
                goto out;
        }
@@ -1000,11 +1009,10 @@
        /* Sets, updates, removes or checks the peer matching status. */
        if (info->option & IPT_PKNOCK_KNOCKPORT) {
                if ((ret = is_allowed(peer))) {
-                       if (info->option & IPT_PKNOCK_CLOSESECRET
-                                && iph->protocol == IPPROTO_UDP)
+                       if (info->option & IPT_PKNOCK_CLOSESECRET &&
+                                                       iph->protocol
== IPPROTO_UDP)
                        {
-                                if (is_close_knock(peer, info, hdr.payload,
-                                        hdr.payload_len))
+                               if (is_close_knock(peer, info,
hdr.payload, hdr.payload_len))
                                {
                                         reset_knock_status(peer);
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
@@ -1036,9 +1044,9 @@
 }

 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
-#define RETURN_ERR(err) do { printk(KERN_ERR MOD err); return false;
} while (0)
+#define RETURN_ERR(err) do { printk(KERN_ERR PKNOCK err); return
false; } while (0)
 #else
-#define RETURN_ERR(err) do { printk(KERN_ERR MOD err); return 0; } while (0)
+#define RETURN_ERR(err) do { printk(KERN_ERR PKNOCK err); return 0; } while (0)
 #endif

 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,23)
@@ -1046,7 +1054,11 @@
 #else
 static int
 #endif
-checkentry(const char *tablename,
+checkentry(
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+       const struct xt_mtchk_param *par
+#else
+       const char *tablename,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,16)
        const void *ip,
 #else
@@ -1059,17 +1071,22 @@
 #if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,17)
        unsigned int matchsize,
 #endif
-       unsigned int hook_mask)
+       unsigned int hook_mask
+#endif
+)
 {
-       struct ipt_pknock_info *info = matchinfo;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+       struct ipt_pknock *info = par->matchinfo;
+#else
+       struct ipt_pknock *info = matchinfo;
+#endif

        /* Singleton. */
        if (!rule_hashtable) {
                if (!(rule_hashtable = alloc_hashtable(rule_hashsize)))
                        RETURN_ERR("alloc_hashtable() error in checkentry()\n");

-               get_random_bytes(&ipt_pknock_hash_rnd,
-                                sizeof (ipt_pknock_hash_rnd));
+               get_random_bytes(&ipt_pknock_hash_rnd, sizeof
(ipt_pknock_hash_rnd));
        }

        if (!add_rule(info))
@@ -1078,39 +1095,35 @@
        if (!(info->option & IPT_PKNOCK_NAME))
                RETURN_ERR("You must specify --name option.\n");

-       if ((info->option & IPT_PKNOCK_OPENSECRET) && (info->count_ports != 1))
+       if ((info->option & IPT_PKNOCK_OPENSECRET) && (info->ports_count != 1))
                RETURN_ERR("--opensecret must have just one knock port\n");

        if (info->option & IPT_PKNOCK_KNOCKPORT) {
                if (info->option & IPT_PKNOCK_CHECKIP) {
-                       RETURN_ERR("Can't specify --knockports with "
-                                       "--checkip.\n");
+                       RETURN_ERR("Can't specify --knockports with
--checkip.\n");
                }
                if ((info->option & IPT_PKNOCK_OPENSECRET) &&
                                !(info->option & IPT_PKNOCK_CLOSESECRET))
                {
-                       RETURN_ERR("--opensecret must go with "
-                                       "--closesecret.\n");
+                       RETURN_ERR("--opensecret must go with
--closesecret.\n");
                }
                if ((info->option & IPT_PKNOCK_CLOSESECRET) &&
                                !(info->option & IPT_PKNOCK_OPENSECRET))
                {
-                       RETURN_ERR("--closesecret must go with "
-                                       "--opensecret.\n");
+                       RETURN_ERR("--closesecret must go with
--opensecret.\n");
                }
        }

        if (info->option & IPT_PKNOCK_CHECKIP) {
                if (info->option & IPT_PKNOCK_KNOCKPORT)
                {
-                       RETURN_ERR("Can't specify --checkip with "
-                                       "--knockports.\n");
+                       RETURN_ERR("Can't specify --checkip with
--knockports.\n");
                }
                if ((info->option & IPT_PKNOCK_OPENSECRET) ||
                                (info->option & IPT_PKNOCK_CLOSESECRET))
                {
-                       RETURN_ERR("Can't specify --opensecret and "
-                                       "--closesecret with --checkip.\n");
+                       RETURN_ERR("Can't specify --opensecret and
--closesecret"
+                                                       " with --checkip.\n");
                }
                if (info->option & IPT_PKNOCK_TIME)
                        RETURN_ERR("Can't specify --time with --checkip.\n");
@@ -1121,8 +1134,7 @@
                        if (memcmp(info->open_secret, info->close_secret,
                                                info->open_secret_len) == 0)
                        {
-                               RETURN_ERR("opensecret & closesecret cannot "
-                                               "be equal.\n");
+                               RETURN_ERR("opensecret & closesecret
cannot be equal.\n");
                        }
                }
        }
@@ -1136,24 +1148,34 @@

 static void
 destroy(
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+       const struct xt_mtdtor_param *par
+#else
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
-               const struct xt_match *match, void *matchinfo)
+       const struct xt_match *match, void *matchinfo
 #else
-               void *matchinfo, unsigned int matchsize)
+       void *matchinfo, unsigned int matchsize
 #endif
+#endif
+)
 {
-       struct ipt_pknock_info *info = matchinfo;
+#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,28)
+       struct ipt_pknock *info = par->matchinfo;
+#else
+       struct ipt_pknock *info = matchinfo;
+#endif
        /* Removes a rule only if it exits and ref_count is equal to 0. */
        remove_rule(info);
 }

 static struct xt_match ipt_pknock_match __read_mostly = {
        .name           = "pknock",
+       .revision       = 0,
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
-       .family         = AF_INET,
+       .family         = NFPROTO_IPV4,
 #endif
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,17)
-        .matchsize      = sizeof (struct ipt_pknock_info),
+       .matchsize      = sizeof (struct ipt_pknock),
 #endif
        .match          = match,
        .checkentry     = checkentry,
@@ -1163,10 +1185,10 @@

 static int __init ipt_pknock_init(void)
 {
-       printk(KERN_INFO MOD "register.\n");
+       printk(KERN_INFO PKNOCK "register.\n");

        if (request_module(crypto.algo) < 0) {
-               printk(KERN_ERR MOD "request_module('%s') error.\n",
+               printk(KERN_ERR PKNOCK "request_module('%s') error.\n",
                         crypto.algo);
                return -1;
        }
@@ -1174,7 +1196,7 @@
        crypto.tfm = crypto_alloc_hash(crypto.algo, 0, CRYPTO_ALG_ASYNC);

        if (crypto.tfm == NULL) {
-               printk(KERN_ERR MOD "failed to load transform for %s\n",
+               printk(KERN_ERR PKNOCK "failed to load transform for %s\n",
                         crypto.algo);
                return -1;
        }
@@ -1188,7 +1210,7 @@
 #else
        if (!(pde = proc_mkdir("ipt_pknock", proc_net))) {
 #endif
-               printk(KERN_ERR MOD "proc_mkdir() error in _init().\n");
+               printk(KERN_ERR PKNOCK "proc_mkdir() error in _init().\n");
                return -1;
        }
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)
@@ -1200,7 +1222,7 @@

 static void __exit ipt_pknock_fini(void)
 {
-       printk(KERN_INFO MOD "unregister.\n");
+       printk(KERN_INFO PKNOCK "unregister.\n");
 #if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,24)
        remove_proc_entry("ipt_pknock", init_net.proc_net);
 #else


--- pknock-0.5/kernel/ipt_pknock.h      2008-08-15 02:28:25.000000000 -0300
+++ pknock-0.6/kernel/ipt_pknock.h      2009-07-01 11:55:58.000000000 -0300
@@ -4,14 +4,14 @@
  * (C) 2006-2008 J. Federico Hernandez <fede.hernandez@gmail.com>
  * (C) 2006 Luis Floreani <luis.floreani@gmail.com>
  *
- * $Id$
+ * $Id: ipt_pknock.h 461 2009-07-01 14:55:11Z fender $
  *
  * This program is released under the terms of GNU GPL version 2.
  */
 #ifndef _IPT_PKNOCK_H
 #define _IPT_PKNOCK_H

-#define MOD "ipt_pknock: "
+#define PKNOCK "ipt_pknock: "

 #define IPT_PKNOCK_KNOCKPORT           0x01
 #define IPT_PKNOCK_TIME                        0x02
@@ -27,14 +27,14 @@

 #define DEBUG 1

-struct ipt_pknock_info {
+struct ipt_pknock {
        char            rule_name[IPT_PKNOCK_MAX_BUF_LEN + 1];
        int             rule_name_len;
        char            open_secret[IPT_PKNOCK_MAX_PASSWD_LEN + 1];
        int             open_secret_len;
        char            close_secret[IPT_PKNOCK_MAX_PASSWD_LEN + 1];
        int             close_secret_len;
-       u_int8_t        count_ports;    /* number of ports */
+       u_int8_t        ports_count;    /* number of ports */
        u_int16_t       port[IPT_PKNOCK_MAX_PORTS]; /* port[,port,port,...] */
        unsigned long   max_time;       /* max matching time between ports */
        u_int8_t        option;         /* --time, --knock-port, ... */




-- 
Federico

/*
 *  J. Federico Hernandez (fender) {frozenspot; at; gmail; dot; com;}
 *  GPG PubKey: wwwkeys.eu.pgp.net key 6AE78BF2
 *  FP: 26AB 7A1B C2C4 70F8 0E7D  C3F4 9736 5CE2 6AE7 8BF2
 */
