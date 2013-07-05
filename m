From: Bill Fink <billfink@mindspring.com>
Subject: conntrackd segfault on EPSV IPv6 ftp command when using ftp
 ExpectationSync
Date: Fri, 5 Jul 2013 02:03:12 -0400
Message-ID: <20130705020312.25783ccd.billfink@mindspring.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:33132 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497Ab3GEGOl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 02:14:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[not sure whether to send to netfilter or netfilter-devel,
so sending to both, but trim replies as appropriate]

I am trying to use the ftp ExpectationSync capability of conntrackd
for both IPv4 and IPv6 for connections through a pair of bridged
firewalls (primary / hot backup).  I have the following config
snippet in conntrackd.conf:

	Options {
		ExpectationSync {
			ftp
			sip
			ras	# for H.323
			q.931	# for H.323
			h.245	# for H.323
		}
	}

For IPv4, things work as expected.  But when I try the basic
analogous IPv6 test to the suggested IPv4 test from the
documentation:

x100ssd2% nc 2001:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx:xxxx 21
220 FTP Server ready.
USER anonymous
331 Anonymous login ok, send your complete email address as your password
PASS bill@
230-
                *** Welcome to this anonymous ftp server! ***
 
     You are user 1 out of a maximum of 10 authorized anonymous logins.
     The current time here is Thu Jul 04 23:40:51 2013.
     If you experience any problems here, contact : root@localhost
 
 
230 Anonymous login ok, restrictions apply.
EPSV
229 Entering Extended Passive Mode (|||1584|)

As soon as I enter the EPSV command, I get the following
conntrackd segfault:

Jul  5 00:41:06 sen-fw1 kernel: [274422.060695] conntrackd[4821]: segfault at 0 ip 000000000040c660 sp 00007fffebb098a8 error 4 in conntrackd[400000+3d000]

I am using a Fedora 17 3.7.3-101.fc17.x86_64 kernel with
conntrack-tools-1.4.0-1.fc17.x86_64.

I had to use the attached patch to get "conntrackd -R" to resync
both IPv4 and IPv6 (enabled with a "Family IPv4-IPv6" entry in
conntrackd.conf).  It works well for me for the basic ct table,
but I'm not sure about the expect table part since I can't really
exercise it due to the segfault.  Note the segfault also occurs
with the original unpatched conntrackd, so it's not related to
my patch.

Any help would be greatly appreciated.

					-Thanks

					-Bill

P.S.  I am not subscribed to either netfilter or netfilter-devel.



Patch to add IPv6 to "conntrackd -R":
------------------------------------------------------------------------

diff -Nurp conntrack-tools-1.4.0.orig/src/netlink.c conntrack-tools-1.4.0/src/netlink.c
--- conntrack-tools-1.4.0.orig/src/netlink.c	2012-09-21 10:06:07.000000000 -0400
+++ conntrack-tools-1.4.0/src/netlink.c	2013-07-04 23:32:36.302310719 -0400
@@ -148,7 +148,16 @@ void nl_resize_socket_buffer(struct nfct
 
 int nl_dump_conntrack_table(struct nfct_handle *h)
 {
-	return nfct_query(h, NFCT_Q_DUMP, &CONFIG(family));
+	int fam, ret;
+
+	if (!CONFIG(both_ipv4_ipv6))
+		return nfct_query(h, NFCT_Q_DUMP, &CONFIG(family));
+	fam = AF_INET;
+	ret = nfct_query(h, NFCT_Q_DUMP, &fam);
+	if (ret < 0)
+		return ret;
+	fam = AF_INET6;
+	return nfct_query(h, NFCT_Q_DUMP, &fam);
 }
 
 static int
@@ -380,7 +389,16 @@ int nl_get_expect(struct nfct_handle *h,
 
 int nl_dump_expect_table(struct nfct_handle *h)
 {
-	return nfexp_query(h, NFCT_Q_DUMP, &CONFIG(family));
+	int fam, ret;
+
+	if (!CONFIG(both_ipv4_ipv6))
+		return nfexp_query(h, NFCT_Q_DUMP, &CONFIG(family));
+	fam = AF_INET;
+	ret = nfexp_query(h, NFCT_Q_DUMP, &fam);
+	if (ret < 0)
+		return ret;
+	fam = AF_INET6;
+	return nfexp_query(h, NFCT_Q_DUMP, &fam);
 }
 
 int nl_flush_expect_table(struct nfct_handle *h)
diff -Nurp conntrack-tools-1.4.0.orig/src/read_config_yy.y conntrack-tools-1.4.0/src/read_config_yy.y
--- conntrack-tools-1.4.0.orig/src/read_config_yy.y	2012-09-21 10:06:07.000000000 -0400
+++ conntrack-tools-1.4.0/src/read_config_yy.y	2013-03-20 18:47:36.391160857 -0400
@@ -1193,10 +1193,27 @@ scheduler_line : T_PRIO T_NUMBER
 
 family : T_FAMILY T_STRING
 {
-	if (strncmp($2, "IPv6", strlen("IPv6")) == 0)
+	if (strncmp($2, "IPv6-IPv4", strlen("IPv6-IPv4")) == 0) {
 		conf.family = AF_INET6;
-	else
+		conf.both_ipv4_ipv6 = 1;
+	}
+	else if (strncmp($2, "IPv6", strlen("IPv6")) == 0) {
+		conf.family = AF_INET6;
+		conf.both_ipv4_ipv6 = 0;
+	}
+	else if (strncmp($2, "IPv4-IPv6", strlen("IPv4-IPv6")) == 0) {
+		conf.family = AF_INET;
+		conf.both_ipv4_ipv6 = 1;
+	}
+	else if (strncmp($2, "IPv4", strlen("IPv4")) == 0) {
 		conf.family = AF_INET;
+		conf.both_ipv4_ipv6 = 0;
+	}
+	else {
+		print_err(CTD_CFG_WARN, "%s is not a valid Family, "
+					"ignoring", $2);
+		break;
+	}
 };
 
 event_iterations_limit : T_EVENT_ITER_LIMIT T_NUMBER
@@ -1864,8 +1881,10 @@ init_config(char *filename)
 	fclose(fp);
 
 	/* default to IPv4 */
-	if (CONFIG(family) == 0)
+	if (CONFIG(family) == 0) {
 		CONFIG(family) = AF_INET;
+		CONFIG(both_ipv4_ipv6) = 0;
+	}
 
 	/* set to default is not specified */
 	if (strcmp(CONFIG(lockfile), "") == 0)
