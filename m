From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] libmnl 1.0.0 release
Date: Tue, 21 Dec 2010 21:19:40 +0100
Message-ID: <4D110BDC.4000709@netfilter.org>
References: <4D0B71C3.7030806@netfilter.org> <1292649824.2371.14.camel@kushiel.sterenborg.info> <4D0CABC3.3090601@netfilter.org> <alpine.LNX.2.01.1012181633390.13544@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000409020108010606030209"
Cc: "Rob Sterenborg (lists)" <lists@sterenborg.info>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34114 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753128Ab0LUUTp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Dec 2010 15:19:45 -0500
In-Reply-To: <alpine.LNX.2.01.1012181633390.13544@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000409020108010606030209
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 18/12/10 16:35, Jan Engelhardt wrote:
> 
> On Saturday 2010-12-18 13:40, Pablo Neira Ayuso wrote:
>> On 18/12/10 06:23, Rob Sterenborg (lists) wrote:
>>> On Fri, 2010-12-17 at 15:20 +0100, Pablo Neira Ayuso wrote:
>>>> Hi!
>>>>
>>>> The Netfilter project presents libmnl-1.0.0
>>>
>>> Hi,
>>>
>>> I have a CentOS 5.5 base with a 2.6.36.2 kernel installed. When
>>> compiling libmnl I got these errors:
>>>
>>> nlmsg.c: In function 'mnl_nlmsg_fprintf_payload':
>>> nlmsg.c:274: error: 'NLA_TYPE_MASK' undeclared (first use in this
>>> function)
>>> nlmsg.c:274: error: (Each undeclared identifier is reported only once
>>> nlmsg.c:274: error: for each function it appears in.)
>>> nlmsg.c:290: error: 'NLA_F_NESTED' undeclared (first use in this
>>> function)
>>> nlmsg.c:292: error: 'NLA_F_NET_BYTEORDER' undeclared (first use in this
>>> function)
>>> make: *** [nlmsg.lo] Error 1
>>>
>>> NLA_TYPE_MASK is used in nlmsg.c and attr.c. Searching I found that it
>>> should be defined in linux/netlink.h but it's not there.
>>
>> I'd appreciate if you can guess what version of the kernel header files
>> you're using (CentOS uses a mutant Linux kernel 2.6.18, right?).
> 
> NLA_F_NESTED et al are available starting with 2.6.24.

I think that this approach (see patch) is safe to fix this problem.

Rob, would you give it a test?

--------------000409020108010606030209
Content-Type: text/x-patch;
 name="2.6.18.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2.6.18.patch"

nlmsg: fix compilation with Linux kernel headers <= 2.6.24

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch adds the internal definition of NLA_F_NESTED,
NLA_F_NET_BYTEORDER and NLA_TYPE_MASK which were introduced
in 2.6.24.

This patch is rather conservative since we internally define
these constants instead of making them public in libmnl.h.
I don't like the idea of polluting the libmnl.h file with
declarations that may be missing in old linux/netlink.h
files.

Moreover, I don't want to keep copies of useful Netlink
headers in libmnl to avoid the overhead of keeping them
in sync with those in the Linux kernel, not until I'm
convinced at least.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/nlmsg.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/src/nlmsg.c b/src/nlmsg.c
index b2e3853..c22e71e 100644
--- a/src/nlmsg.c
+++ b/src/nlmsg.c
@@ -243,6 +243,18 @@ static void mnl_nlmsg_fprintf_header(FILE *fd, const struct nlmsghdr *nlh)
 	fprintf(fd, "----------------\t------------------\n");
 }
 
+#ifndef NLA_F_NESTED
+#define NLA_F_NESTED		(1 << 15)
+#endif
+
+#ifndef NLA_F_NET_BYTEORDER
+#define NLA_F_NET_BYTEORDER	(1 << 14)
+#endif
+
+#ifndef NLA_TYPE_MASK
+#define NLA_TYPE_MASK		~(NLA_F_NESTED | NLA_F_NET_BYTEORDER)
+#endif
+
 static void
 mnl_nlmsg_fprintf_payload(FILE *fd, const struct nlmsghdr *nlh,
 			  size_t extra_header_size)

--------------000409020108010606030209--
