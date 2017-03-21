From: Josh Hunt <johunt@akamai.com>
Subject: [PATCH 5/5] hash:ip,port: add netmask support to man page
Date: Tue, 21 Mar 2017 14:39:57 -0400
Message-ID: <1490121597-2140-6-git-send-email-johunt@akamai.com>
References: <1490121597-2140-1-git-send-email-johunt@akamai.com>
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        Josh Hunt <johunt@akamai.com>
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from prod-mail-xrelay07.akamai.com ([23.79.238.175]:36232 "EHLO
        prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S933304AbdCUSus (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Mar 2017 14:50:48 -0400
In-Reply-To: <1490121597-2140-1-git-send-email-johunt@akamai.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Adds netmask to hash:ip,port create options, describe how it works, and
provide examples.

Signed-off-by: Josh Hunt <johunt@akamai.com>
---
 src/ipset.8 | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/src/ipset.8 b/src/ipset.8
index 56cc9ea..d0ca810 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -710,7 +710,7 @@ The \fBhash:ip,port\fR set type uses a hash to store IP address and port number
 The port number is interpreted together with a protocol (default TCP) and zero
 protocol number cannot be used.
 .PP
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBnetmask\fP { \fIcidr\fP | \fImask\fP } ] [ \fBtimeout\fR \fIvalue\fR ] [ \fBcounters\fP ] [ \fBcomment\fP ] [ \fBskbinfo\fP ]
 .PP
 \fIADD\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR
 .PP
@@ -761,6 +761,51 @@ ipset add foo 192.168.1.1,udp:53
 ipset add foo 192.168.1.1,vrrp:0
 .IP 
 ipset test foo 192.168.1.1,80
+.TP
+Optional \fBcreate\fR options:
+.TP 
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
+Examples:
+.IP 
+ipset create foo hash:ip,port netmask 30
+.IP 
+ipset add foo 192.168.1.0/24,80
+.IP 
+ipset test foo 192.168.1.2,80
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
+ipset create foo hash:ip,port netmask 255.255.255.0
+.IP
+ipset add foo 192.168.1.2,22
+.IP
+ipset test foo 192.168.1.20,22
+.IP
+Wildcard Mask Examples:
+.IP
+ipset create foo hash:ip,port family inet6 netmask ffff:ffff:ffff:0:0:ffff::
+.IP
+ipset add foo 1:2:3:4:5:6:7:8,udp:53
+.IP
+ipset test foo 1:2:3:a:b:6:c:d,udp:53
 .SS hash:net,port
 The \fBhash:net,port\fR set type uses a hash to store different sized IP network
 address and port pairs. The port number is interpreted together with a protocol
-- 
1.9.1

