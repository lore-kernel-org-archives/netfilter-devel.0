From: "Rob Sterenborg (lists)" <lists@sterenborg.info>
Subject: Re: [ANNOUNCE] libmnl 1.0.0 release
Date: Sat, 18 Dec 2010 06:23:44 +0100
Message-ID: <1292649824.2371.14.camel@kushiel.sterenborg.info>
References: <4D0B71C3.7030806@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from firehole.xs4all.nl ([82.95.248.56]:50896 "EHLO
	smtp.sterenborg.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab0LRFdH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 00:33:07 -0500
In-Reply-To: <4D0B71C3.7030806@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2010-12-17 at 15:20 +0100, Pablo Neira Ayuso wrote:
> Hi!
> 
> The Netfilter project presents libmnl-1.0.0

Hi,

I have a CentOS 5.5 base with a 2.6.36.2 kernel installed. When
compiling libmnl I got these errors:

nlmsg.c: In function 'mnl_nlmsg_fprintf_payload':
nlmsg.c:274: error: 'NLA_TYPE_MASK' undeclared (first use in this
function)
nlmsg.c:274: error: (Each undeclared identifier is reported only once
nlmsg.c:274: error: for each function it appears in.)
nlmsg.c:290: error: 'NLA_F_NESTED' undeclared (first use in this
function)
nlmsg.c:292: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in this
function)
make: *** [nlmsg.lo] Error 1

NLA_TYPE_MASK is used in nlmsg.c and attr.c. Searching I found that it
should be defined in linux/netlink.h but it's not there.

To make it compile, I did the following.

New file nla.h:

/*
* nla_type (16 bits)
* +---+---+-------------------------------+
* | N | O | Attribute Type                |
* +---+---+-------------------------------+
* N := Carries nested attributes
* O := Payload stored in network byte order
*
* Note: The N and O flag are mutually exclusive.
*/

#define NLA_F_NESTED            (1 << 15)
#define NLA_F_NET_BYTEORDER     (1 << 14)
#define NLA_TYPE_MASK           ~(NLA_F_NESTED | NLA_F_NET_BYTEORDER)

These changes in nlmsg.c and attr.c:

--- attr.c.orig 2010-12-18 07:16:51.000000000 +0100
+++ attr.c      2010-12-18 07:16:05.000000000 +0100
@@ -11,6 +11,9 @@
 #include <string.h>
 #include <values.h>    /* for INT_MAX */
 #include <errno.h>
+#ifndef NLA_TYPE_MASK
+#include "nla.h"
+#endif
 #include "internal.h"
 
 /**

--- nlmsg.c.orig        2010-12-18 07:16:56.000000000 +0100
+++ nlmsg.c     2010-12-18 07:16:10.000000000 +0100
@@ -13,6 +13,9 @@
 #include <errno.h>
 #include <string.h>
 #include <libmnl/libmnl.h>
+#ifndef NLA_TYPE_MASK
+#include "nla.h"
+#endif
 #include "internal.h"
 
 /**

After this change, I get no errors when compiling libmnl.
I am not a C programmer, so: is the above the correct way?


Thanks,
Rob


