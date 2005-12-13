From: Jones Desougi <jones@ingate.com>
Subject: Re: [LARTC] MARK: targinfosize 8 != 4
Date: Tue, 13 Dec 2005 19:09:47 +0100
Message-ID: <200512131809.jBDI9lAW028466@usagi.ingate.se>
References: <00fe01c5ffb5$f0a7cf20$455f030a@askeyrd3>
	<20051213091820.GA1021@DervishD> <439EB826.3070002@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: salim.si@askey.com.tw, lartc@mailman.ds9a.nl,
	netfilter-devel@lists.netfilter.org, lartc@dervishd.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-reply-to: <439EB826.3070002@trash.net> (message from Patrick McHardy on
	Tue, 13 Dec 2005 13:01:42 +0100)
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> That can't be the reason, all revisions of a single match/target are
> in the same object file and the supported revision is (supposed to be)
> probed. Salim, can you send a strace of the failing iptables command?

The key being "supposed to be". :-)
Try the patch below. (It's bug #413 in bugzilla)

    /Jones

Signed-off-by: Jones Desougi <jones@ingate.com>

diff -r -u --new-file iptables-1.3.4/include/ip6tables.h iptables/include/ip6tables.h
--- iptables-1.3.4/include/ip6tables.h	2005-06-24 18:34:17.000000000 +0200
+++ iptables/include/ip6tables.h	2005-11-19 16:31:07.000000000 +0100
@@ -130,6 +130,7 @@
 
 enum ip6t_tryload {
 	DONT_LOAD,
+	DURING_LOAD,
 	TRY_LOAD,
 	LOAD_MUST_SUCCEED
 };
diff -r -u --new-file iptables-1.3.4/include/iptables.h iptables/include/iptables.h
--- iptables-1.3.4/include/iptables.h	2005-11-19 16:26:12.000000000 +0100
+++ iptables/include/iptables.h	2005-11-19 16:30:47.000000000 +0100
@@ -162,6 +162,7 @@
 
 enum ipt_tryload {
 	DONT_LOAD,
+	DURING_LOAD,
 	TRY_LOAD,
 	LOAD_MUST_SUCCEED
 };
diff -r -u --new-file iptables-1.3.4/ip6tables.c iptables/ip6tables.c
--- iptables-1.3.4/ip6tables.c	2005-07-29 15:28:56.000000000 +0200
+++ iptables/ip6tables.c	2005-11-19 16:36:22.000000000 +0100
@@ -734,7 +734,7 @@
   	}
 
 #ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD) {
+	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
 		char path[strlen(lib_dir) + sizeof("/libip6t_.so")
 			 + strlen(name)];
 		if (!icmphack)
@@ -986,7 +986,7 @@
 	}
 
 #ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD) {
+	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
 		char path[strlen(lib_dir) + sizeof("/libip6t_.so")
 			 + strlen(name)];
 		sprintf(path, "%s/libip6t_%s.so", lib_dir, name);
@@ -1058,7 +1058,7 @@
 		exit(1);
 	}
 
-	if (find_match(me->name, DONT_LOAD, NULL)) {
+	if (find_match(me->name, DURING_LOAD, NULL)) {
 		fprintf(stderr, "%s: match `%s' already registered.\n",
 			program_name, me->name);
 		exit(1);
@@ -1088,7 +1088,7 @@
 		exit(1);
 	}
 
-	if (find_target(me->name, DONT_LOAD)) {
+	if (find_target(me->name, DURING_LOAD)) {
 		fprintf(stderr, "%s: target `%s' already registered.\n",
 			program_name, me->name);
 		exit(1);
diff -r -u --new-file iptables-1.3.4/iptables.c iptables/iptables.c
--- iptables-1.3.4/iptables.c	2005-11-19 16:26:12.000000000 +0100
+++ iptables/iptables.c	2005-11-19 16:34:17.000000000 +0100
@@ -710,7 +710,7 @@
 	}
 
 #ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD) {
+	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
 		char path[strlen(lib_dir) + sizeof("/libipt_.so")
 			 + strlen(name)];
 		sprintf(path, "%s/libipt_%s.so", lib_dir, name);
@@ -1021,7 +1021,7 @@
 	}
 
 #ifndef NO_SHARED_LIBS
-	if (!ptr && tryload != DONT_LOAD) {
+	if (!ptr && tryload != DONT_LOAD && tryload != DURING_LOAD) {
 		char path[strlen(lib_dir) + sizeof("/libipt_.so")
 			 + strlen(name)];
 		sprintf(path, "%s/libipt_%s.so", lib_dir, name);
@@ -1146,7 +1146,7 @@
 		exit(1);
 	}
 
-	old = find_match(me->name, DONT_LOAD, NULL);
+	old = find_match(me->name, DURING_LOAD, NULL);
 	if (old) {
 		if (old->revision == me->revision) {
 			fprintf(stderr,
@@ -1202,7 +1202,7 @@
 		exit(1);
 	}
 
-	old = find_target(me->name, DONT_LOAD);
+	old = find_target(me->name, DURING_LOAD);
 	if (old) {
 		struct iptables_target **i;
 
