From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [PATCH] remove reference to '!' in limit man page entrance
Date: Sat, 23 Oct 2004 12:58:21 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200410231258.21150.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_NljeBoHqcae3R6X"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_NljeBoHqcae3R6X
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

Please apply the attached trivial patch.

cheers,
Bart

--Boundary-00=_NljeBoHqcae3R6X
Content-Type: text/x-diff;
  charset="us-ascii";
  name="limitinvert.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="limitinvert.diff"

--- iptables/iptables.8.old	2004-10-23 12:15:10.000000000 +0200
+++ iptables/iptables.8	2004-10-23 12:15:47.000000000 +0200
@@ -607,8 +607,8 @@ or range of values.
 .BR "--length " "\fIlength\fP[:\fIlength\fP]"
 .SS limit
 This module matches at a limited rate using a token bucket filter.
-A rule using this extension will match until this limit is reached
-(unless the `!' flag is used).  It can be used in combination with the
+A rule using this extension will match until this limit is reached.
+It can be used in combination with the
 .B LOG
 target to give limited logging, for example.
 .TP
--- iptables/ip6tables.8.old	2004-10-23 12:46:23.000000000 +0200
+++ iptables/ip6tables.8	2004-10-23 12:46:43.000000000 +0200
@@ -471,8 +471,8 @@ or range of values.
 .BR "--length " "\fIlength\fP[:\fIlength\fP]"
 .SS limit
 This module matches at a limited rate using a token bucket filter.
-A rule using this extension will match until this limit is reached
-(unless the `!' flag is used).  It can be used in combination with the
+A rule using this extension will match until this limit is reached.
+It can be used in combination with the
 .B LOG
 target to give limited logging, for example.
 .TP

--Boundary-00=_NljeBoHqcae3R6X--
