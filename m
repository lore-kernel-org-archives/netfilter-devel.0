From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Bug: "You must specify `--icmpv6-type'"
Date: Tue, 13 Feb 2007 12:01:04 +0900 (JST)
Message-ID: <200702130301.l1D3159w015381@toshiba.co.jp>
References: <20070209102829.GA31011@roonstrasse.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: max@duempel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070209102829.GA31011@roonstrasse.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi,

From: Max Kellermann <max@duempel.org>
Date: Fri, 9 Feb 2007 11:28:29 +0100

> Hi,
> 
> users of my "ferm" iptables frontend
> (http://max.kellermann.name/projects/ferm/) reported a problem with
> ip6tables.
> 
>  rabbit:~# ip6tables -A INPUT -p icmpv6 -j ACCEPT
>  rabbit:~# ip6tables -A INPUT -p icmpv6 -m icmpv6 -j ACCEPT
>  ip6tables v1.3.6: icmpv6 match: You must specify `--icmpv6-type'
>  Try `ip6tables -h' or 'ip6tables --help' for more information.
> 
> According to the ip6tables manpage, the "icmpv6" module is implicitly
> loaded whenever you specify "-p icmpv6".  It is however only loaded
> when you also specify "--icmpv6-type".  So either the documentation is
> wrong, or ip6tables' behaviour is.

This behavior is intended. The matches for protocol are not loaded when you
specify only '-p protocol', but loaded when you specify extra options of
them, too. This is to avoid unnecessary loading.

Following explanations are preferable ?

diff --git a/extensions/libip6t_icmp6.man b/extensions/libip6t_icmp6.man
index 2047180..c755fbf 100644
--- a/extensions/libip6t_icmp6.man
+++ b/extensions/libip6t_icmp6.man
@@ -1,4 +1,4 @@
-This extension is loaded if `--protocol ipv6-icmp' or `--protocol icmpv6' is
+This extension can be used if `--protocol ipv6-icmp' or `--protocol icmpv6' is
 specified. It provides the following option:
 .TP
 .BR "--icmpv6-type " "[!] \fItype\fP[/\fIcode\fP]|\fItypename\fP"
diff --git a/extensions/libip6t_tcp.man b/extensions/libip6t_tcp.man
index 75d172e..e94566c 100644
--- a/extensions/libip6t_tcp.man
+++ b/extensions/libip6t_tcp.man
@@ -1,4 +1,4 @@
-These extensions are loaded if `--protocol tcp' is specified. It
+These extensions can be used if `--protocol tcp' is specified. It
 provides the following options:
 .TP
 .BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
diff --git a/extensions/libip6t_udp.man b/extensions/libip6t_udp.man
index 0408479..1d5e590 100644
--- a/extensions/libip6t_udp.man
+++ b/extensions/libip6t_udp.man
@@ -1,4 +1,4 @@
-These extensions are loaded if `--protocol udp' is specified.  It
+These extensions can be used if `--protocol udp' is specified.  It
 provides the following options:
 .TP
 .BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
diff --git a/extensions/libipt_icmp.man b/extensions/libipt_icmp.man
index 5b91514..55d24b4 100644
--- a/extensions/libipt_icmp.man
+++ b/extensions/libipt_icmp.man
@@ -1,4 +1,4 @@
-This extension is loaded if `--protocol icmp' is specified.  It
+This extension can be used if `--protocol icmp' is specified.  It
 provides the following option:
 .TP
 .BR "--icmp-type " "[!] \fItypename\fP"
diff --git a/extensions/libipt_tcp.man b/extensions/libipt_tcp.man
index 648c81e..cfafc9e 100644
--- a/extensions/libipt_tcp.man
+++ b/extensions/libipt_tcp.man
@@ -1,4 +1,4 @@
-These extensions are loaded if `--protocol tcp' is specified. It
+These extensions can be used if `--protocol tcp' is specified. It
 provides the following options:
 .TP
 .BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
diff --git a/extensions/libipt_udp.man b/extensions/libipt_udp.man
index 0408479..1d5e590 100644
--- a/extensions/libipt_udp.man
+++ b/extensions/libipt_udp.man
@@ -1,4 +1,4 @@
-These extensions are loaded if `--protocol udp' is specified.  It
+These extensions can be used if `--protocol udp' is specified.  It
 provides the following options:
 .TP
 .BR "--source-port " "[!] \fIport\fP[:\fIport\fP]"
-- 
1.4.4
