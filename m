From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 4/5] hash:ip: add new netmask support to man page
Date: Tue, 21 Mar 2017 14:39:56 -0400
Message-ID: <1490121597-2140-5-git-send-email-johunt@akamai.com>
References: <1490121597-2140-1-git-send-email-johunt@akamai.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay05.akamai.com ([23.79.238.179]:20309 "EHLO
        prod-mail-xrelay05.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757888AbdCUSkH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:40:07 -0400
In-Reply-To: <1490121597-2140-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Updates hash:ip create options to list new mask param to netmask,
describe how it works, and provide examples.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 src/ipset.8 | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/src/ipset.8 b/src/ipset.8
index cd8c3ad..56cc9ea 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -504,7 +504,7 @@ The \fBhash:ip\fR set type uses a hash to store IP host addresses (default) or
 network addresses. Zero valued IP address cannot be stored in a \fBhash:ip\fR
 type of set.
 .PP
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBnetmask\fP \fIcidr\fP ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBnetmask\fP { \fIcidr\fP | \fImask\fP } ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
 .PP
 \fIADD\-ENTRY\fR := \fIipaddr\fR
 .PP
@@ -516,12 +516,17 @@ type of set.
 .PP
 Optional \fBcreate\fR options:
 .TP 
-\fBnetmask\fP \fIcidr\fP
-When the optional \fBnetmask\fP parameter specified, network addresses will be 
-stored in the set instead of IP host addresses. The \fIcidr\fP prefix value must be
-between 1\-32 for IPv4 and between 1\-128 for IPv6. An IP address will be in the set
-if the network address, which is resulted by masking the address with the netmask,
-can be found in the set.
+\fBnetmask\fP { \fIcidr\fP | \fImask\fP }
+The optional \fBnetmask\fP parameter supports two different mask types: \fIcidr\fP,
+\fImask\fP.
+.TP
+\fIcidr\fP
+When the optional \fBnetmask\fP parameter is specified and a \fIcidr\fP argument is
+given, network addresses will be stored in the set instead of IP host addresses. The
+\fIcidr\fP prefix value must be between 1\-32 for IPv4 and between 1\-128 for IPv6.
+An IP address will be in the set if the network address, which is resulted by masking
+the address with the netmask, can be found in the set.
+.IP
 Examples:
 .IP 
 ipset create foo hash:ip netmask 30
@@ -529,6 +534,30 @@ ipset create foo hash:ip netmask 30
 ipset add foo 192.168.1.0/24
 .IP 
 ipset test foo 192.168.1.2
+.TP
+\fImask\fP
+A \fImask\fP argument to \fBnetmask\fP, like \fIcidr\fP, applies the defined mask
+against the address to be added to the set. The difference with \fImask\fP is that
+it can support conventional netmask values like 255.255.255.0 for IPv4 addresses, 
+but it can also support wildcard masks. Allowing the user to define a \fImask\fP
+of any bits to apply to the address. Wildcard masks prove to be very useful for
+IPv6 addressing.
+.IP
+Conventional Mask Examples:
+.IP
+ipset create foo hash:ip netmask 255.255.255.0
+.IP
+ipset add foo 192.168.1.2
+.IP
+ipset test foo 192.168.1.20
+.IP
+Wildcard Mask Examples:
+.IP
+ipset create foo hash:ip family inet6 netmask ffff:ffff:ffff:0:0:ffff::
+.IP
+ipset add foo 1:2:3:4:5:6:7:8
+.IP
+ipset test foo 1:2:3:a:b:6:c:d
 .SS hash:mac
 The \fBhash:mac\fR set type uses a hash to store MAC addresses. Zero valued MAC addresses cannot be stored in a \fBhash:mac\fR
 type of set.
-- 
1.9.1

