From: Jan Engelhardt <jengelh@medozas.de>
Subject: [patch] Update tproxy documentation
Date: Tue, 7 Oct 2008 09:25:47 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810070921190.438@fbirervta.pbzchgretzou.qr>
References: <20081001142431.4893.48078.stgit@este> <20081001142431.4893.5367.stgit@este> <alpine.LNX.1.10.0810030949300.3893@fbirervta.pbzchgretzou.qr> <1223362870.8909.11.camel@nessa.odu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	KOVACS Krisztian <hidden@sch.bme.hu>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44288 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYJGNZt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:25:49 -0400
In-Reply-To: <1223362870.8909.11.camel@nessa.odu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-10-07 03:01, KOVACS Krisztian wrote:
>
>I'm not opposed to the changes, though, so could you please send a patch
>on top of Dave's current net-next tree? Thanks.
>

This one goes on top of Patrick's net-next, because it does not exist in 
Dave's yet :)

commit b18b26b12062a7d1e866e0215e734561c7279259
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Tue Oct 7 09:20:39 2008 -0400

netfilter: update tproxy documentation

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Documentation/networking/tproxy.txt |   24 ++++++++++++++----------
 1 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/Documentation/networking/tproxy.txt b/Documentation/networking/tproxy.txt
index 7b5996d..db7e808 100644
--- a/Documentation/networking/tproxy.txt
+++ b/Documentation/networking/tproxy.txt
@@ -27,15 +27,17 @@ modify your application to allow it to send datagrams _from_ non-local IP
 addresses. All you have to do is enable the (SOL_IP, IP_TRANSPARENT) socket
 option before calling bind:
 
-fd = socket(AF_INET, SOCK_STREAM, 0);
-/* - 8< -*/
-int value = 1;
-setsockopt(fd, SOL_IP, IP_TRANSPARENT, &value, sizeof(value));
-/* - 8< -*/
-name.sin_family = AF_INET;
-name.sin_port = htons(0xCAFE);
-name.sin_addr.s_addr = htonl(0xDEADBEEF);
-bind(fd, &name, sizeof(name));
+	struct sockaddr_in name;
+	int fd;
+	fd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+	/* - 8< -*/
+	static const unsigned int value = 1;
+	setsockopt(fd, SOL_IP, IP_TRANSPARENT, &value, sizeof(value));
+	/* - 8< -*/
+	name.sin_family = AF_INET;
+	name.sin_port = htons(0xCAFE);
+	inet_pton(PF_INET, "192.0.2.37", &name.sin_addr);
+	bind(fd, (const void *)&name, sizeof(name));
 
 A trivial patch for netcat is available here:
 http://people.netfilter.org/hidden/tproxy/netcat-ip_transparent-support.patch
@@ -50,7 +52,9 @@ limitations of that method. One of the major issues is that it actually
 modifies the packets to change the destination address -- which might not be
 acceptable in certain situations. (Think of proxying UDP for example: you won't
 be able to find out the original destination address. Even in case of TCP
-getting the original destination address is racy.)
+getting the original destination address is racy. Obtaining the address via
+getsockopt(fd, SOL_IP, SO_ORIGINAL_DST, ...) also requires connection tracking,
+which may not be loaded or desired.)
 
 The 'TPROXY' target provides similar functionality without relying on NAT. Simply
 add rules like this to the iptables ruleset above:
