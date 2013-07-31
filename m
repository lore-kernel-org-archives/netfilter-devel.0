From: Henry Lee <henryronlee@gmail.com>
Subject: PROBLEM: Netfilter time matching matches all packets when time start
 and time stop is the same
Date: Wed, 31 Jul 2013 16:42:15 +0800
Message-ID: <CAK+MRYuFUCvkker9sq7LFa42t=vQ7FhWwzz37Mtw3sLMZTJ+EQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=047d7b5da13bdaa4ee04e2cab3ad
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
To: pablo@netfilter.org, kaber@trash.net, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f43.google.com ([209.85.160.43]:51048 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755731Ab3GaImQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:42:16 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--047d7b5da13bdaa4ee04e2cab3ad
Content-Type: text/plain; charset=ISO-8859-1

Dear sirs:

I've found a bug when running the netfilter time matching module. Here
is the description.

[1.] One line summary of the problem:
Netfilter time matching matches all packets when time start and time
stop is the same

[2.] Full description of the problem/report:
When I used "-m time --timestart 01:00 --timestop 01:00", the netfitler
matches all day packets, which in my point of view, looks unnatural.

[3.] Keywords (i.e., modules, networking, kernel):
modules, networking, netfilter

[4.] Kernel information

[4.1.] Kernel version (from /proc/version):
Linux version 3.8.0-27-generic (buildd@roseapple) (gcc version 4.7.3
(Ubuntu/Linaro 4.7.3-1ubuntu1) ) #40-Ubuntu SMP Tue Jul 9 00:17:05 UTC 2013

I tested this on 3.8.0, in which the xt_time.c should be the newest.

[4.2.] Kernel .config file:
Irrelevant.

[5.] Most recent kernel version which did not have the bug:
None.

[6.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/oops-tracing.txt)
Irrelevant.

[7.] A small shell script or example program which triggers the
      problem (if possible)
iptables -I INPUT -m time --timestart 01:00 --timestop 01:00 -j DROP

[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
Irrelevant.

[8.2.] Processor information (from /proc/cpuinfo):
Irrelevant.

[8.3.] Module information (from /proc/modules):
Module                  Size  Used by
xt_time                12661  0
xt_tcpudp              12603  1
iptable_filter         12810  1
xt_multiport           12597  1
ipt_MASQUERADE         12759  1
iptable_nat            12810  1
nf_conntrack_ipv4      14487  1
nf_defrag_ipv4         12729  1 nf_conntrack_ipv4
nf_nat_ipv4            13263  1 iptable_nat
nf_nat                 25867  3 ipt_MASQUERADE,nf_nat_ipv4,iptable_nat
nf_conntrack           83275  5
ipt_MASQUERADE,nf_nat,nf_nat_ipv4,iptable_nat,nf_conntrack_ipv4
ip_tables              26995  2 iptable_filter,iptable_nat
8021q                  24000  0
garp                   14354  1 8021q
stp                    12976  1 garp
llc                    14552  2 stp,garp
ipt_ULOG               17410  1
x_tables               29803  7
xt_time,ipt_ULOG,ip_tables,xt_tcpudp,ipt_MASQUERADE,xt_multiport,iptable_filter
...
The rest are irrelevant.

[8.4.] Loaded driver and hardware information (/proc/ioports, /proc/iomem)
Irrelevant.

[8.5.] PCI information ('lspci -vvv' as root)
Irrelevant.

[8.6.] SCSI information (from /proc/scsi/scsi)
Irrelevant.

[8.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):
None.

[X.] Other notes, patches, fixes, workarounds:
I'll place the patch in the attachment as well.

==========
diff --git a/net/netfilter/xt_time.c b/net/netfilter/xt_time.c
index 0ae55a3..753573c 100644
--- a/net/netfilter/xt_time.c
+++ b/net/netfilter/xt_time.c
@@ -192,7 +192,7 @@ time_mt(const struct sk_buff *skb, struct
xt_action_param *par)

     packet_time = localtime_1(&current_time, stamp);

-   if (info->daytime_start < info->daytime_stop) {
+   if (info->daytime_start <= info->daytime_stop) {
         if (packet_time < info->daytime_start ||
             packet_time > info->daytime_stop)
             return false;

==========

Yours faithfully,
Henry Lee

--047d7b5da13bdaa4ee04e2cab3ad
Content-Type: text/x-patch; charset=US-ASCII; name="patch_netfilter_xt_time.diff"
Content-Disposition: attachment; filename="patch_netfilter_xt_time.diff"
Content-Transfer-Encoding: base64
X-Attachment-Id: a1bd02169a81ea39_0.1

ZGlmZiAtLWdpdCBhL25ldC9uZXRmaWx0ZXIveHRfdGltZS5jIGIvbmV0L25ldGZpbHRlci94dF90
aW1lLmMNCmluZGV4IDBhZTU1YTMuLjc1MzU3M2MgMTAwNjQ0DQotLS0gYS9uZXQvbmV0ZmlsdGVy
L3h0X3RpbWUuYw0KKysrIGIvbmV0L25ldGZpbHRlci94dF90aW1lLmMNCkBAIC0xOTIsNyArMTky
LDcgQEAgdGltZV9tdChjb25zdCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1Y3QgeHRfYWN0aW9u
X3BhcmFtICpwYXIpDQogDQogCXBhY2tldF90aW1lID0gbG9jYWx0aW1lXzEoJmN1cnJlbnRfdGlt
ZSwgc3RhbXApOw0KIA0KLQlpZiAoaW5mby0+ZGF5dGltZV9zdGFydCA8IGluZm8tPmRheXRpbWVf
c3RvcCkgew0KKwlpZiAoaW5mby0+ZGF5dGltZV9zdGFydCA8PSBpbmZvLT5kYXl0aW1lX3N0b3Ap
IHsNCiAJCWlmIChwYWNrZXRfdGltZSA8IGluZm8tPmRheXRpbWVfc3RhcnQgfHwNCiAJCSAgICBw
YWNrZXRfdGltZSA+IGluZm8tPmRheXRpbWVfc3RvcCkNCiAJCQlyZXR1cm4gZmFsc2U7DQo=
--047d7b5da13bdaa4ee04e2cab3ad--
