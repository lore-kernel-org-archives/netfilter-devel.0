From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] iptables: add xt_bpf match
Date: Mon, 21 Jan 2013 13:03:33 +0100
Message-ID: <20130121120333.GA5831@1984>
References: <CA+FuTSeU8m8Hect+2cT6QOmfNH3oJ8mASOat-zn3-3WwJxJNZg@mail.gmail.com>
 <1358529450-32413-1-git-send-email-willemb@google.com>
 <20130121112838.GA2907@1984>
 <20130121113328.GA3698@1984>
 <20130121114220.GB8541@breakpoint.cc>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Nq2Wo0NMKNjxTN9z"
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54788 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753335Ab3AUMDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:03:37 -0500
Content-Disposition: inline
In-Reply-To: <20130121114220.GB8541@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--Nq2Wo0NMKNjxTN9z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 21, 2013 at 12:42:20PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Jan 21, 2013 at 12:28:38PM +0100, Pablo Neira Ayuso wrote:
> > > Hi Willem,
> > > 
> > > I have applied this patch to my nf-next tree with minor changes.
> 
> [..]
> 
> > diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/netfilter/Kbuild
> > index 08f555f..8b4bd36 100644
> > --- a/include/uapi/linux/netfilter/Kbuild
> > +++ b/include/uapi/linux/netfilter/Kbuild
> > @@ -35,6 +35,7 @@ header-y += xt_TCPOPTSTRIP.h
> >  header-y += xt_TEE.h
> >  header-y += xt_TPROXY.h
> >  header-y += xt_addrtype.h
> > +header-y += xt_bpf.h
> 
> Good catch. I forgot about that too, so xt_connlabel.h is also missing.

Patch attached, thanks for spotting this.

--Nq2Wo0NMKNjxTN9z
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-add-missing-xt_connlabel.h-header-in-insta.patch"

>From 7a95ad28c40fec445b0e1463fd8ed638701ad94d Mon Sep 17 00:00:00 2001
From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 21 Jan 2013 13:02:19 +0100
Subject: [PATCH] netfilter: add missing xt_connlabel.h header in installation

Reported-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/uapi/linux/netfilter/Kbuild b/include/uapi/linux/netfilter/Kbuild
index 8b4bd36..4111577 100644
--- a/include/uapi/linux/netfilter/Kbuild
+++ b/include/uapi/linux/netfilter/Kbuild
@@ -39,6 +39,7 @@ header-y += xt_bpf.h
 header-y += xt_cluster.h
 header-y += xt_comment.h
 header-y += xt_connbytes.h
+header-y += xt_connlabel.h
 header-y += xt_connlimit.h
 header-y += xt_connmark.h
 header-y += xt_conntrack.h
-- 
1.7.10.4


--Nq2Wo0NMKNjxTN9z--
