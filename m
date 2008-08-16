From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [RFC] netfilter: Rename ipt_ECN.h to ipt_ecn_target.h (and
 similar) to avoid file name clash
Date: Sat, 16 Aug 2008 10:04:00 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808160958570.30044@fbirervta.pbzchgretzou.qr>
References: <g84ufs$l66$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, kaber@trash.net
To: =?UTF-8?Q?P=C4=93teris_K=C4=BCavi=C5=86=C5=A1?=
	<klavins@netspace.net.au>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35666 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbYHPOEE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Aug 2008 10:04:04 -0400
In-Reply-To: <g84ufs$l66$1@ger.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2008-08-15 18:03, P=C4=93teris K=C4=BCavi=C5=86=C5=A1 wrote:

> This is a request for comments on the proposal that the following
> filename changes (indicative at this point) be made in the
> netfilter source code tree, together with correcting the
> corresponding references to the files in both source code, the
> build system, and wherever else necessary.
>
> The changes are proposed in order to avoid file name clashes on
> filesystems that do not allow two files to have names that differ
> only in the case of their letters:
>
> include/linux/netfilter/xt_CONNMARK.h =3D> xt_connmark_target.h
[...]

As I see it, this will already be addressed by merging complementary
code into one source file (e.g. MARK, mark, CONNMARK, connmark
all into a big new xt_mark.c), to reduce (a) amount of files
and (b) build time.

This has been touched before at
http://marc.info/?l=3Dnetfilter-devel&m=3D121148631320895&w=3D2
I welcome that idea, but have yet been holding off sending patches
on that because these code-moving changes would possibly generate
a lot of .rej noise while I am still having other patches in my
queue.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
