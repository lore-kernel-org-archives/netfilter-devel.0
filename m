From: Pete Kay <petedao@gmail.com>
Subject: Re: strange IP rewrite of the libnetfilter_conntrack
Date: Fri, 30 Jul 2010 11:43:22 +0800
Message-ID: <AANLkTikvBdAVm2yGm8=hBW6Ug15todYM1_OEqzvD3Ocv@mail.gmail.com>
References: <AANLkTi=dRN+B7OvmZ4FHC7BFV+9r9Ag94SHF5BTTPL-3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43092 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755749Ab0G3DnX convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jul 2010 23:43:23 -0400
Received: by pzk26 with SMTP id 26so372217pzk.19
        for <netfilter-devel@vger.kernel.org>; Thu, 29 Jul 2010 20:43:22 -0700 (PDT)
In-Reply-To: <AANLkTi=dRN+B7OvmZ4FHC7BFV+9r9Ag94SHF5BTTPL-3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for the previous mail.  My problem is solved. It should have use
ntfc_set_attr_u32 for address.
Please kindly ignore.

P

On Fri, Jul 30, 2010 at 11:34 AM, Pete Kay <petedao@gmail.com> wrote:
> Hi,
>
> I am trying to add the following rule to the conntrack table:
>
> nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
> nfct_set_attr_u32(ct, ATTR_IPV4_SRC, inet_addr("192.168.1.20"));
> nfct_set_attr_u32(ct, ATTR_IPV4_DST, inet_addr("192.168.1.114"));
> nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_UDP);
> nfct_set_attr_u16(ct, ATTR_PORT_SRC, htons(10012);
> nfct_set_attr_u16(ct, ATTR_PORT_DST, htons(18482);
>
> nfct_setobjopt(ct, NFCT_SOPT_SETUP_REPLY);
> nfct_set_attr_u32(ct, ATTR_TIMEOUT, 100);
>
> nfct_set_attr_u16(ct, ATTR_SNAT_IPV4, inet_addr("192.168.1.114"));
> nfct_set_attr_u16(ct, ATTR_SNAT_PORT, htons(18480);
> nfct_set_attr_u16(ct, ATTR_DNAT_IPV4, inet_addr("192.168.1.56");
> nfct_set_attr_u16(ct, ATTR_DNAT_PORT, htons(16385);
>
>
> The tcpdump shows:
>
> 11:24:44.062306 IP 192.168.1.20.10012 > 192.168.1.114.18482: udp/rtp
> 160 c0 =A017381 2867392
> 11:24:44.062336 IP=A0192.168.0.0.18482=A0>=A0192.168.0.0.16385: udp/r=
tp 160
> c0 =A017381 2867392
>
> But I am actually expecting:
>
> 11:24:44.062306 IP 192.168.1.20.10012 > 192.168.1.114.18482: udp/rtp
> 160 c0 =A017381 2867392
> 11:24:44.062336 IP 1192.168.1.114.18482 > 192.168.1.56.16385: udp/rtp
> 160 c0 =A017381 2867392
>
>
> Can someone tell me what is wrong with my code?
>
> Thanks,
> P
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
