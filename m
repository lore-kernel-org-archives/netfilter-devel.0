From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] time match does not track DST changes
Date: Fri, 24 Sep 2004 16:11:26 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040924231126.GA9030@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="CE+1k2dSO48ffgeK"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The time match does not follow daylight savings time changes.
Without adding timezone information to the kernel, fixing the
module doesn't seem possible.  

I considered adding a /proc entry to configure whether to add
an hour or not, but doing so would still require user intervention,
and the user can just as easily fix things up with this:

   hwclock --systohc ; hwclock --hctosys

So, the below just adds a couple notes so users are aware of 
this limitation.

Unless someone thinks of a better idea, this closes bugzilla #75.


Phil

--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-time

diff -ru ipt-orig/extensions/libipt_time.c ipt-new/extensions/libipt_time.c
--- ipt-orig/extensions/libipt_time.c	2004-05-16 01:48:04.000000000 -0700
+++ ipt-new/extensions/libipt_time.c	2004-09-24 16:03:30.289605227 -0700
@@ -21,6 +21,7 @@
 " [ --timestart value ] [ --timestop value] [ --days listofdays ] [ --datestart value ] [ --datestop value ]\n"
 "          timestart value : HH:MM (default 00:00)\n"
 "          timestop  value : HH:MM (default 23:59)\n"
+"                            Note: daylight savings time changes are not tracked\n"
 "          listofdays value: a list of days to apply\n"
 "                            from Mon,Tue,Wed,Thu,Fri,Sat,Sun\n"
 "                            Coma speparated, no space, case sensitive.\n"
diff -ru pom-orig/time/help pom-new/time/help
--- pom-orig/time/help	2004-05-05 03:11:24.000000000 -0700
+++ pom-new/time/help	2004-09-24 16:01:05.830178992 -0700
@@ -30,3 +30,5 @@
   -A OUTPUT -m time --timestart 8:00 --timestop 18:00 --Days Mon --date-stop 2010
   will match the packets (locally generated) that have a departure timestamp
   in the range 8:00->18:00 on Monday only, until 2010
+
+NOTE: the time match does not track changes in daylight savings time

--CE+1k2dSO48ffgeK--
