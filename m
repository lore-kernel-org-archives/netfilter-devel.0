From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: [patch 2/4] Add support for --set-counters to iptables -P
Date: Mon, 12 May 2008 20:25:02 +0200
Message-ID: <1210616702.3442.33.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-gIogXI0m7KFkCHWzpuMS"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:52235 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYELSZK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:25:10 -0400
Received: from henriknordstrom.net (183.159.216.81.static.tb.siw.siwnet.net [81.216.159.183])
	by vps1.henriknordstrom.net (8.13.8/8.13.8/Debian-3) with ESMTP id m4CIP2Po011797
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 20:25:02 +0200
Received: from henrik ([127.0.0.1])
	(authenticated bits=0)
	by henriknordstrom.net (8.12.11.20060308/8.12.8) with ESMTP id m4CIP3aH027761
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 20:25:03 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-gIogXI0m7KFkCHWzpuMS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Adds support for setting the policy counters

iptables -P INPUT -J DROP -c 10 20

Regards
Henrik

--=-gIogXI0m7KFkCHWzpuMS
Content-Disposition: attachment; filename=policycounters.patch
Content-Type: text/x-patch; name=policycounters.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -165,7 +165,7 @@ static char commands_v_options[NUMBER_OF
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x',' '},
 /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'}
 };
 
@@ -1842,7 +1842,7 @@ int do_command(int argc, char *argv[], c
 		ret = iptc_rename_chain(chain, newname,	handle);
 		break;
 	case CMD_SET_POLICY:
-		ret = iptc_set_policy(chain, policy, NULL, handle);
+		ret = iptc_set_policy(chain, policy, options&OPT_COUNTERS ? &fw.counters : NULL, handle);
 		break;
 	default:
 		/* We should never reach this... */
Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -165,7 +165,7 @@ static char commands_v_options[NUMBER_OF
 /*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x'},
+/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' '},
 /*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'}
 };
 
@@ -1802,7 +1802,7 @@ int do_command6(int argc, char *argv[], 
 		ret = ip6tc_rename_chain(chain, newname,	handle);
 		break;
 	case CMD_SET_POLICY:
-		ret = ip6tc_set_policy(chain, policy, NULL, handle);
+		ret = ip6tc_set_policy(chain, policy, options&OPT_COUNTERS ? &fw.counters : NULL, handle);
 		break;
 	default:
 		/* We should never reach this... */

--=-gIogXI0m7KFkCHWzpuMS--

