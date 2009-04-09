From: Michael Granzow <mgranzow@zeus.com>
Subject: Multiple IPs on iptables/ip6tables command line
Date: Thu, 9 Apr 2009 18:24:36 +0100
Message-ID: <49DE2F54.1040703@zeus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail150.messagelabs.com ([85.158.136.115]:19301 "EHLO
	mail150.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754851AbZDIRY7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:24:59 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It seems iptables (and ip6tables) can only process one IP address at a
time which makes blocking many IP addresses a rather slow process.

The following patch seems to work for me and I'd be grateful for your
feedback.

Thanks,
Michael

commit 377b05e967bc0623364089f2d57018ab2604ea95
Author: Michael Granzow <mgranzow@zeus.com>
Date:   Thu Apr 9 16:38:09 2009 +0100

    Allow multiple IPs on the command-line for iptables/ip6tables.
    
    With this patch, you can process more than one IP address with a single
    invocation of iptables, for instance:
    
     # ip6tables -A INPUT -s 2001:db8::a,2001:db8::b,2001:db8::c -j DROP
     # ip6tables -I INPUT -s 2001:db8::d,2001:db8::e -j DROP
     # ip6tables -D INPUT -s 2001:db8::a,2001:db8::d -j DROP

diff --git a/include/xtables.h.in b/include/xtables.h.in
index a399f90..a2b5f31 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -211,6 +211,7 @@ extern void xtables_init(void);
 extern void xtables_set_nfproto(uint8_t);
 extern void *xtables_calloc(size_t, size_t);
 extern void *xtables_malloc(size_t);
+extern void *xtables_realloc(void*, size_t);
 
 extern int xtables_insmod(const char *, const char *, bool);
 extern int xtables_load_ko(const char *, bool);
@@ -256,6 +257,8 @@ extern struct in_addr
*xtables_numeric_to_ipaddr(const char *);
 extern struct in_addr *xtables_numeric_to_ipmask(const char *);
 extern void xtables_ipparse_any(const char *, struct in_addr **,
     struct in_addr *, unsigned int *);
+extern void xtables_ipparse_multiple(const char *name, struct in_addr
**addrpp,
+    struct in_addr **maskpp, unsigned int *naddrs);
 
 extern struct in6_addr *xtables_numeric_to_ip6addr(const char *);
 extern const char *xtables_ip6addr_to_numeric(const struct in6_addr *);
@@ -263,6 +266,8 @@ extern const char *xtables_ip6addr_to_anyname(const
struct in6_addr *);
 extern const char *xtables_ip6mask_to_numeric(const struct in6_addr *);
 extern void xtables_ip6parse_any(const char *, struct in6_addr **,
     struct in6_addr *, unsigned int *);
+extern void xtables_ip6parse_multiple(const char *name, struct in6_addr
**addrpp,
+    struct in6_addr **maskpp, unsigned int *naddrs);
 
 /**
  * Print the specified value to standard output, quoting dangerous
diff --git a/ip6tables.c b/ip6tables.c
index 35067f8..5433382 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -281,9 +281,9 @@ exit_printhelp(struct xtables_rule_match *matches)
 
 "Options:\n"
 "[!] --proto    -p proto    protocol: by number or name, eg. `tcp'\n"
-"[!] --source    -s address[/mask]\n"
+"[!] --source    -s address[/mask][,address[/mask]]*\n"
 "                source specification\n"
-"[!] --destination -d address[/mask]\n"
+"[!] --destination -d address[/mask][,address[/mask]]*\n"
 "                destination specification\n"
 "[!] --in-interface -i input name[+]\n"
 "                network interface name ([+] for wildcard)\n"
@@ -740,8 +740,10 @@ append_entry(const ip6t_chainlabel chain,
          struct ip6t_entry *fw,
          unsigned int nsaddrs,
          const struct in6_addr saddrs[],
+         const struct in6_addr smasks[],
          unsigned int ndaddrs,
          const struct in6_addr daddrs[],
+         const struct in6_addr dmasks[],
          int verbose,
          struct ip6tc_handle *handle)
 {
@@ -750,8 +752,10 @@ append_entry(const ip6t_chainlabel chain,
 
     for (i = 0; i < nsaddrs; i++) {
         fw->ipv6.src = saddrs[i];
+        fw->ipv6.smsk = smasks[i];
         for (j = 0; j < ndaddrs; j++) {
             fw->ipv6.dst = daddrs[j];
+            fw->ipv6.dmsk = dmasks[j];
             if (verbose)
                 print_firewall_line(fw, handle);
             ret &= ip6tc_append_entry(chain, fw, handle);
@@ -784,8 +788,10 @@ insert_entry(const ip6t_chainlabel chain,
          unsigned int rulenum,
          unsigned int nsaddrs,
          const struct in6_addr saddrs[],
+         const struct in6_addr smasks[],
          unsigned int ndaddrs,
          const struct in6_addr daddrs[],
+         const struct in6_addr dmasks[],
          int verbose,
          struct ip6tc_handle *handle)
 {
@@ -794,8 +800,10 @@ insert_entry(const ip6t_chainlabel chain,
 
     for (i = 0; i < nsaddrs; i++) {
         fw->ipv6.src = saddrs[i];
+        fw->ipv6.smsk = smasks[i];
         for (j = 0; j < ndaddrs; j++) {
             fw->ipv6.dst = daddrs[j];
+            fw->ipv6.dmsk = dmasks[j];
             if (verbose)
                 print_firewall_line(fw, handle);
             ret &= ip6tc_insert_entry(chain, fw, rulenum, handle);
@@ -806,7 +814,7 @@ insert_entry(const ip6t_chainlabel chain,
 }
 
 static unsigned char *
-make_delete_mask(struct ip6t_entry *fw, struct xtables_rule_match *matches)
+make_delete_mask(struct xtables_rule_match *matches)
 {
     /* Establish mask for comparison */
     unsigned int size;
@@ -843,8 +851,10 @@ delete_entry(const ip6t_chainlabel chain,
          struct ip6t_entry *fw,
          unsigned int nsaddrs,
          const struct in6_addr saddrs[],
+         const struct in6_addr smasks[],
          unsigned int ndaddrs,
          const struct in6_addr daddrs[],
+         const struct in6_addr dmasks[],
          int verbose,
          struct ip6tc_handle *handle,
          struct xtables_rule_match *matches)
@@ -853,11 +863,13 @@ delete_entry(const ip6t_chainlabel chain,
     int ret = 1;
     unsigned char *mask;
 
-    mask = make_delete_mask(fw, matches);
+    mask = make_delete_mask(matches);
     for (i = 0; i < nsaddrs; i++) {
         fw->ipv6.src = saddrs[i];
+        fw->ipv6.smsk = smasks[i];
         for (j = 0; j < ndaddrs; j++) {
             fw->ipv6.dst = daddrs[j];
+            fw->ipv6.dmsk = dmasks[j];
             if (verbose)
                 print_firewall_line(fw, handle);
             ret &= ip6tc_delete_entry(chain, fw, mask, handle);
@@ -1291,9 +1303,9 @@ int do_command6(int argc, char *argv[], char
**table, struct ip6tc_handle **hand
     int invert = 0;
     unsigned int nsaddrs = 0, ndaddrs = 0;
     struct in6_addr *saddrs = NULL, *daddrs = NULL;
+    struct in6_addr *smasks = NULL, *dmasks = NULL;
 
     int c, verbose = 0;
-    unsigned i;
     const char *chain = NULL;
     const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
     const char *policy = NULL, *newname = NULL;
@@ -1811,12 +1823,12 @@ int do_command6(int argc, char *argv[], char
**table, struct ip6tc_handle **hand
     }
 
     if (shostnetworkmask)
-        xtables_ip6parse_any(shostnetworkmask, &saddrs,
-                                 &fw.ipv6.smsk, &nsaddrs);
+        xtables_ip6parse_multiple(shostnetworkmask, &saddrs,
+                      &smasks, &nsaddrs);
 
     if (dhostnetworkmask)
-        xtables_ip6parse_any(dhostnetworkmask, &daddrs,
-                                 &fw.ipv6.dmsk, &ndaddrs);
+        xtables_ip6parse_multiple(dhostnetworkmask, &daddrs,
+                      &dmasks, &ndaddrs);
 
     if ((nsaddrs > 1 || ndaddrs > 1) &&
         (fw.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
@@ -1921,13 +1933,15 @@ int do_command6(int argc, char *argv[], char
**table, struct ip6tc_handle **hand
     switch (command) {
     case CMD_APPEND:
         ret = append_entry(chain, e,
-                   nsaddrs, saddrs, ndaddrs, daddrs,
+                   nsaddrs, saddrs, smasks,
+                   ndaddrs, daddrs, dmasks,
                    options&OPT_VERBOSE,
                    *handle);
         break;
     case CMD_DELETE:
         ret = delete_entry(chain, e,
-                   nsaddrs, saddrs, ndaddrs, daddrs,
+                   nsaddrs, saddrs, smasks,
+                   ndaddrs, daddrs, dmasks,
                    options&OPT_VERBOSE,
                    *handle, matches);
         break;
@@ -1941,7 +1955,8 @@ int do_command6(int argc, char *argv[], char
**table, struct ip6tc_handle **hand
         break;
     case CMD_INSERT:
         ret = insert_entry(chain, e, rulenum - 1,
-                   nsaddrs, saddrs, ndaddrs, daddrs,
+                   nsaddrs, saddrs, smasks,
+                   ndaddrs, daddrs, dmasks,
                    options&OPT_VERBOSE,
                    *handle);
         break;
@@ -2001,12 +2016,10 @@ int do_command6(int argc, char *argv[], char
**table, struct ip6tc_handle **hand
         e = NULL;
     }
 
-    for (i = 0; i < nsaddrs; i++)
-        free(&saddrs[i]);
-
-    for (i = 0; i < ndaddrs; i++)
-        free(&daddrs[i]);
-
+    free(saddrs);
+    free(smasks);
+    free(daddrs);
+    free(dmasks);
     xtables_free_opts(1);
 
     return ret;
diff --git a/iptables.c b/iptables.c
index 649baf4..ccf265c 100644
--- a/iptables.c
+++ b/iptables.c
@@ -294,9 +294,9 @@ exit_printhelp(struct xtables_rule_match *matches)
 
 "Options:\n"
 "[!] --proto    -p proto    protocol: by number or name, eg. `tcp'\n"
-"[!] --source    -s address[/mask]\n"
+"[!] --source    -s address[/mask][,address[/mask]]*\n"
 "                source specification\n"
-"[!] --destination -d address[/mask]\n"
+"[!] --destination -d address[/mask][,address[/mask]]*\n"
 "                destination specification\n"
 "[!] --in-interface -i input name[+]\n"
 "                network interface name ([+] for wildcard)\n"
@@ -742,8 +742,10 @@ append_entry(const ipt_chainlabel chain,
          struct ipt_entry *fw,
          unsigned int nsaddrs,
          const struct in_addr saddrs[],
+         const struct in_addr smasks[],
          unsigned int ndaddrs,
          const struct in_addr daddrs[],
+         const struct in_addr dmasks[],
          int verbose,
          struct iptc_handle *handle)
 {
@@ -752,8 +754,10 @@ append_entry(const ipt_chainlabel chain,
 
     for (i = 0; i < nsaddrs; i++) {
         fw->ip.src.s_addr = saddrs[i].s_addr;
+        fw->ip.smsk.s_addr = smasks[i].s_addr;
         for (j = 0; j < ndaddrs; j++) {
             fw->ip.dst.s_addr = daddrs[j].s_addr;
+            fw->ip.dmsk.s_addr = dmasks[j].s_addr;
             if (verbose)
                 print_firewall_line(fw, handle);
             ret &= iptc_append_entry(chain, fw, handle);
@@ -786,8 +790,10 @@ insert_entry(const ipt_chainlabel chain,
          unsigned int rulenum,
          unsigned int nsaddrs,
          const struct in_addr saddrs[],
+         const struct in_addr smasks[],
          unsigned int ndaddrs,
          const struct in_addr daddrs[],
+         const struct in_addr dmasks[],
          int verbose,
          struct iptc_handle *handle)
 {
@@ -796,8 +802,10 @@ insert_entry(const ipt_chainlabel chain,
 
     for (i = 0; i < nsaddrs; i++) {
         fw->ip.src.s_addr = saddrs[i].s_addr;
+        fw->ip.smsk.s_addr = smasks[i].s_addr;
         for (j = 0; j < ndaddrs; j++) {
             fw->ip.dst.s_addr = daddrs[j].s_addr;
+            fw->ip.dmsk.s_addr = dmasks[j].s_addr;
             if (verbose)
                 print_firewall_line(fw, handle);
             ret &= iptc_insert_entry(chain, fw, rulenum, handle);
@@ -808,7 +816,7 @@ insert_entry(const ipt_chainlabel chain,
 }
 
 static unsigned char *
-make_delete_mask(struct ipt_entry *fw, struct xtables_rule_match *matches)
+make_delete_mask(struct xtables_rule_match *matches)
 {
     /* Establish mask for comparison */
     unsigned int size;
@@ -845,8 +853,10 @@ delete_entry(const ipt_chainlabel chain,
          struct ipt_entry *fw,
          unsigned int nsaddrs,
          const struct in_addr saddrs[],
+         const struct in_addr smasks[],
          unsigned int ndaddrs,
          const struct in_addr daddrs[],
+         const struct in_addr dmasks[],
          int verbose,
          struct iptc_handle *handle,
          struct xtables_rule_match *matches)
@@ -855,11 +865,13 @@ delete_entry(const ipt_chainlabel chain,
     int ret = 1;
     unsigned char *mask;
 
-    mask = make_delete_mask(fw, matches);
+    mask = make_delete_mask(matches);
     for (i = 0; i < nsaddrs; i++) {
         fw->ip.src.s_addr = saddrs[i].s_addr;
+        fw->ip.smsk.s_addr = smasks[i].s_addr;
         for (j = 0; j < ndaddrs; j++) {
             fw->ip.dst.s_addr = daddrs[j].s_addr;
+            fw->ip.dmsk.s_addr = dmasks[j].s_addr;
             if (verbose)
                 print_firewall_line(fw, handle);
             ret &= iptc_delete_entry(chain, fw, mask, handle);
@@ -1313,7 +1325,8 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
     struct ipt_entry fw, *e = NULL;
     int invert = 0;
     unsigned int nsaddrs = 0, ndaddrs = 0;
-    struct in_addr *saddrs = NULL, *daddrs = NULL;
+    struct in_addr *saddrs = NULL, *smasks = NULL;
+    struct in_addr *daddrs = NULL, *dmasks = NULL;
 
     int c, verbose = 0;
     const char *chain = NULL;
@@ -1848,12 +1861,12 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
     }
 
     if (shostnetworkmask)
-        xtables_ipparse_any(shostnetworkmask, &saddrs,
-                    &fw.ip.smsk, &nsaddrs);
+        xtables_ipparse_multiple(shostnetworkmask, &saddrs,
+                     &smasks, &nsaddrs);
 
     if (dhostnetworkmask)
-        xtables_ipparse_any(dhostnetworkmask, &daddrs,
-                    &fw.ip.dmsk, &ndaddrs);
+        xtables_ipparse_multiple(dhostnetworkmask, &daddrs,
+                     &dmasks, &ndaddrs);
 
     if ((nsaddrs > 1 || ndaddrs > 1) &&
         (fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
@@ -1961,13 +1974,15 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
     switch (command) {
     case CMD_APPEND:
         ret = append_entry(chain, e,
-                   nsaddrs, saddrs, ndaddrs, daddrs,
+                   nsaddrs, saddrs, smasks,
+                   ndaddrs, daddrs, dmasks,
                    options&OPT_VERBOSE,
                    *handle);
         break;
     case CMD_DELETE:
         ret = delete_entry(chain, e,
-                   nsaddrs, saddrs, ndaddrs, daddrs,
+                   nsaddrs, saddrs, smasks,
+                   ndaddrs, daddrs, dmasks,
                    options&OPT_VERBOSE,
                    *handle, matches);
         break;
@@ -1981,7 +1996,8 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
         break;
     case CMD_INSERT:
         ret = insert_entry(chain, e, rulenum - 1,
-                   nsaddrs, saddrs, ndaddrs, daddrs,
+                   nsaddrs, saddrs, smasks,
+                   ndaddrs, daddrs, dmasks,
                    options&OPT_VERBOSE,
                    *handle);
         break;
@@ -2042,7 +2058,9 @@ int do_command(int argc, char *argv[], char
**table, struct iptc_handle **handle
     }
 
     free(saddrs);
+    free(smasks);
     free(daddrs);
+    free(dmasks);
     xtables_free_opts(1);
 
     return ret;
diff --git a/xtables.c b/xtables.c
index a01d4ea..09488a0 100644
--- a/xtables.c
+++ b/xtables.c
@@ -271,6 +271,18 @@ void *xtables_malloc(size_t size)
     return p;
 }
 
+void *xtables_realloc(void* ptr, size_t size)
+{
+    void *p;
+
+    if ((p = realloc(ptr, size)) == NULL) {
+        perror("ip[6]tables: realloc failed");
+        exit(1);
+    }
+
+    return p;
+}
+
 static char *get_modprobe(void)
 {
     int procfile;
@@ -1133,6 +1145,90 @@ static struct in_addr *parse_ipmask(const char *mask)
     return &maskaddr;
 }
 
+void
+xtables_ipparse_multiple(const char *name, struct in_addr **addrpp,
+             struct in_addr **maskpp, unsigned int *naddrs)
+{
+    struct in_addr *addrp;
+    char buf[256];
+    char *p;
+    int i, j;
+    unsigned int len, n;
+
+    unsigned int count = 1;
+    const char* loop = name;
+    while( (loop = strchr(loop, (int)',')) != NULL ) {
+        ++count;
+        ++loop; // skip ','
+    }
+
+    *addrpp = xtables_malloc(sizeof(struct in_addr) * count);
+    *maskpp = xtables_malloc(sizeof(struct in_addr) * count);
+
+    loop = name;
+
+    for( i = 0; i < count /*NB: count can grow*/; i++ ) {
+        if( !loop ) break;
+        if( ',' == *loop) ++loop;
+        if( '\0' == *loop ) break;
+        p = strchr(loop, (int)',');
+        if( p )
+            len = p-loop;
+        else
+            len = strlen( loop );
+        if( 0 == len || (sizeof(buf)-1) < len ) break;
+
+        strncpy(buf, loop, len);
+        buf[len] = '\0';
+                loop += len;
+        if ((p = strrchr(buf, '/')) != NULL) {
+            *p = '\0';
+            addrp = parse_ipmask(p + 1);
+        } else
+            addrp = parse_ipmask(NULL);
+        memcpy(*maskpp+i, addrp, sizeof(*addrp));
+
+        /* if a null mask is given, the name is ignored, like in "any/0" */
+        if ((*maskpp+i)->s_addr == 0L)
+            strcpy(buf, "0.0.0.0"); // a bit pointless to process
multiple addresses in this case...
+
+        addrp = ipparse_hostnetwork(buf, &n);
+        if( 1 < n ) {
+            count += n - 1;
+            *addrpp = xtables_realloc(*addrpp,
+                sizeof(struct in_addr) * count);
+            *maskpp = xtables_realloc(*maskpp,
+                sizeof(struct in_addr) * count);
+            for( j = 0; j < n; ++j ) // for each new addr
+                           memcpy(*addrpp+i+j, addrp+j, sizeof(*addrp));
+            for( j = 1; j < n; ++j ) // for each new mask
+                           memcpy(*maskpp+i+j, *maskpp+i, sizeof(*addrp));
+            i += n - 1;
+        } else {
+            memcpy(*addrpp+i, addrp, sizeof(*addrp));
+        }
+        // free what ipparse_hostnetwork had allocated:
+        free(addrp);
+    }
+    *naddrs = count;
+    for (i = 0, j = 0; i < n; i++) {
+           (*addrpp+i)->s_addr &= (*maskpp+i)->s_addr;
+#if 0
+    j++;
+    // this is O(N^2) in the number of ip addresses.  user should
+    // provide unique ips
+        for (k = 0; k < j - 1; k++) {
+            if (addrp[k].s_addr == addrp[j - 1].s_addr) {
+                (*naddrs)--;
+                j--;
+                break;
+            }
+        }
+#endif
+    }
+}
+
+
 /**
  * xtables_ipparse_any - transform arbitrary name to in_addr
  *
@@ -1364,6 +1460,84 @@ static struct in6_addr *parse_ip6mask(char *mask)
     return &maskaddr;
 }
 
+void
+xtables_ip6parse_multiple(const char *name, struct in6_addr **addrpp,
+              struct in6_addr **maskpp, unsigned int *naddrs)
+{
+    struct in6_addr *addrp;
+    char buf[256];
+    char *p;
+    int i, j;
+    unsigned int len, n;
+    unsigned int count = 1;
+    const char* loop = name;
+    while( (loop = strchr(loop, (int)',')) != NULL ) {
+        ++count;
+        ++loop; // skip ','
+    }
+
+    *addrpp = xtables_malloc(sizeof(struct in6_addr) * count);
+    *maskpp = xtables_malloc(sizeof(struct in6_addr) * count);
+
+    loop = name;
+
+    for( i = 0; i < count /*NB: count can grow*/; i++ ) {
+        if( !loop ) break;
+        if( ',' == *loop) ++loop;
+        if( '\0' == *loop ) break;
+        p = strchr(loop, (int)',');
+        if( p )
+            len = p-loop;
+        else
+            len = strlen( loop );
+        if( 0 == len || (sizeof(buf)-1) < len ) break;
+        
+        strncpy(buf, loop, len);
+        buf[len] = '\0';
+                loop += len;
+        if ((p = strrchr(buf, '/')) != NULL) {
+            *p = '\0';
+            addrp = parse_ip6mask(p + 1);
+        } else
+            addrp = parse_ip6mask(NULL);
+        memcpy((*maskpp)+i, addrp, sizeof(*addrp));
+
+        /* if a null mask is given, the name is ignored, like in "any/0" */
+        if (!memcmp(*maskpp+i, &in6addr_any, sizeof(in6addr_any)))
+            strcpy(buf, "::");
+
+        addrp = ip6parse_hostnetwork(buf, &n);
+                /* ip6parse_hostnetwork only ever returns one IP
+                   address (it exits if the resolution fails).
+                   Therefore, n will always be 1 here.  Leaving the
+                   code below in anyway in case ip6parse_hostnetwork
+                   is improved some day to behave like
+                   ipparse_hostnetwork: */
+        if( 1 < n ) {
+            count += n - 1;
+            *addrpp = xtables_realloc(*addrpp,
+                sizeof(struct in6_addr) * count);
+            *maskpp = xtables_realloc(*maskpp,
+                sizeof(struct in6_addr) * count);
+            for(j = 0; j < n; ++j) // for each new addr
+                memcpy(*addrpp+i+j, addrp+j, sizeof(*addrp));
+            for(j = 1; j < n; ++j) // for each new mask
+                memcpy(*maskpp+i+j, *maskpp+i, sizeof(*addrp));
+            i += n - 1;
+        } else {
+            memcpy(*addrpp+i, addrp, sizeof(*addrp));
+        }
+        /* free what ip6parse_hostnetwork had allocated: */
+        free(addrp);
+    }
+    *naddrs = count;
+    for (i = 0, j = 0; i < n; i++) {
+        int k;
+        for (k = 0; k < 4; k++)
+            (*addrpp+i)->s6_addr32[k] &= (*maskpp+i)->s6_addr32[k];
+    }
+}
+
 void xtables_ip6parse_any(const char *name, struct in6_addr **addrpp,
                           struct in6_addr *maskp, unsigned int *naddrs)
 {

