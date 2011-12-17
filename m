From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/5] Use modern -m conntrack match
Date: Sat, 17 Dec 2011 22:02:18 +0100
Message-ID: <1324155743-25999-2-git-send-email-jengelh@medozas.de>
References: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: eric@regit.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:50754 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab1LQVC2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 16:02:28 -0500
In-Reply-To: <1324155743-25999-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 secure-conntrack-helpers.rst |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/secure-conntrack-helpers.rst b/secure-conntrack-helpers.rst
index acf6670..cbd5fd5 100644
--- a/secure-conntrack-helpers.rst
+++ b/secure-conntrack-helpers.rst
@@ -90,7 +90,7 @@ blindly use helpers. You must take into account the topology of your network
 when setting parameters linked to a helper.
 
 For each helper, you must carefully open the RELATED flow. All iptables statement 
-using "-m state --state RELATED" should be used in conjunction with the
+using "-m conntrack --ctstate RELATED" should be used in conjunction with the
 choice of a helper and of IP parameters.  Doing that, you will be able to describe
 how the helper must be used with respect to your network and information system
 architecture.
@@ -100,26 +100,26 @@ Example: FTP helper
 
 For example, if you run an FTP server, you can setup ::
 
- iptables -A FORWARD -m state --state RELATED -m helper \
+ iptables -A FORWARD -m conntrack --ctstate RELATED -m helper \
  	--helper ftp -d $MY_FTP_SERVER -p tcp \
 	--dport 1024: -j ACCEPT
 
 If your clients are authorized to access FTP outside of your network, you
 can add ::
 
- iptables -A FORWARD -m state --state RELATED -m helper \
+ iptables -A FORWARD -m conntrack --ctstate RELATED -m helper \
  	--helper ftp -o $OUT_IFACE -p tcp \
 	--dport 1024: -j ACCEPT
- iptables -A FORWARD -m state --state RELATED -m helper \
+ iptables -A FORWARD -m conntrack --ctstate RELATED -m helper \
  	--helper ftp -i $OUT_IFACE -p tcp \
 	--dport 1024: -j ACCEPT
 
 The same syntax applies to IPV6 ::
 
- ip6tables -A FORWARD -m state --state RELATED -m helper \
+ ip6tables -A FORWARD -m conntrack --ctstate RELATED -m helper \
  	--helper ftp -o $OUT_IFACE -p tcp \
 	--dport 1024: -j ACCEPT
- ip6tables -A FORWARD -m state --state RELATED -m helper \
+ ip6tables -A FORWARD -m conntrack --ctstate RELATED -m helper \
  	--helper ftp -i $OUT_IFACE -p tcp \
 	--dport 1024: -j ACCEPT
 
@@ -129,7 +129,7 @@ Example: SIP helper
 You should limit the RELATED connection due to the SIP helper by restricting
 the destination address to the RTP server farm of your provider ::
 
- iptables -A FORWARD -m state --state RELATED -m helper \
+ iptables -A FORWARD -m conntrack --ctstate RELATED -m helper \
  	--helper sip -d $ISP_RTP_SERVER -p udp -j ACCEPT
 
 Example: h323 helper
-- 
1.7.3.4

