From: Patrick McHardy <kaber@trash.net>
Subject: netfilter 49/79: Add documentation for tproxy
Date: Wed,  8 Oct 2008 12:47:27 +0200 (MEST)
Message-ID: <20081008104727.10423.82588.sendpatchset@x2.localnet>
References: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46008 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbYJHKr2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Oct 2008 06:47:28 -0400
In-Reply-To: <20081008104621.10423.12648.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit d2f26037a38ada4a5d40d1cf0b32bc5289f50312
Author: KOVACS Krisztian <hidden@sch.bme.hu>
Date:   Wed Oct 8 11:35:12 2008 +0200

    netfilter: Add documentation for tproxy
    
    Add basic usage instructions to Documentation/networking.
    
    Signed-off-by: KOVACS Krisztian <hidden@sch.bme.hu>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/Documentation/networking/tproxy.txt b/Documentation/networking/tproxy.txt
new file mode 100644
index 0000000..7b5996d
--- /dev/null
+++ b/Documentation/networking/tproxy.txt
@@ -0,0 +1,85 @@
+Transparent proxy support
+=========================
+
+This feature adds Linux 2.2-like transparent proxy support to current kernels.
+To use it, enable NETFILTER_TPROXY, the socket match and the TPROXY target in
+your kernel config. You will need policy routing too, so be sure to enable that
+as well.
+
+
+1. Making non-local sockets work
+================================
+
+The idea is that you identify packets with destination address matching a local
+socket on your box, set the packet mark to a certain value, and then match on that
+value using policy routing to have those packets delivered locally:
+
+# iptables -t mangle -N DIVERT
+# iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
+# iptables -t mangle -A DIVERT -j MARK --set-mark 1
+# iptables -t mangle -A DIVERT -j ACCEPT
+
+# ip rule add fwmark 1 lookup 100
+# ip route add local 0.0.0.0/0 dev lo table 100
+
+Because of certain restrictions in the IPv4 routing output code you'll have to
+modify your application to allow it to send datagrams _from_ non-local IP
+addresses. All you have to do is enable the (SOL_IP, IP_TRANSPARENT) socket
+option before calling bind:
+
+fd = socket(AF_INET, SOCK_STREAM, 0);
+/* - 8< -*/
+int value = 1;
+setsockopt(fd, SOL_IP, IP_TRANSPARENT, &value, sizeof(value));
+/* - 8< -*/
+name.sin_family = AF_INET;
+name.sin_port = htons(0xCAFE);
+name.sin_addr.s_addr = htonl(0xDEADBEEF);
+bind(fd, &name, sizeof(name));
+
+A trivial patch for netcat is available here:
+http://people.netfilter.org/hidden/tproxy/netcat-ip_transparent-support.patch
+
+
+2. Redirecting traffic
+======================
+
+Transparent proxying often involves "intercepting" traffic on a router. This is
+usually done with the iptables REDIRECT target; however, there are serious
+limitations of that method. One of the major issues is that it actually
+modifies the packets to change the destination address -- which might not be
+acceptable in certain situations. (Think of proxying UDP for example: you won't
+be able to find out the original destination address. Even in case of TCP
+getting the original destination address is racy.)
+
+The 'TPROXY' target provides similar functionality without relying on NAT. Simply
+add rules like this to the iptables ruleset above:
+
+# iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
+  --tproxy-mark 0x1/0x1 --on-port 50080
+
+Note that for this to work you'll have to modify the proxy to enable (SOL_IP,
+IP_TRANSPARENT) for the listening socket.
+
+
+3. Iptables extensions
+======================
+
+To use tproxy you'll need to have the 'socket' and 'TPROXY' modules
+compiled for iptables. A patched version of iptables is available
+here: http://git.balabit.hu/?p=bazsi/iptables-tproxy.git
+
+
+4. Application support
+======================
+
+4.1. Squid
+----------
+
+Squid 3.HEAD has support built-in. To use it, pass
+'--enable-linux-netfilter' to configure and set the 'tproxy' option on
+the HTTP listener you redirect traffic to with the TPROXY iptables
+target.
+
+For more information please consult the following page on the Squid
+wiki: http://wiki.squid-cache.org/Features/Tproxy4
