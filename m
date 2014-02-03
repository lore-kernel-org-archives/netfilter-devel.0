From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Fwd: [PATCH]: libnetfilter_log: Uninitialized values in
 libnetfilter_log.c
Date: Mon, 3 Feb 2014 12:26:54 +0100
Message-ID: <20140203112654.GA12231@localhost>
References: <CA+J3vc+YmPjtr2sJqR39cQSLOO+xmVK=RLChSRgv_+LN2tuRsQ@mail.gmail.com>
 <CA+J3vcLKCH-4sYWNsDZXdd10cee7VjV74wfa44hnjXQ-TPtGWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="jI8keyz6grp/JLjh"
Cc: netfilter-devel@vger.kernel.org
To: Ivan Homoliak <xhomol11@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35842 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751785AbaBCL12 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 06:27:28 -0500
Content-Disposition: inline
In-Reply-To: <CA+J3vcLKCH-4sYWNsDZXdd10cee7VjV74wfa44hnjXQ-TPtGWw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--jI8keyz6grp/JLjh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Ivan,

On Mon, Feb 03, 2014 at 10:54:23AM +0100, Ivan Homoliak wrote:
> Uninitialized values in libnetfilter.log.c which were discovered by
> valgrind and ulogd.
> 
> Signed-off-by: Ivan Homoliak <xhomol11@gmail.com>
> ---
> 
> Valgrinds output:
> 
[...]
> ==13821== Syscall param socketcall.sendto(msg) points to uninitialised byte(s)
> ==13821==    at 0x3E93AF6E83: __sendto_nocancel (in /usr/lib64/libc-2.17.so)
> ==13821==    by 0x5433E81: nfnl_send (libnfnetlink.c:391)
> ==13821==    by 0x5435C0E: nfnl_query (libnfnetlink.c:1569)
> ==13821==    by 0x522E9A0: nflog_set_mode (libnetfilter_log.c:481)
> ==13821==    by 0x5029FA2: start (ulogd_inppkt_NFLOG.c:581)
> ==13821==    by 0x403E5D: create_stack_start_instances (ulogd.c:918)
> ==13821==    by 0x4041B4: create_stack (ulogd.c:1010)
> ==13821==    by 0x4078D6: config_parse_file (conffile.c:225)
> ==13821==    by 0x404411: parse_conffile (ulogd.c:1088)
> ==13821==    by 0x405478: main (ulogd.c:1573)
> ==13821==  Address 0x7feffff9d is on thread 1's stack
> ==13821==  Uninitialised value was created by a stack allocation
> ==13821==    at 0x50293D0: ??? (in /usr/lib/ulogd/ulogd_inppkt_NFLOG.so)

I found some time to looking into this. I think this patch for
*libnfnetlink* should fix this for all the libraries. Better do this
in a generic way so we skip similar reports in other libnetfilter_*
libraries. Valgrind does not report any warning anymore here.

If you can give a try to this libnfnetlink patch to confirm you see no
more valgrind warnings, I'd appreciate. Thanks.

--jI8keyz6grp/JLjh
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-libnfnetlink-initialize-attribute-padding-to-resolve.patch"

>From 7633f0c1679988ad18e4de9afc8a277510298139 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 3 Feb 2014 12:09:29 +0100
Subject: [PATCH] libnfnetlink: initialize attribute padding to resolve
 valgrind warnings

==12195== Syscall param socketcall.sendto(msg) points to uninitialised byte(s)
==12195==    at 0x51209C3: __sendto_nocancel (syscall-template.S:81)
==12195==    by 0x53E4D12: nfnl_send (libnfnetlink.c:391)
==12195==    by 0x53E6952: nfnl_query (libnfnetlink.c:1569)
==12195==    by 0x4E344AF: __build_send_cfg_msg.isra.1 (libnetfilter_log.c:143)
==12195==    by 0x4E34710: nflog_bind_group (libnetfilter_log.c:413)
==12195==    by 0x400CB1: main (nfulnl_test.c:77)
==12195==  Address 0x7fefff3e9 is on thread 1's stack

This patch sets to zero the padding that is included to align the
attribute payload.

Reported-by: Ivan Homoliak <xhomol11@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 src/libnfnetlink.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/src/libnfnetlink.c b/src/libnfnetlink.c
index 4b2bcd0..398b7d7 100644
--- a/src/libnfnetlink.c
+++ b/src/libnfnetlink.c
@@ -809,6 +809,7 @@ int nfnl_addattr_l(struct nlmsghdr *n, int maxlen, int type, const void *data,
 	nfa->nfa_type = type;
 	nfa->nfa_len = len;
 	memcpy(NFA_DATA(nfa), data, alen);
+	memset((uint8_t *)nfa + nfa->nfa_len, 0, NFA_ALIGN(alen) - alen);
 	n->nlmsg_len = (NLMSG_ALIGN(n->nlmsg_len) + NFA_ALIGN(len));
 	return 0;
 }
-- 
1.7.10.4


--jI8keyz6grp/JLjh--
