From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/4] doc: clarify terms "ip" and "cidrsize"
Date: Wed, 11 Nov 2009 13:54:21 +0100
Message-ID: <1257944062-6988-5-git-send-email-jengelh@medozas.de>
References: <1257944062-6988-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43740 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758AbZKKMy3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2009 07:54:29 -0500
In-Reply-To: <1257944062-6988-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

IP refers to Internet Protocol; adding "address" is therefore beneficial.
The CIDR size is better known as "prefix length".

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ipset.8 |   74 +++++++++++++++++++++++++++++++-------------------------------
 1 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/ipset.8 b/ipset.8
index a132817..eb803ec 100644
--- a/ipset.8
+++ b/ipset.8
@@ -99,15 +99,15 @@ the set, then add all elements. Then create the next set, add all its elements
 and so on. Also, it is a restore operation, so the sets being restored must 
 not exist.
 .TP
-\fB\-A\fP, \fB\-\-add\fP \fIsetname\fP \fIIP\fP
-Add an IP entry to a set.
+\fB\-A\fP, \fB\-\-add\fP \fIsetname\fP \fIaddress\fP
+Add an IP address entry to a set.
 .TP
-\fB\-D\fP, \fB\-\-del\fP \fIsetname\fP \fIIP\fP
-Delete an IP entry from a set. 
+\fB\-D\fP, \fB\-\-del\fP \fIsetname\fP \fIaddress\fP
+Delete an IP address entry from a set.
 .TP
-\fB-T\fP, \fB\-\-test\fP \fIsetname\fP \fIIP\fP
-Test wether an IP entry is in a set or not. Exit status number is zero
-if the tested IP is in the set and nonzero if it is missing from 
+\fB-T\fP, \fB\-\-test\fP \fIsetname\fP \fIaddress\fP
+Test wether an IP address entry is in a set or not. Exit status number is zero
+if the tested address is in the set and nonzero if it is missing from
 the set.
 .TP
 \fB\-H\fP, \fB\-\-help\fP [\fIsettype\fP]
@@ -153,20 +153,20 @@ by masking the address with the specified netmask, can be found in the set.
 .P
 Options to use when creating an ipmap set:
 .TP
-\fB\-\-from\fP \fIfrom-ip\fP
+\fB\-\-from\fP \fIfrom-addr\fP
 .TP
-\fB\-\-to\fP \fIto-ip\fP
-Create an ipmap set from the specified range.
+\fB\-\-to\fP \fIto-addr\fP
+Create an ipmap set from the specified address range.
 .TP
-\fB\-\-network\fP \fIip\fP\fB/\fP\fImask\fP
+\fB\-\-network\fP \fIaddr\fP\fB/\fP\fImask\fP
 Create an ipmap set from the specified network.
 .TP
-\fB\-\-netmask\fP \fIcidr-netmask\fP
+\fB\-\-netmask\fP \fIprefixlen\fP
 When the optional
 \fB\-\-netmask\fP
 parameter specified, network addresses will be 
-stored in the set instead of IP addresses, and the \fIfrom-ip\fP parameter
-must be a network address. The \fIcidr-netmask\fP value must be between 1-31.
+stored in the set instead of IP addresses, and the \fIfrom-addr\fP parameter
+must be a network address. The \fIprefixlen\fP value must be between 1-31.
 .PP
 Example:
 .IP
@@ -183,12 +183,12 @@ part is not mandatory.
 .P
 Options to use when creating an macipmap set:
 .TP
-\fB\-\-from\fP \fIfrom-ip\fP
+\fB\-\-from\fP \fIfrom-addr\fP
 .TP
-\fB\-\-to\fP \fIto-ip\fP
-Create a macipmap set from the specified range.
+\fB\-\-to\fP \fIto-addr\fP
+Create a macipmap set from the specified address range.
 .TP
-\fB\-\-network\fP \fIip\fP\fB/\fP\fImask\fP
+\fB\-\-network\fP \fIaddr\fP\fB/\fP\fImask\fP
 Create a macipmap set from the specified network.
 .TP
 \fB\-\-matchunset\fP
@@ -216,14 +216,14 @@ Options to use when creating an portmap set:
 \fB\-\-from\fP \fIfrom-port\fP
 .TP
 \fB\-\-to\fP \fIto-port\fP
-Create a portmap set from the specified range.
+Create a portmap set from the specified port range.
 .SS iphash
 The iphash set type uses a hash to store IP addresses.
 In order to avoid clashes in the hash double-hashing, and as a last
 resort, dynamic growing of the hash performed. The iphash set type is
 great to store random addresses. If the optional
 \fB\-\-netmask\fP
-parameter is specified with a CIDR netmask value between 1-31 then
+parameter is specified with a CIDR prefix length value between 1-31 then
 network addresses are stored in the given set: i.e an
 IP address will be in the set if the network address, which is resulted
 by masking the address with the specified netmask, can be found in the set.
@@ -243,11 +243,11 @@ an IP to the hash could not be performed after
 \fIprobes\fP
 number of double-hashing. 
 .TP
-\fB\-\-netmask\fP \fIcidr-netmask\fP
+\fB\-\-netmask\fP \fIprefixlen\fP
 When the optional
 \fB\-\-netmask\fP
 parameter specified, network addresses will be 
-stored in the set instead of IP addresses. The \fIcidr-netmask\fP value must
+stored in the set instead of IP addresses. The \fIprefixlen\fP value must
 be between 1-31.
 .P
 The iphash type of sets can store up to 65536 entries. If a set is full,
@@ -271,7 +271,7 @@ network addresses. The
 .I
 IP
 "address" used in the ipset commands must be in the form
-"\fIip-address\fP\fB/\fP\fIcidr-size\fP"
+"\fIip-address\fP\fB/\fP\fIprefixlen\fP"
 where the CIDR block size must be in the inclusive range of 1-31.
 In order to avoid clashes in the hash 
 double-hashing, and as a last resort, dynamic growing of the hash performed.
@@ -324,12 +324,12 @@ target.
 .P
 Options to use when creating an ipporthash set:
 .TP
-\fB\-\-from\fP \fIfrom-ip\fP
+\fB\-\-from\fP \fIfrom-addr\fP
 .TP
-\fB\-\-to\fP \fIto-ip\fP
-Create an ipporthash set from the specified range.
+\fB\-\-to\fP \fIto-addr\fP
+Create an ipporthash set from the specified address range.
 .TP
-\fB\-\-network\fP \fIip\fP\fB/\fP\fImask\fP
+\fB\-\-network\fP \fIaddr\fP\fB/\fP\fImask\fP
 Create an ipporthash set from the specified network.
 .TP
 \fB\-\-hashsize\fP \fIhashsize\fP
@@ -363,12 +363,12 @@ target.
 .P
 Options to use when creating an ipportiphash set:
 .TP
-\fB\-\-from\fP \fIfrom-ip\fP
+\fB\-\-from\fP \fIfrom-addr\fP
 .TP
-\fB\-\-to\fP \fIto-ip\fP
-Create an ipportiphash set from the specified range.
+\fB\-\-to\fP \fIto-addr\fP
+Create an ipportiphash set from the specified address range.
 .TP
-\fB\-\-network\fP \fIip\fP\fB/\fP\fImask\fP
+\fB\-\-network\fP \fIaddr\fP\fB/\fP\fImask\fP
 Create an ipportiphash set from the specified network.
 .TP
 \fB\-\-hashsize\fP \fIhashsize\fP
@@ -394,7 +394,7 @@ parameters are arbitrary, but the size of the network address must be
 between /1-/31. When adding, deleting 
 and testing values in an ipportnethash type of set, the entries must be
 specified as
-"\fIip\fP\fB,\fP\fIip\fP\fB/\fP\fIcidr-size\fP".
+"\fIaddress\fP\fB,\fP\fIaddress\fP\fB/\fP\fIprefixlen\fP".
 .P
 The ipportnethash types of sets evaluates three src/dst parameters of the 
 "set"
@@ -404,12 +404,12 @@ target.
 .P
 Options to use when creating an ipportnethash set:
 .TP
-\fB\-\-from\fP \fIfrom-ip\fP
+\fB\-\-from\fP \fIfrom-address\fP
 .TP
-\fB\-\-to\fP \fIto-ip\fP
+\fB\-\-to\fP \fIto-address\fP
 Create an ipporthash set from the specified range.
 .TP
-\fB\-\-network\fP \fIip\fP\fB/\fP\fImask\fP
+\fB\-\-network\fP \fIaddress\fP\fB/\fP\fImask\fP
 Create an ipporthash set from the specified network.
 .TP
 \fB\-\-hashsize\fP \fIhashsize\fP
@@ -440,7 +440,7 @@ If a set was created with a nonzero valued
 \fB\-\-timeout\fP
 parameter then one may add IP addresses to the set with a specific 
 timeout value using the syntax 
-"\fIip\fP\fB,\fP\fItimeout-value\fP".
+"\fIaddress\fP\fB,\fP\fItimeout-value\fP".
 Similarly to the hash types, the iptree type of sets can store up to 65536
 entries.
 .SS iptreemap
@@ -448,7 +448,7 @@ The iptreemap set type uses a tree to store IP addresses or networks,
 where the last octet of an IP address are stored in a bitmap.
 As input entry, you can add IP addresses, CIDR blocks or network ranges
 to the set. Network ranges can be specified in the format
-"\fIip1\fP\fB-\fP\fIip2\fP".
+"\fIaddress1\fP\fB-\fP\fIaddress2\fP".
 .P
 Options to use when creating an iptreemap set:
 .TP
-- 
1.6.5.2

