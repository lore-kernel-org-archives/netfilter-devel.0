From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] multiport does not support invert
Date: Sat, 18 Sep 2004 19:44:07 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414C73E7.1070500@trash.net>
References: <20040917221015.GA3228@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040201050205080407070508"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040917221015.GA3228@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------040201050205080407070508
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Phil Oester wrote:

>A few weeks back I submitted a patch to document the invert option
>of multiport, without noticing that it doesn't actually support invert.
>I've looked at it, and it is a compatibility nightmare to try to add
>support for it while still supporting old kernel/userspace.
>
>So, here's a patch to throw an error on this:
>
>    iptables -A FORWARD -m multiport -p tcp ! --dport 1,2,3 -j DROP
>
>instead of silently accepting it and potentially causing issues.
>
Thanks, but your patch doesn't catch all cases:

# iptables -p tcp -m multiport ! --port 1
iptables v1.3.0: multiport does not support invert
Try `iptables -h' or 'iptables --help' for more information.
# iptables -p tcp -m multiport --port ! 1
iptables v1.3.0: invalid port/service `!' specified
Try `iptables -h' or 'iptables --help' for more information.

I've applied this patch, which gives:

# iptables -p tcp -m multiport ! --port 1
iptables v1.3.0: multiport does not support invert
Try `iptables -h' or 'iptables --help' for more information.
# iptables -p tcp -m multiport --port ! 1
iptables v1.3.0: multiport does not support invert
Try `iptables -h' or 'iptables --help' for more information.

Regards
Patrick


--------------040201050205080407070508
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Index: extensions/libip6t_multiport.c
===================================================================
RCS file: /cvsroot/iptables/extensions/libip6t_multiport.c,v
retrieving revision 1.5
diff -u -r1.5 libip6t_multiport.c
--- extensions/libip6t_multiport.c	14 Jul 2003 20:01:29 -0000	1.5
+++ extensions/libip6t_multiport.c	18 Sep 2004 17:41:47 -0000
@@ -112,6 +112,7 @@
 
 	switch (c) {
 	case '1':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -120,6 +121,7 @@
 		break;
 
 	case '2':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -128,6 +130,7 @@
 		break;
 
 	case '3':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -138,6 +141,10 @@
 	default:
 		return 0;
 	}
+
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport does not support invert");
 
 	if (*flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_mport.c
===================================================================
RCS file: /cvsroot/iptables/extensions/libipt_mport.c,v
retrieving revision 1.6
diff -u -r1.6 libipt_mport.c
--- extensions/libipt_mport.c	14 Jul 2003 20:01:29 -0000	1.6
+++ extensions/libipt_mport.c	18 Sep 2004 17:41:48 -0000
@@ -136,6 +136,7 @@
 
 	switch (c) {
 	case '1':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_SOURCE;
@@ -143,6 +144,7 @@
 		break;
 
 	case '2':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_DESTINATION;
@@ -150,6 +152,7 @@
 		break;
 
 	case '3':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		parse_multi_ports(argv[optind-1], minfo, proto);
 		minfo->flags = IPT_MPORT_EITHER;
@@ -159,6 +162,10 @@
 	default:
 		return 0;
 	}
+
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport does not support invert");
 
 	if (*flags)
 		exit_error(PARAMETER_PROBLEM,
Index: extensions/libipt_multiport.c
===================================================================
RCS file: /cvsroot/iptables/extensions/libipt_multiport.c,v
retrieving revision 1.7
diff -u -r1.7 libipt_multiport.c
--- extensions/libipt_multiport.c	14 Jul 2003 20:01:29 -0000	1.7
+++ extensions/libipt_multiport.c	18 Sep 2004 17:41:48 -0000
@@ -112,6 +112,7 @@
 
 	switch (c) {
 	case '1':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -120,6 +121,7 @@
 		break;
 
 	case '2':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -128,6 +130,7 @@
 		break;
 
 	case '3':
+		check_inverse(argv[optind-1], &invert, &optind, 0);
 		proto = check_proto(entry);
 		multiinfo->count = parse_multi_ports(argv[optind-1],
 						     multiinfo->ports, proto);
@@ -138,6 +141,10 @@
 	default:
 		return 0;
 	}
+
+	if (invert)
+		exit_error(PARAMETER_PROBLEM,
+			   "multiport does not support invert");
 
 	if (*flags)
 		exit_error(PARAMETER_PROBLEM,

--------------040201050205080407070508--
