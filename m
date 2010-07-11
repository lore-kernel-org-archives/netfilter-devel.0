From: Pete Kay <petedao@gmail.com>
Subject: Re: Problem with Too many levels of symbolic links
Date: Sun, 11 Jul 2010 18:46:00 +0800
Message-ID: <AANLkTimSZoG410ny_M2RRy_P7X2dSAFxYZTNWsz-CkTu@mail.gmail.com>
References: <AANLkTinBc_6zISFzIpJU0WoWh21D3t37YfdZ9bJA6i2F@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:50067 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841Ab0GKKqB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Jul 2010 06:46:01 -0400
Received: by pxi14 with SMTP id 14so1438860pxi.19
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Jul 2010 03:46:00 -0700 (PDT)
In-Reply-To: <AANLkTinBc_6zISFzIpJU0WoWh21D3t37YfdZ9bJA6i2F@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

I am pretty much desperate at this moment with the problem.  I don't
understand why I am kept getting "invalid argument" from commit.  I am
using 1.4.7 and the kernel is 2.6.33.

Can someone please point me to the right direction?  How can I debug th=
is issue?

Thanks,
p

On Sat, Jul 10, 2010 at 11:15 PM, Pete Kay <petedao@gmail.com> wrote:
> Hi,
>
> I have written a very simple program to add iptables rule, but I am
> kept getting " Too many levels of symbolic links" .
>
> Does anyone know what is wrong?
>
>
> =A0int ret =3D 0;
> =A0iptc_handle_t =A0 h =3D iptc_init("nat");
>
> =A0struct ipt_entry_match *match;
> =A0struct ipt_udp *match_udp;
> =A0struct ipt_entry_target *target;
> =A0char callee_inhibitor_buf[IPTC_FULL_SIZE];
> =A0struct ipt_entry *entry =3D (struct ipt_entry *) callee_inhibitor_=
buf;
>
>
> =A0 =A0memset(entry, 0, IPTC_FULL_SIZE);
> =A0 =A0entry->ip.proto =3D IPPROTO_UDP;
> =A0 =A0entry->ip.src.s_addr =3D inet_addr("192.168.3.2");
>
> =A0 =A0memset(&entry->ip.smsk, 255, sizeof(struct in_addr));
> =A0entry ->ip.smsk.s_addr =3D =A0 0xffffffff;
> =A0 entry->ip.dst.s_addr =3D inet_addr("200.168.3.3");
> =A0 =A0 =A0 =A0entry ->ip.dmsk.s_addr =A0=3D 0xffffffff;
> =A0 =A0entry->target_offset =3D IPTC_ENTRY_SIZE + IPTC_MATCH_SIZE;
> =A0 =A0entry->next_offset =3D IPTC_FULL_SIZE;
> =A0 =A0match =3D (struct ipt_entry_match *) entry->elems;
> =A0// =A0 =A0match =3D (struct ipt_entry_match *)entry->elems;
> =A0 =A0 =A0 =A0match->u.user.match_size =3D IPTC_MATCH_SIZE;
> =A0 =A0strcpy(match->u.user.name, "udp");
> =A0 =A0match_udp =3D (struct ipt_udp*) &match->data;
> =A0 =A0match_udp->spts[0] =3D 5060;match_udp->spts[1] =3D 5060;
> =A0 =A0match_udp->dpts[0] =3D 5070;match_udp->dpts[1] =3D 5070;
> =A0 =A0target =3D (struct ipt_entry_target*) (match + IPTC_MATCH_SIZE=
);
>
> =A0 =A0target->u.user.target_size =3D IPTC_TARGET_SIZE;
> =A0 =A0strcpy(target->u.user.name, "ACCEPT");
> =A0 =A0ret =3D iptc_append_entry ("PREROUTING", entry, h);
> =A0 =A0 =A0 =A0if (!ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("append : %s\n", iptc_strerror(=
errno));
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ret =3Diptc_commit(h);
> =A0 =A0 =A0 =A0printf("commit =3D[%i]\n", ret);
> =A0 =A0 =A0 =A0if (!ret) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("commit: %s\n", iptc_strerror(e=
rrno));
> =A0 =A0 =A0 =A0}
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
