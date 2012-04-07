From: Florian Westphal <fw@strlen.de>
Subject: Re: a possible bug in netfilter
Date: Sat, 7 Apr 2012 17:58:47 +0200
Message-ID: <20120407155847.GB28425@Chamillionaire.breakpoint.cc>
References: <4F7E6D32.9060109@gmail.com>
 <alpine.LNX.2.01.1204061444170.19371@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: fw@strlen.de,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Serge Leschinsky <serge.leschinsky@gmail.com>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:51094 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754933Ab2DGP6s (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 7 Apr 2012 11:58:48 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1204061444170.19371@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt <jengelh@medozas.de> wrote:
> On Friday 2012-04-06 06:12, Serge Leschinsky wrote:
> >
> > Sometimes my system panics and below you can find the information I was able to
> > catch via netconsole.
> >
> > LFS-based system, kernel 3.3.1, xtables-addons 1.41
> >
> > BUG: unable to handle kernel paging request at 00003800 00000000
> > IP: [<ffffffffa02001bd>] xt_psd_match+0x1bd/0x5f4 [xt_psd]
> > 80 00 00 00 00 48 39 f8 0f 84 57 03 00 00 48 89 45 c8
> ><48>8b 00 48 85 c0 75 eb 48 8d 04 92 83 c1 01 89 0d 56 b7 00 00
> 
> Two asm candidates pop up here:
> 
>  168:   48 8b 3f                mov    rdi,QWORD PTR [rdi]
> 
>  372:   48 8b 00                mov    rax,QWORD PTR [rax]
>  375:   48 85 c0                test   rax,rax
> 
> This maps to lines lines similar to  (curr = curr->next) != NULL.

I wonder wheter we're corrupting curr->next via curr->ports[] overflow.

Serge, could you try this patch?

diff --git a/extensions/xt_psd.c b/extensions/xt_psd.c
index 46b2831..acb5e8e 100644
--- a/extensions/xt_psd.c
+++ b/extensions/xt_psd.c
@@ -227,7 +227,7 @@ xt_psd_match(const struct sk_buff *pskb, struct xt_action_param *match)
 				goto out_match;
 
 			/* Remember the new port */
-			if (curr->count < SCAN_MAX_COUNT) {
+			if (curr->count < ARRAY_SIZE(curr->ports)) {
 				curr->ports[curr->count].number = dest_port;
 				curr->ports[curr->count].proto = proto;
 				curr->ports[curr->count].and_flags = tcp_flags;
