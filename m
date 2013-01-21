From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] iptables: add xt_bpf match
Date: Mon, 21 Jan 2013 12:33:28 +0100
Message-ID: <20130121113328.GA3698@1984>
References: <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
 <1358529450-32413-1-git-send-email-willemb@google.com>
 <20130121112838.GA2907@1984>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="C7zPtVaVf+AK4Oqc"
Cc: netfilter-devel@vger.kernel.org
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44568 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab3AULd4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:33:56 -0500
Content-Disposition: inline
In-Reply-To: <20130121112838.GA2907@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 21, 2013 at 12:28:38PM +0100, Pablo Neira Ayuso wrote:
> Hi Willem,
> 
> I have applied this patch to my nf-next tree with minor changes.

This was also missing, I have applied this patch as well.

--C7zPtVaVf+AK4Oqc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-add-missing-xt_bpf.h-header-in-installatio.patch"

>From e7db3cbcd6508235d63ba4a31bbd1ce4fdece6e1 Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 21 Jan 2013 12:30:59 +0100
Subject: [PATCH] netfilter: add missing xt_bpf.h header in installation

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/netfilter/Kbuild
index 08f555f..8b4bd36 100644
--- a/include/uapi/linux/netfilter/Kbuild
+++ b/include/uapi/linux/netfilter/Kbuild
@@ -35,6 +35,7 @@ header-y += xt_TCPOPTSTRIP.h
 header-y += xt_TEE.h
 header-y += xt_TPROXY.h
 header-y += xt_addrtype.h
+header-y += xt_bpf.h
 header-y += xt_cluster.h
 header-y += xt_comment.h
 header-y += xt_connbytes.h
-- 
1.7.10.4


--C7zPtVaVf+AK4Oqc--
