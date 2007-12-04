From: "Salatiel Filho" <salatiel.filho@gmail.com>
Subject: Re: iptables -> can't initialize iptables table `filter': Bad file descriptor
Date: Tue, 4 Dec 2007 13:32:49 -0300
Message-ID: <beb91d720712040832p71981f85yd097f86614e680af@mail.gmail.com>
References: <beb91d720712021122w93088ccjf4544c591df3c4b5@mail.gmail.com>
	 <47551A83.80009@trash.net>
	 <beb91d720712040616o7e2ac99ch51ade98dbbd2efa@mail.gmail.com>
	 <475561C6.4030704@trash.net>
	 <beb91d720712040645w76be238bmdd9dc362bf601755@mail.gmail.com>
	 <47556D32.1060901@trash.net>
	 <beb91d720712040740kc777867s7ec9ff2ee909c778@mail.gmail.com>
	 <475578F1.8060600@trash.net>
	 <beb91d720712040805u7dd0241by2349e9b34c361a87@mail.gmail.com>
	 <47557D04.1040101@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Netfilter Development Mailinglist" <netfilter-devel@vger.kernel.org>
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.236]:55156 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLDQcv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Dec 2007 11:32:51 -0500
Received: by wr-out-0506.google.com with SMTP id c49so3044004wra
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Dec 2007 08:32:50 -0800 (PST)
In-Reply-To: <47557D04.1040101@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/4/07, Patrick McHardy <kaber@trash.net> wrote:
> Salatiel Filho wrote:
> > On 12/4/07, Patrick McHardy <kaber@trash.net> wrote:
> >> Salatiel Filho wrote:
> >>> ~# iptables -L
> >>> iptables v1.3.8: can't initialize iptables table `filter': Invali=
d argument
> >>> Perhaps iptables or your kernel needs to be upgraded.
> >>>
> >>> # dmesg
> >>> ip_tables: (C) 2000-2002 Netfilter core team
> >>> translate_table: size 632
> >>> Finished chain 1
> >>> Finished chain 2
> >>> Finished chain 3
> >>> table->private->number =3D 4
> >>> get_entries: 668 !=3D 672
> >> This looks like an alignment problem. Old kernels required
> >> alignof(struct ipt_entry), which should be 4. Userspace
> >> compiled against current headers use:
> >>
> >> struct _xt_align
> >> {
> >>          u_int8_t u8;
> >>          u_int16_t u16;
> >>          u_int32_t u32;
> >>          u_int64_t u64;
> >> };
> >>
> >> #define XT_ALIGN(s) (((s) + (__alignof__(struct _xt_align)-1))  \
> >>
> >>                          & ~(__alignof__(struct _xt_align)-1))
> >>
> >> which I guess is 8 on ARM. Does removing the u_int64_t
> >> from the struct above in the iptables source
> >> (include/linux/netfilter/x_tables.h) help?
> >>
> >>
> >
> > I can not find include/linux/netfilter/x_tables.h in iptables sourc=
e.
> >
> > # ls -1 include/linux/netfilter/
> > nf_conntrack_common.h
> > nf_conntrack_tuple_common.h
> > nf_conntrack_tuple.h
> > nf_nat.h
>
> Right, we only recently added it. Are you compiling against your
> kernel source? Otherwise check in /usr/include/linux/...
>
How do i know if i am compiling against my kernel source ?
Does it auto use /usr/src/linux/... ?
anyway , i changed /usr/include/linux/linux/netfilter/x_tables.h but
still the same problem.


# iptables -L
iptables v1.3.8: can't initialize iptables table `filter': Invalid argu=
ment
Perhaps iptables or your kernel needs to be upgraded.

# dmesg
ip_tables: (C) 2000-2002 Netfilter core team
translate_table: size 632
=46inished chain 1
=46inished chain 2
=46inished chain 3
table->private->number =3D 4
get_entries: 668 !=3D 672

--=20
[]'s
Salatiel

"O maior prazer do inteligente =E9 bancar o  idiota
   diante de um  idiota que banca o inteligente".
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
