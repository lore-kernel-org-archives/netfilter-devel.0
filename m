From: Salva <salva9@gmail.com>
Subject: can't resize payload
Date: Sun, 31 Jan 2010 19:58:50 +0100
Message-ID: <651220411001311058u4f61f34alea5a8496beecf01d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47910 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751305Ab0AaS6v convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 31 Jan 2010 13:58:51 -0500
Received: by ewy19 with SMTP id 19so1457657ewy.1
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Jan 2010 10:58:50 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I try to resize the payload of TCP packed but i can't. I don't know if
this is the right way?

This is the part of code:

   len =3D nfq_get_payload(nfa, &full_packet);
   struct ip *iphdr =3D (struct ip *) full_packet;

   int=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0 iphlen =3D iphdr->ip_hl<<2;
   struct tcphdr *tcp =3D (struct tcphdr *)((caddr_t )iphdr + iphlen);

   unsigned char *pl_data =3D (void *)tcp + (tcp->doff*4)+32;
   ...
   pl_data =3D realloc(pl_data, (strlen((char *)pl_data) ) +
(sizeof(char) * strlen(m))+1 );
   ...

This part of code works only sometimes and some others fails with
invalid pointer
Can i use realloc to allocate more memory in this case?

How can i allocate more memory for the payload?

I don't know if is the correct mailing list for this kind of questions?
If not, there's another list available?

Salva
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
