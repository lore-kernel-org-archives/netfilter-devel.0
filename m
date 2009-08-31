From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [PATCH] TProxy: added IPv6 support for socket match
Date: Mon, 31 Aug 2009 10:41:40 +0000
Message-ID: <1251715300.5659.128.camel@bzorp.balabit>
References: <cover.1251439150.git.bazsi@balabit.hu>
	 <611922658001654b08214cc17ac47e2aa53f88fb.1251439150.git.bazsi@balabit.hu>
	 <alpine.LSU.2.00.0908301426390.4073@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:49472 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750715AbZHaKlm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:41:42 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id CEDE913A13F
	for <netfilter-devel@vger.kernel.org>; Mon, 31 Aug 2009 12:41:41 +0200 (CEST)
In-Reply-To: <alpine.LSU.2.00.0908301426390.4073@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2009-08-30 at 14:26 +0200, Jan Engelhardt wrote:
> On Friday 2009-08-28 07:56, Balazs Scheidler wrote:
> >+++ b/include/linux/netfilter/xt_socket.h
> >@@ -0,0 +1,8 @@
> >+#ifndef _XT_SOCKET_H_match
> >+#define _XT_SOCKET_H_match
> >+
> >+struct xt_socket_match_info1 {
> >+	__u8 transparent:1;
> >+};
> >+
> >+#endif /* _XT_SOCKET_H_match */
> 
> Bitfields are a no-no in the ABI.
> 

Ops, I took that patch from an ancient userspace patch created earlier
by Panther.

It did work for me, as the kernel uses:

enum {
        XT_SOCKET_TRANSPARENT = 1 << 0,
};

struct xt_socket_mtinfo1 {
        __u8 flags;
};


Thanks for noticing.

-- 
Bazsi


