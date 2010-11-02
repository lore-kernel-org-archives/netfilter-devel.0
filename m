From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: [ipset-5: 9/9] Manpage and help text fixes.
Date: Tue,  2 Nov 2010 15:35:34 +0100
Message-ID: <1288708534-14510-10-git-send-email-kadlec@blackhole.kfki.hu>
References: <1288708534-14510-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-2-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-3-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-4-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-5-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-6-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-7-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-8-git-send-email-kadlec@blackhole.kfki.hu>
 <1288708534-14510-9-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.7.0.4"
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:33597 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981Ab0KBOfi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:35:38 -0400
Received: from localhost (localhost [127.0.0.1])
	by smtp2.kfki.hu (Postfix) with ESMTP id 66CC11F4138
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from smtp2.kfki.hu ([127.0.0.1])
	by localhost (smtp2.kfki.hu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IsYi1lFrgFGV for <netfilter-devel@vger.kernel.org>;
	Tue,  2 Nov 2010 15:35:35 +0100 (CET)
Received: from blackhole.kfki.hu (blackhole.kfki.hu [148.6.0.114])
	by smtp2.kfki.hu (Postfix) with ESMTP id 3FBBB1F4146
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Nov 2010 15:35:35 +0100 (CET)
In-Reply-To: <1288708534-14510-9-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------1.7.0.4
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


The manpage is updated to reflect the recent modifications and
the addition of the hash:net,port type. The help text of hash:ip
is updated: adding/deleting multiple entries are supported for
IPv4 only.

Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 src/ipset.8         |  145 ++++++++++++++++++++++++++++++++++++++-------------
 src/ipset_hash_ip.c |    3 +-
 2 files changed, 110 insertions(+), 38 deletions(-)


--------------1.7.0.4
Content-Type: text/x-patch; name="0009-Manpage-and-help-text-fixes.patch"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="0009-Manpage-and-help-text-fixes.patch"

diff --git a/src/ipset.8 b/src/ipset.8
index 2169c36..91c58ce 100644
--- a/src/ipset.8
+++ b/src/ipset.8
@@ -213,8 +213,14 @@ ipset add foo ipaddr,portnum,ipaddr
 The \fBbitmap\fR and \fBlist\fR types use a fixed sized storage. The \fBhash\fR
 types use a hash to store the elements. In order to avoid clashes in the hash,
 a limited number of chaining, and if that is exhausted, the doubling of the hash size
-is performed. The hash size is indirectly limited by the maximal number of elements
-parameter of the hash. 
+is performed when adding entries by
+\fBipset\fR.
+When entries added by the
+\fBSET\fR
+target of
+\fBiptables/ip6tables\fR,
+then the hash size is fixed and the set won't be duplicated, even if the new
+entry cannot be added to the set.
 
 All set types support the optional
 
@@ -302,7 +308,7 @@ Examples:
 .IP 
 ipset create foo bitmap:ip,mac range 192.168.0.0/16
 .IP 
-ipset add foo 192.168.1,12:34:56:78:9A:BC
+ipset add foo 192.168.1.1,12:34:56:78:9A:BC
 .IP 
 ipset test foo 192.168.1.1
 .SS bitmap:port
@@ -433,7 +439,7 @@ ipset test foo 192.168.0/24
 .SS hash:ip,port
 The \fBhash:ip,port\fR set type uses a hash to store IP address and port number pairs.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBproto\fR \fIvalue\fR ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ]
 .PP 
 \fIADD\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR
 .PP 
@@ -449,29 +455,46 @@ Optional \fBcreate\fR options:
 The protocol family of the IP addresses to be stored in the set. The default is
 \fBinet\fR, i.e IPv4.
 .TP 
-\fBproto\fR \fIvalue\fR
-The default protocol for the port to be stored in the set. If no protocol is specified,
-then TCP/UDP ports are assumed as backward compatibility, in which case a port in
-the set matches with both TCP and UDP. The default protocol also defines which kind
-of ports are to be added to the set when the \fBSET\fR target is used.
-.TP 
 \fBhashsize\fR \fIvalue\fR
 The initial hash size for the set, default is 1024. The hash size must be a power
 of two, the kernel automatically rounds up non power of two hash sizes to the first
-correct value.
+correct value
 .TP 
 \fBmaxelem\fR \fIvalue\fR
 The maximal number of elements which can be stored in the set, default 65536.
 .PP 
-When adding, deleting, testing entries the port value is interpreted
-for TCP and UDP only, for other protocols the port value currently is ignored and
-zeroed out, but must be specified. The \fBhash:ip,port\fR type of sets require
+The
+[\fIproto\fR:]\fIport\fR
+part of the elements may be expressed in the following forms:
+.TP 
+\fIportname\fR
+TCP port name identifier from /etc/services
+.TP 
+\fIportnumber\fR
+TCP port number
+.TP 
+\fBtcp\fR|\fBudp\fR:\fIportname\fR|\fIportnumber\fR
+TCP or UDP port name or port number
+.TP 
+\fBicmp\fR:\fIcodename\fR|\fItype\fR/\fIcode\fR
+ICMP codename or type/code. The supported ICMP codename identifiers can always
+be listed by the help command.
+.TP 
+\fBicmpv6\fR:\fIcodename\fR|\fItype\fR/\fIcode\fR
+ICMPv6 codename or type/code. The supported ICMPv6 codename identifiers can always
+be listed by the help command.
+.TP 
+\fIproto\fR:0
+All other protocols, as an identifier from /etc/protocols or number. The pseudo
+port number must be zero.
+.PP 
+The \fBhash:ip,port\fR type of sets require
 two \fBsrc\fR/\fBdst\fR parameters of the \fBset\fR match and \fBSET\fR
 target kernel modules.
 .PP 
 Examples:
 .IP 
-ipset create foo hash:ip,port proto tcp
+ipset create foo hash:ip,port
 .IP 
 ipset add foo 192.168.1.1,80
 .IP 
@@ -480,11 +503,68 @@ ipset add foo 192.168.1.1,udp:53
 ipset add foo 192.168.1.1,ospf:0
 .IP 
 ipset test foo 192.168.1.1,80
+.SS hash:net,port
+The \fBhash:net,port\fR set type uses a hash to store different sized IP network
+address and port pairs.
+.PP 
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ]
+.PP 
+\fIADD\-ENTRY\fR := \fIipaddr\fR[/\fIcidr\fR],[\fIproto\fR:]\fIport\fR
+.PP 
+\fIADD\-OPTIONS\fR := [ \fBtimeout\fR \fIvalue\fR ]
+.PP 
+\fIDEL\-ENTRY\fR := \fIipaddr\fR[/\fIcidr\fR],[\fIproto\fR:]\fIport\fR
+.PP 
+\fITEST\-ENTRY\fR := \fIipaddr\fR[/\fIcidr\fR],[\fIproto\fR:]\fIport\fR
+.PP 
+Optional \fBcreate\fR options:
+.TP 
+\fBfamily\fR { \fBinet\fR | \fBinet6\fR }
+The protocol family of the IP addresses to be stored in the set. The default is
+\fBinet\fR, i.e IPv4.
+.TP 
+\fBhashsize\fR \fIvalue\fR
+The initial hash size for the set, default is 1024. The hash size must be a power
+of two, the kernel automatically rounds up non power of two hash sizes to the first
+correct value.
+.TP 
+\fBmaxelem\fR \fIvalue\fR
+The maximal number of elements which can be stored in the set, default 65536.
+.PP 
+For the
+[\fIproto\fR:]\fIport\fR
+part of the elements see the description at the
+\fBhash:ip,port\fR set type.
+.PP 
+When adding/deleting/testing entries, if the cidr prefix parameter is not specified,
+then the host prefix value is assumed. When adding/deleting entries, overlapping
+elements are not checked.
+.PP 
+From the \fBset\fR netfilter match point of view an IP address will be in a \fBhash:net,port\fR type of set if it belongs to any of the netblocks added to
+the set and the proto/port part also matches.
+The  matching  always  start  from  the smallest  size  of netblock (most specific
+prefix) to the largest ones (least specific prefix).  When  adding/deleting IP
+addresses  to the set by the \fBSET\fR netfilter target, it  will  be
+added/deleted by the most specific prefix which can be found in  the
+set, or by the host prefix value if the set is empty.
+.PP 
+The lookup time grows linearly with the number of the different prefix
+values added to the set. 
+.PP 
+Examples:
+.IP 
+ipset create foo hash:net,port
+.IP 
+ipset add foo 192.168.0/24,25
+.IP 
+ipset add foo 10.1.0.0/16,80
+.IP 
+ipset test foo 192.168.0/24,25
 .SS hash:ip,port,ip
 The \fBhash:ip,port,ip\fR set type uses a hash to store IP address, port number
 and a second IP address triples.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBproto\fR \fIvalue\fR ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ]
 .PP 
 \fIADD\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR,\fIipaddr\fR
 .PP 
@@ -500,12 +580,6 @@ Optional \fBcreate\fR options:
 The protocol family of the IP addresses to be stored in the set. The default is
 \fBinet\fR, i.e IPv4.
 .TP 
-\fBproto\fR \fIvalue\fR
-The default protocol for the port to be stored in the set. If no protocol is specified,
-then TCP/UDP ports are assumed as backward compatibility. The default protocol
-also defines which kind of ports are to be added to the set when the \fBSET\fR
-target is used.
-.TP 
 \fBhashsize\fR \fIvalue\fR
 The initial hash size for the set, default is 1024. The hash size must be a power
 of two, the kernel automatically rounds up non power of two hash sizes to the first
@@ -514,9 +588,12 @@ correct value.
 \fBmaxelem\fR \fIvalue\fR
 The maximal number of elements which can be stored in the set, default 65536.
 .PP 
-When adding, deleting, testing entries the port value is interpreted
-for TCP and UDP only, for other protocols the port value currently is ignored and
-zeroed out, but must be specified. The \fBhash:ip,port,ip\fR type of sets require
+For the
+[\fIproto\fR:]\fIport\fR
+part of the elements see the description at the
+\fBhash:ip,port\fR set type.
+.PP 
+The \fBhash:ip,port,ip\fR type of sets require
 three \fBsrc\fR/\fBdst\fR parameters of the \fBset\fR match and \fBSET\fR
 target kernel modules.
 .PP 
@@ -531,7 +608,7 @@ ipset test foo 192.168.1.1,udp:53,10.0.0.1
 The \fBhash:ip,port,net\fR set type uses a hash to store IP address, port number
 and IP network address triples.
 .PP 
-\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBproto\fR \fIvalue\fR ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ]
+\fICREATE\-OPTIONS\fR := [ \fBfamily\fR { \fBinet\fR | \fBinet6\fR } ] | [ \fBhashsize\fR \fIvalue\fR ] [ \fBmaxelem\fR \fIvalue\fR ] [ \fBtimeout\fR \fIvalue\fR ]
 .PP 
 \fIADD\-ENTRY\fR := \fIipaddr\fR,[\fIproto\fR:]\fIport\fR,\fIipaddr\fR[/\fIcidr\fR]
 .PP 
@@ -547,12 +624,6 @@ Optional \fBcreate\fR options:
 The protocol family of the IP addresses to be stored in the set. The default is
 \fBinet\fR, i.e IPv4.
 .TP 
-\fBproto\fR \fIvalue\fR
-The default protocol for the port to be stored in the set. If no protocol is specified,
-then TCP/UDP ports are assumed as backward compatibility. The default protocol
-also defines which kind of ports are to be added to the set when the \fBSET\fR
-target is used.
-.TP 
 \fBhashsize\fR \fIvalue\fR
 The initial hash size for the set, default is 1024. The hash size must be a power
 of two, the kernel automatically rounds up non power of two hash sizes to the first
@@ -561,12 +632,12 @@ correct value.
 \fBmaxelem\fR \fIvalue\fR
 The maximal number of elements which can be stored in the set, default 65536.
 .PP 
-When adding/deleting/testing entries, if the cidr parameter is not specified,
-then the host cidr value is assumed. The port value is interpreted
-for TCP and UDP only, for other protocols the port value currently is ignored and
-zeroed out, but must be specified. 
+For the
+[\fIproto\fR:]\fIport\fR
+part of the elements see the description at the
+\fBhash:ip,port\fR set type.
 .PP 
-From the \fBset\fR netfilter match point of view a triple will be in a \fBhash:ip,port,net\fR type of set (when the first IP and the port match)
+From the \fBset\fR netfilter match point of view a triple will be in a \fBhash:ip,port,net\fR type of set when the first IP and the proto/port match,
 if the second IP belongs to any of the netblocks added to the set.
 The  matching  always  start  from  the smallest  size  of netblock (most specific
 cidr) to the largest ones (least specific cidr).  When  adding/deleting triples
diff --git a/src/ipset_hash_ip.c b/src/ipset_hash_ip.c
index 1d9a175..dfef47f 100644
--- a/src/ipset_hash_ip.c
+++ b/src/ipset_hash_ip.c
@@ -75,7 +75,8 @@ static const char hash_ip_usage[] =
 "test   SETNAME IP\n\n"
 "where depending on the INET family\n"
 "      IP, FROM and TO are IPv4 or IPv6 addresses (or hostnames),\n"
-"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n";
+"      CIDR is a valid IPv4 or IPv6 CIDR prefix.\n"
+"      Adding/deleting multiple elements is supported for IPv4 only.\n";
 
 struct ipset_type ipset_hash_ip0 = {
 	.name = "hash:ip",

--------------1.7.0.4--


