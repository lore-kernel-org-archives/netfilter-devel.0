From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] update quota manpage for SMP
Date: Tue, 1 May 2007 16:08:05 -0700
Message-ID: <20070501230805.GA21022@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="17pEHd4RhPHOinZp"
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The quota match works fine on SMP, so update the manpage to reflect
this.  Closes bugzilla #564.

Phil



--17pEHd4RhPHOinZp
Content-Type: application/x-troff-man
Content-Disposition: attachment; filename="patch-quota.man"
Content-Transfer-Encoding: quoted-printable

--- ipt-orig/extensions/libipt_quota.man	2005-03-31 22:54:23.000000000 -080=
0=0A+++ ipt-new/extensions/libipt_quota.man	2007-05-01 15:55:51.000000000 -=
0700=0A@@ -4,4 +4,3 @@=0A .BI "--quota " "bytes"=0A The quota in bytes.=0A =
.P=0A-KNOWN BUGS: this does not work on SMP systems.=0A
--17pEHd4RhPHOinZp--
