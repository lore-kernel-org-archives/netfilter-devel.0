From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Subject: [PATCH netfilter] extensions/libxt_bpf.man: clarify BPF code generation with tcpdump
Date: Wed, 10 Aug 2016 15:23:07 -0400
Message-ID: <1470856987-101558-1-git-send-email-willemdebruijn.kernel@gmail.com>
Cc: pablo@netfilter.org, blaffablaffa@gmail.com,
	Willem de Bruijn <willemb@google.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:32918 "EHLO
	mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S941318AbcHJTXT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 15:23:19 -0400
Received: by mail-qk0-f193.google.com with SMTP id x189so4177411qkd.0
        for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 12:23:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Willem de Bruijn <willemb@google.com>

The xt_bpf module applies BPF bytecode to the packet. Depending on
where the module is invoked, the kernel may pass a packet with or
without link layer header. Iptables has no such header.

A common `tcpdump -ddd <string>` compilation command may revert to
a physical device that generates code for packets starting from the
mac layer up (e.g., E10MB data link type: Ethernet).

Clarify in the man page that when using this tool for code generation,
a suitable target device must be chosen.

Netfilter Bugzilla Bug #1048

Reported-by: Lorenzo Pistone <blaffablaffa@gmail.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
---
 extensions/libxt_bpf.man | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/extensions/libxt_bpf.man b/extensions/libxt_bpf.man
index 5b1d042..302e010 100644
--- a/extensions/libxt_bpf.man
+++ b/extensions/libxt_bpf.man
@@ -31,4 +31,17 @@ Or instead, you can invoke the nfbpf_compile utility.
 .IP
 iptables \-A OUTPUT \-m bpf \-\-bytecode "`nfbpf_compile RAW 'ip proto 6'`" \-j ACCEPT
 .PP
+Or use tcpdump -ddd. In that case, generate BPF targeting a device with the
+same data link type as the xtables match. Iptables passes packets from the
+network layer up, without mac layer. Select a device with data link type RAW,
+such as a tun device:
+.IP
+ip tuntap add tun0 mode tun
+.br
+ip link set tun0 up
+.br
+tcpdump -ddd -i tun0 ip proto 6
+.PP
+See tcpdump -L -i $dev for a list of known data link types for a given device.
+.PP
 You may want to learn more about BPF from FreeBSD's bpf(4) manpage.
-- 
2.8.0.rc3.226.g39d4020

