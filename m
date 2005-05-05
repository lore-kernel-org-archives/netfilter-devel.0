From: Phil Oester <kernel@linuxace.com>
Subject: Re: PPTP connection tracking and NAT helper
Date: Thu, 5 May 2005 10:04:00 -0700
Message-ID: <20050505170400.GA20178@linuxace.com>
References: <4279291E.2060103@nit.ca>
	<20050505075258.GM30482@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="fUYQa+Pmc3FrFX/N"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20050505075258.GM30482@sunbeam.de.gnumonks.org>
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


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 05, 2005 at 09:52:58AM +0200, Harald Welte wrote:
> please read the netfilter-devel archive.  I get asked this question at
> least ten times a week:
> 
> There is no pptp/gre conntrack and nat helper for 2.6.11+, since this
> kernel version contains a redesigned infrastructure for such helpers.

How bout we make it harder for people to try?  Attached patch adds
a 'Requires' to pptp in pom, and fixes up broken Requires handling.

Phil



--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-pptprequires

diff -ru pom-orig/Netfilter_POM.pm pom-new/Netfilter_POM.pm
--- pom-orig/Netfilter_POM.pm	2005-04-01 02:09:00.000000000 -0500
+++ pom-new/Netfilter_POM.pm	2005-05-05 12:59:22.633618136 -0400
@@ -196,10 +196,10 @@
 		# if the requirement refers to the tested patchlet,
 		# project version must fulfil the requirement.
 		# Multiple requirements are ANDed.
-		return 0 if $pver eq $prog 
-			    && !$self->version_compare($proj, $op, $ver);
+		return 1 if $pver eq $prog 
+			    && $self->version_compare($proj, $op, $ver);
 	}
-	return 1;
+	return 0;
 }
 
 # are the requirements for a specific patchlet fulfilled?
diff -ru pom-orig/pptp-conntrack-nat/help pom-new/pptp-conntrack-nat/help
--- pom-orig/pptp-conntrack-nat/help	2003-11-17 03:09:34.000000000 -0500
+++ pom-new/pptp-conntrack-nat/help	2005-05-05 11:25:47.241525968 -0400
@@ -20,3 +20,4 @@
 - doesnt' support multiple calls within one session
 - you have to recompile your iptables userspace program since some 
   structure sizes change
+- does NOT work with kernels > 2.6.10
diff -ru pom-orig/pptp-conntrack-nat/info pom-new/pptp-conntrack-nat/info
--- pom-orig/pptp-conntrack-nat/info	2005-02-01 08:23:01.000000000 -0500
+++ pom-new/pptp-conntrack-nat/info	2005-05-05 12:57:47.510079112 -0400
@@ -3,3 +3,4 @@
 Status: Testing, especially the 2.6.x port
 Repository: extra
 Depends: !nat-reservations
+Requires: linux < 2.6.11

--fUYQa+Pmc3FrFX/N--
