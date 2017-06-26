From: Marcelo S Mota <motasmarcelo@gmail.com>
Subject: Bug on nfacct xml output
Date: Mon, 26 Jun 2017 10:17:34 -0300
Message-ID: <CAEEH+5dA8dtSTgxkFdKaWeMFvc8p8JZO+o17zFaN9vmS2y5ZWw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-yb0-f182.google.com ([209.85.213.182]:36709 "EHLO
        mail-yb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdFZNRu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 09:17:50 -0400
Received: by mail-yb0-f182.google.com with SMTP id s9so301252ybe.3
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Jun 2017 06:17:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm testing some extensions of iptables and liked a lot about nfacct.
The only issue so far was the xml output of nfacct command. Its
'packets' and 'bytes' tags are inverting values.Could you check it?

Ex:

$ nfacct list xml && nfacct list

XML output
<?xml version=3D"1.0" encoding=3D"utf-8"?>
                                              <nfacct>


<obj><name>proxy</name>pkts>00000000000084032757</pkts>bytes>00000000000000=
357594</bytes></obj>
<obj><name>proxy-down</name>pkts>00000000000480613838</pkts>bytes>000000000=
00000451605</bytes></obj>
</nfacct>

Text output
{ pkts =3D 00000000000000357594, bytes =3D 00000000000084032757 } =3D proxy=
;
                        { pkts =3D 00000000000000451605, bytes =3D
00000000000480613838 } =3D proxy-down;


Regards,

Marcelo S Mota
Abra=C3=A7=C3=A3o,

Marcelo S Mota
