From: Phil Oester <kernel@linuxace.com>
Subject: Re: 3896 pom-ng broken
Date: Tue, 10 May 2005 17:51:21 -0700
Message-ID: <20050511005121.GA31199@linuxace.com>
References: <d5q4mb$fmo$1@sea.gmane.org> <20050510154354.GB28833@linuxace.com>
	<4280DBB3.9070905@ufomechanic.net>
	<debc30fc0505101214699d85b8@mail.gmail.com>
	<debc30fc050510121564dd0703@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="EVF5PPMfhYS0aIcm"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?iso-8859-1?B?Suly9G1l?= Poulin <jeromepoulin@gmail.com>
Content-Disposition: inline
In-Reply-To: <debc30fc050510121564dd0703@mail.gmail.com>
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


--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, May 10, 2005 at 03:15:25PM -0400, Jérôme Poulin wrote:
> On 5/10/05, Jérôme Poulin <jeromepoulin@gmail.com> wrote:
> > See my e-mail, posted the same problem / solution and got no answer,
> > only 3 patchs apply with that new snapshot, other patch with no
> > requirements or even with a valid requirement won't apply, only set,
> > h323, goto and another apply, anyway see my other mails.

Indeed, my patch was broken.  But the 'Requires' handling is also broken, but
will take something nontrivial to fix.

In the interim, the below patch reverts my changes, and adds a necessary
2nd Requires to pptp.  Harald, please apply.

Phil



--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-requiresfix

diff -ruN pom-orig/Netfilter_POM.pm pom-new/Netfilter_POM.pm
--- pom-orig/Netfilter_POM.pm	2005-05-10 18:15:27.177796688 -0400
+++ pom-new/Netfilter_POM.pm	2005-05-10 18:16:58.249951616 -0400
@@ -196,10 +196,10 @@
 		# if the requirement refers to the tested patchlet,
 		# project version must fulfil the requirement.
 		# Multiple requirements are ANDed.
-		return 1 if $pver eq $prog 
-			    && $self->version_compare($proj, $op, $ver);
+		return 0 if $pver eq $prog 
+			    && !$self->version_compare($proj, $op, $ver);
 	}
-	return 0;
+	return 1;
 }
 
 # are the requirements for a specific patchlet fulfilled?
diff -ruN pom-orig/pptp-conntrack-nat/info pom-new/pptp-conntrack-nat/info
--- pom-orig/pptp-conntrack-nat/info	2005-05-10 20:35:15.584820688 -0400
+++ pom-new/pptp-conntrack-nat/info	2005-05-10 20:34:12.225452776 -0400
@@ -4,3 +4,4 @@
 Repository: extra
 Depends: !nat-reservations
 Requires: linux < 2.6.11
+Requires: linux-2.6 < 2.6.11

--EVF5PPMfhYS0aIcm--
