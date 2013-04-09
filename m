From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: documentation bug: missing nat targets in man
Date: Tue, 09 Apr 2013 13:40:24 +0200
Message-ID: <5163FE28.3020604@chello.at>
References: <5163E3BE.3040609@chello.at> <20130409095448.GD26170@macbook.localnet>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070507010104040607080604"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep19.mx.upcmail.net ([62.179.121.39]:60611 "EHLO
	fep19.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934576Ab3DILlL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:41:11 -0400
In-Reply-To: <20130409095448.GD26170@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070507010104040607080604
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09.04.2013 11:54, Patrick McHardy wrote:
> On Tue, Apr 09, 2013 at 11:47:42AM +0200, Mart Frauenlob wrote:
>> Hello,
>>
>> I noticed there's quite new DNAT, SNAT, NETMAP support for
>> ip6tables, but that information is missing in the man page.
>> Anything else needed than just copying the according ipv4 *.man files?
>> If so, want me do prepare a patch?
>
> I guess you can rename the ipv4 specific man files to xt_... and
> update them accordingly, the modules should behave similar to their
> IPv4 counterparts.
>

Ok, here it is.
I slightly modified the text in regards to sentence structure.
Removed the references to older kernels, as this does not apply to the 
new ipv6 version.
Added the list of valid protocols, which again - for me leaves the 
question about -p icmp open (re other mail).

Best regards

Mart

--------------070507010104040607080604
Content-Type: text/plain; charset=windows-1252;
 name="ip6tables-manpage-Add-DNAT-SNAT-and-NETMAP-targets.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="ip6tables-manpage-Add-DNAT-SNAT-and-NETMAP-targets.patch"

>From 003b833cb1a47c0e189ba3b275af4ab9dad4f25e Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Tue, 9 Apr 2013 13:34:31 +0200
Subject: [PATCH] ip6tables manpage: Add DNAT, SNAT and NETMAP targets.

---
 extensions/libip6t_DNAT.man   |   30 ++++++++++++++++++++++++++++++
 extensions/libip6t_NETMAP.man |    9 +++++++++
 extensions/libip6t_SNAT.man   |   28 ++++++++++++++++++++++++++++
 3 files changed, 67 insertions(+), 0 deletions(-)
 create mode 100644 extensions/libip6t_DNAT.man
 create mode 100644 extensions/libip6t_NETMAP.man
 create mode 100644 extensions/libip6t_SNAT.man

diff --git a/extensions/libip6t_DNAT.man b/extensions/libip6t_DNAT.man
new file mode 100644
index 0000000..9ab07e2
--- /dev/null
+++ b/extensions/libip6t_DNAT.man
@@ -0,0 +1,30 @@
+This target is only valid in the
+.B nat
+table, in the
+.B PREROUTING
+and
+.B OUTPUT
+chains, and user-defined chains which are only called from those
+chains.  It specifies that the destination address of the packet
+should be modified (and all future packets in this connection will
+also be mangled), and rules should cease being examined.  It takes the
+following options:
+.TP
+\fB\-\-to\-destination\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
+which can specify a single new destination IP address, an inclusive
+range of IP addresses. Optionally a port range,
+if the rule also specifies one of the following protocols:
+.B tcp, udp, dccp, sctp
+or
+.B icmp\fP.
+If no port range is specified, then the destination port will never be
+modified. If no IP address is specified then only the destination port
+will be modified.
+.TP
+\fB\-\-random\fP
+If option
+\fB\-\-random\fP
+is used then port mapping will be randomized.
+.TP
+\fB\-\-persistent\fP
+Gives a client the same source-/destination-address for each connection.
diff --git a/extensions/libip6t_NETMAP.man b/extensions/libip6t_NETMAP.man
new file mode 100644
index 0000000..a7e90b8
--- /dev/null
+++ b/extensions/libip6t_NETMAP.man
@@ -0,0 +1,9 @@
+This target allows you to statically map a whole network of addresses onto
+another network of addresses.  It can only be used from rules in the
+.B nat
+table.
+.TP
+\fB\-\-to\fP \fIaddress\fP[\fB/\fP\fImask\fP]
+Network address to map to.  The resulting address will be constructed in the
+following way: All 'one' bits in the mask are filled in from the new `address'.
+All bits that are zero in the mask are filled in from the original address.
diff --git a/extensions/libip6t_SNAT.man b/extensions/libip6t_SNAT.man
new file mode 100644
index 0000000..d5d4989
--- /dev/null
+++ b/extensions/libip6t_SNAT.man
@@ -0,0 +1,28 @@
+This target is only valid in the
+.B nat
+table, in the
+.B POSTROUTING
+chain.  It specifies that the source address of the packet should be
+modified (and all future packets in this connection will also be
+mangled), and rules should cease being examined.  It takes the
+following options:
+.TP
+\fB\-\-to\-source\fP [\fIipaddr\fP[\fB\-\fP\fIipaddr\fP]][\fB:\fP\fIport\fP[\fB\-\fP\fIport\fP]]
+which can specify a single new source IP address, an inclusive range
+of IP addresses. Optionally a port range,
+if the rule also specifies one of the following protocols:
+.B tcp, udp, dccp, sctp
+or
+.B icmp\fP.
+If no port range is specified, then source ports below 512 will be
+mapped to other ports below 512: those between 512 and 1023 inclusive
+will be mapped to ports below 1024, and other ports will be mapped to
+1024 or above. Where possible, no port alteration will occur.
+.TP
+\fB\-\-random\fP
+If option
+\fB\-\-random\fP
+is used then port mapping will be randomized.
+.TP
+\fB\-\-persistent\fP
+Gives a client the same source-/destination-address for each connection.
-- 
1.7.2.5


--------------070507010104040607080604--
