From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Bug#150467: user-defined chains vs. iptables module names
Date: Fri, 21 Jun 2002 14:05:06 +0200 (CEST)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <Pine.LNX.4.33.0206211347370.30045-100000@blackhole.kfki.hu>
References: <20020621110337.F5183@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020621110337.F5183@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 21 Jun 2002, Patrick Schaaf wrote:

> > What about simply returning by an error code if there is an attempt to
> > create a chain wich clashes with a target name?
>
> Wasn't there recent discussion about "how do I find all available
> target names"? But I agree in principle, that would be the least
> intrusive shorttime "rationalization" of the now-very-order-dependant
> behaviour.

Here is the patch according to my proposal:

--- iptables.c.orig	Fri Jun 21 13:39:55 2002
+++ iptables.c	Fri Jun 21 13:44:09 2002
@@ -1159,9 +1159,6 @@
 	u_int8_t flags;
 	char buf[BUFSIZ];

-	/* User creates a chain called "REJECT": this overrides the
-	   `REJECT' target module.  Keep feeding them rope until the
-	   revolution... Bwahahahahah */
 	if (!iptc_is_chain(targname, handle))
 		target = find_target(targname, TRY_LOAD);
 	else
@@ -1760,6 +1757,10 @@
 				exit_error(PARAMETER_PROBLEM,
 					   "chain name not allowed to start "
 					   "with `-'\n");
+			if (find_target(optarg, TRY_LOAD))
+				exit_error(PARAMETER_PROBLEM,
+					   "chain name may not clash "
+					   "with target name\n");
 			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
 				    invert);
 			chain = optarg;
--- ip6tables.c.orig	Fri Jun 21 13:44:22 2002
+++ ip6tables.c	Fri Jun 21 13:45:51 2002
@@ -1161,9 +1161,6 @@
 	u_int8_t flags;
 	char buf[BUFSIZ];

-	/* User creates a chain called "REJECT": this overrides the
-	   `REJECT' target module.  Keep feeding them rope until the
-	   revolution... Bwahahahahah */
 	if (!ip6tc_is_chain(targname, handle))
 		target = find_target(targname, TRY_LOAD);
 	else
@@ -1797,6 +1794,14 @@
 			break;

 		case 'N':
+			if (optarg && *optarg == '-')
+				exit_error(PARAMETER_PROBLEM,
+					   "chain name not allowed to start "
+					   "with `-'\n");
+			if (find_target(optarg, TRY_LOAD))
+				exit_error(PARAMETER_PROBLEM,
+					   "chain name may not clash "
+					   "with target name\n");
 			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
 				    invert);
 			chain = optarg;


I believe this is the simplest approach - all other solutions require
changes both in the user interface and the kernel structures.

Regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
WWW-Home: http://www.kfki.hu/~kadlec
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
