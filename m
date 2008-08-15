From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Update pom-ng docs for new iptables snapshots
Date: Fri, 15 Aug 2008 04:59:34 -0700
Message-ID: <20080815115934.GA22307@linuxace.com>
References: <20080802234156.GA26595@linuxace.com> <alpine.LNX.1.10.0808022011460.21001@fbirervta.pbzchgretzou.qr> <48A2D882.20908@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="OXfL5xGRrasGEqWY"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:43321
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752713AbYHOL7e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:59:34 -0400
Content-Disposition: inline
In-Reply-To: <48A2D882.20908@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 13, 2008 at 02:50:10PM +0200, Patrick McHardy wrote:
> We can do that, but for now I would prefer this patch since I don't
> have the time for checking whether we still want anything.
>
> The patch doesn't apply cleanly though:
>
> patching file README
> Hunk #1 FAILED at 2.
> 1 out of 1 hunk FAILED -- saving rejects to file README.rej
>
> Not sure what the problem is ...

Neither am I, as I just verified it applies cleanly against
patch-o-matic-ng-20080814 snapshot.  Snapshot not reflecting SVN or
git reality?  Attached again to be sure.

Phil

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-pom-docs

diff -ruN pom-orig/README pom-new/README
--- pom-orig/README	2008-08-01 14:55:55.000000000 -0700
+++ pom-new/README	2008-08-02 16:03:04.000000000 -0700
@@ -2,9 +2,13 @@
    This is the patch-o-matic-ng distribution by the netfilter project
    (http://www.netfilter.org/)
 
-   As of iptables-1.2.7, patch-o-matic is distributed as a seperate
+   As of iptables-1.2.7, patch-o-matic is distributed as a separate
    package, available from ftp://ftp.netfilter.org/pub/patch-o-matic-ng.
 
+   NOTE: if you are building against an unreleased (snapshot) version
+   of iptables, make sure you have run release.sh in the iptables tree.
+   Otherwise, runme will fail as it won't find the iptables Makefile.
+
 ================================================================
 
 FOLLOW THESE STEPS:

--OXfL5xGRrasGEqWY--
