From: Jethro Beekman <kernel@jbeekman.nl>
Subject: [RFC PATCH iptables] Hide FORWARD chain if forwarding is not enabled
Date: Sat, 28 Jun 2014 00:34:21 -0700
Message-ID: <53AE6FFD.5080109@jbeekman.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010808030400070108080508"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jbeekman.nl ([149.210.172.151]:57854 "EHLO daxilon.jbeekman.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbaF1Hoc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Jun 2014 03:44:32 -0400
Received: from [2601:9:580:fd:50b1:549f:777d:1955]
	by daxilon.jbeekman.nl with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.76)
	(envelope-from <kernel@jbeekman.nl>)
	id 1X0n9X-0004Xc-UC
	for netfilter-devel@vger.kernel.org; Sat, 28 Jun 2014 09:34:28 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010808030400070108080508
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Most Linux distributions have IP forwarding disabled and it gets me every time.
The FORWARD chain is pretty much useless with forwarding disabled, so make
ip{,6}tables -L print a message notifying the user instead of actually listing
the contents.

Jethro Beekman

--------------010808030400070108080508
Content-Type: text/x-patch;
 name="ip6tables.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ip6tables.c.patch"

--- a/iptables/ip6tables.c	2014-06-28 00:20:35.845014216 -0700
+++ b/iptables/ip6tables.c	2014-06-28 00:21:46.729015280 -0700
@@ -42,6 +42,7 @@
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/socket.h>
+#include <glob.h>
 #include "ip6tables-multi.h"
 #include "xshared.h"
 
@@ -888,6 +889,40 @@
 	return ip6tc_delete_chain(chain, handle);
 }
 
+static int is_forwarding_enabled(void)
+{
+	glob_t globbuf;
+	int opened_any=0,forwarding_enabled=0;
+
+	if (glob("/proc/sys/net/ipv6/conf/*/forwarding",GLOB_NOSORT,NULL,&globbuf)==0)
+	{
+		size_t n;
+		for (n=0;n<globbuf.gl_pathc;n++)
+		{
+			if (strncmp(globbuf.gl_pathv[n],"/proc/sys/net/ipv6/conf/",24)==0 && (strncmp(globbuf.gl_pathv[n]+24,"all/",4)==0 || strncmp(globbuf.gl_pathv[n]+24,"default/",8)==0))
+				continue;
+			FILE* fp=fopen(globbuf.gl_pathv[n],"r");
+			if (fp)
+			{
+				int c=fgetc(fp);
+				if (c!=EOF)
+				{
+					opened_any=1;
+					forwarding_enabled|=c-'0';
+				}
+				fclose(fp);
+			}
+		}
+		
+		globfree(&globbuf);
+	}
+	
+	if (opened_any==0)
+		forwarding_enabled=1;
+	
+	return forwarding_enabled;
+}
+
 static int
 list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 	     int expanded, int linenumbers, struct xtc_handle *handle)
@@ -916,6 +951,7 @@
 	     this = ip6tc_next_chain(handle)) {
 		const struct ip6t_entry *i;
 		unsigned int num;
+		int hide_forward = 0;
 
 		if (chain && strcmp(chain, this) != 0)
 			continue;
@@ -923,7 +959,18 @@
 		if (found) printf("\n");
 
 		if (!rulenum)
-		    print_header(format, this, handle);
+		{
+			if (!is_forwarding_enabled() && 0==strcmp("FORWARD", this))
+				hide_forward = 1;
+			if (hide_forward)
+			{
+				printf("WARNING: Hiding chain FORWARD because no interfaces have IP forwarding enabled.\n");
+				found=1;
+				continue;
+			}
+			else
+				print_header(format, this, handle);
+		}
 		i = ip6tc_first_rule(this, handle);
 
 		num = 0;

--------------010808030400070108080508
Content-Type: text/x-patch;
 name="iptables.c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iptables.c.patch"

--- a/iptables/iptables.c	2013-03-03 13:40:11.000000000 -0800
+++ b/iptables/iptables.c	2014-06-27 17:20:47.109648316 -0700
@@ -39,6 +39,7 @@
 #include <iptables.h>
 #include <xtables.h>
 #include <fcntl.h>
+#include <glob.h>
 #include "xshared.h"
 
 #ifndef TRUE
@@ -871,6 +874,40 @@
 	return iptc_delete_chain(chain, handle);
 }
 
+static int is_forwarding_enabled(void)
+{
+	glob_t globbuf;
+	int opened_any=0,forwarding_enabled=0;
+
+	if (glob("/proc/sys/net/ipv4/conf/*/forwarding",GLOB_NOSORT,NULL,&globbuf)==0)
+	{
+		size_t n;
+		for (n=0;n<globbuf.gl_pathc;n++)
+		{
+			if (strncmp(globbuf.gl_pathv[n],"/proc/sys/net/ipv4/conf/",24)==0 && (strncmp(globbuf.gl_pathv[n]+24,"all/",4)==0 || strncmp(globbuf.gl_pathv[n]+24,"default/",8)==0))
+				continue;
+			FILE* fp=fopen(globbuf.gl_pathv[n],"r");
+			if (fp)
+			{
+				int c=fgetc(fp);
+				if (c!=EOF)
+				{
+					opened_any=1;
+					forwarding_enabled|=c-'0';
+				}
+				fclose(fp);
+			}
+		}
+		
+		globfree(&globbuf);
+	}
+	
+	if (opened_any==0)
+		forwarding_enabled=1;
+	
+	return forwarding_enabled;
+}
+
 static int
 list_entries(const xt_chainlabel chain, int rulenum, int verbose, int numeric,
 	     int expanded, int linenumbers, struct xtc_handle *handle)
@@ -899,6 +936,7 @@
 	     this = iptc_next_chain(handle)) {
 		const struct ipt_entry *i;
 		unsigned int num;
+		int hide_forward = 0;
 
 		if (chain && strcmp(chain, this) != 0)
 			continue;
@@ -906,7 +944,18 @@
 		if (found) printf("\n");
 
 		if (!rulenum)
-			print_header(format, this, handle);
+		{
+			if (!is_forwarding_enabled() && 0==strcmp("FORWARD", this))
+				hide_forward = 1;
+			if (hide_forward)
+			{
+				printf("WARNING: Hiding chain FORWARD because no interfaces have IP forwarding enabled.\n");
+				found=1;
+				continue;
+			}
+			else
+				print_header(format, this, handle);
+		}
 		i = iptc_first_rule(this, handle);
 
 		num = 0;

--------------010808030400070108080508--
