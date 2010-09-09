From: James King <t.james.king@gmail.com>
Subject: Re: need help with capturing packet and bytes count from conntrack
Date: Thu, 9 Sep 2010 16:19:32 -0700
Message-ID: <AANLkTimwZ0cdAV+voo1kJdqR2iQb4eiwv4O+5H9WQfMZ@mail.gmail.com>
References: <AANLkTimVxDP9PMOcA2bAXqcxiXj+J1Yx1n3Jfvferntr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pete Kay <petedao@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48207 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338Ab0IIXTi convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:19:38 -0400
Received: by iwn5 with SMTP id 5so1530030iwn.19
        for <netfilter-devel@vger.kernel.org>; Thu, 09 Sep 2010 16:19:37 -0700 (PDT)
In-Reply-To: <AANLkTimVxDP9PMOcA2bAXqcxiXj+J1Yx1n3Jfvferntr@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 9, 2010 at 6:19 AM, Pete Kay <petedao@gmail.com> wrote:
> Hi,
>
> I am trying to write a small piece of code to obtain the packet count
> and bytes count for a connection.
>
> Here is what I get from conntrack -L
>
> [root@linux]# conntrack -L -p udp -s 192.168.1.179 -d 192.168.1.115
> --sport 10374
> udp =A0 =A0 =A017 88 src=3D192.168.1.179 dst=3D192.168.1.115 sport=3D=
10374
> dport=3D26926 packets=3D850 bytes=3D170000 src=3D192.168.1.56
> dst=3D192.168.1.115 sport=3D16395 dport=3D26924 packets=3D571 bytes=3D=
159880
> [ASSURED] mark=3D0 use=3D1
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> When I run the following source code, I get 0 for all caller_bytes,
> callee_bytes, caller_packets, callee_packets, does anyone know what i=
s
> wrong with my code here?
>
>
> =A0uint32_t caller_bytes, callee_bytes, caller_packets, callee_packet=
s;
> =A0 =A0 =A0 =A0int ret =3D 0;
> =A0 =A0 =A0 =A0struct nfct_handle *h;
> =A0 =A0 =A0 =A0struct nf_conntrack *ct;
> =A0 =A0 =A0 =A0ct =3D nfct_new();
> =A0 =A0 =A0 =A0if (!ct) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror("nfct_new");
>
> =A0 =A0 =A0 =A0}
>
> =A0 =A0 =A0 =A0switch_log_printf(SWITCH_CHANNEL_CHANNEL_LOG(channel),
> SWITCH_LOG_DEBUG, "end_point_media_ip=3D[%s] end_point_media_port=3D[=
%s]
> server_media_ip=3D[%s] se$
>
> =A0 =A0 =A0 =A0nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
> =A0 =A0 =A0 =A0nfct_set_attr_u32(ct, ATTR_IPV4_SRC, inet_addr("192.16=
8.1.179"));
> =A0 =A0 =A0 =A0nfct_set_attr_u32(ct, ATTR_IPV4_DST, inet_addr("192.16=
8.1.115"));
> =A0 =A0 =A0 =A0nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_UDP);
> =A0 =A0 =A0 =A0nfct_set_attr_u16(ct, ATTR_PORT_SRC, htons(10374);
> =A0 =A0 =A0 =A0nfct_set_attr_u16(ct, ATTR_PORT_DST, htons(26926);
>
> =A0 =A0 =A0 =A0h =3D nfct_open(CONNTRACK, 0);
> =A0 =A0 =A0 =A0if (!h) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0perror("nfct_open");
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0ret =3D nfct_query(h, NFCT_Q_GET, ct);
> =A0 =A0 =A0 =A0printf("TEST: query conntrack ");
> =A0 =A0 =A0 =A0if (ret =3D=3D -1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("(%d)(%s)\n", ret, strerror(errno))=
;
> =A0 =A0 =A0 =A0else
> =A0 =A0 =A0 =A0 =A0 =A0 =A0printf("(OK)\n");
>
>
> =A0 =A0 =A0 =A0caller_bytes =3D nfct_get_attr_u32(ct, ATTR_ORIG_COUNT=
ER_BYTES);
> =A0 =A0 =A0 =A0callee_bytes =3D nfct_get_attr_u32(ct, ATTR_REPL_COUNT=
ER_BYTES);
> =A0 =A0 =A0 =A0caller_packets =3D nfct_get_attr_u32(ct, ATTR_ORIG_COU=
NTER_PACKETS);
> =A0 =A0 =A0 =A0callee_packets =3D nfct_get_attr_u32(ct, ATTR_REPL_COU=
NTER_PACKETS);
> =A0 =A0 =A0 =A0nfct_close(h);
>
> =A0 =A0 =A0 =A0printf("caller_bytes=3D[%lu] callee_bytes=3D[%lu]
> caller_packet=3D[%lu] callee_packet=3D[%lu]\n", (unsigned
> long)caller_bytes, (unsigned long)callee_bytes, (unsigned
> long)caller_packets,(unsigned long) callee_packets);

I believe you need to register a callback before calling nfct_query()
and issue the get attribute calls from there.  See
utils/conntrack_get.c
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
