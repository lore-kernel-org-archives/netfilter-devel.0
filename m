Return-Path: <SRS0=zc7w=DV=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED31EC433E7
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 09:39:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 796382076D
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Oct 2020 09:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=orange.com header.i=@orange.com header.b="DRaFxs+E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgJNJjM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Oct 2020 05:39:12 -0400
Received: from relais-inet.orange.com ([80.12.66.40]:31635 "EHLO
        relais-inet.orange.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726028AbgJNJjM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Oct 2020 05:39:12 -0400
X-Greylist: delayed 432 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Oct 2020 05:39:11 EDT
Received: from opfedar05.francetelecom.fr (unknown [xx.xx.xx.7])
        by opfedar25.francetelecom.fr (ESMTP service) with ESMTP id 4CB6cp109gz8vRP;
        Wed, 14 Oct 2020 11:31:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orange.com;
        s=ORANGE001; t=1602667914;
        bh=qNw6y2kY2Jbzy87F+oQdoGQXWfS0B9dEBU2/mD/oJ0o=;
        h=From:To:Subject:Date:Message-ID:Content-Type:
         Content-Transfer-Encoding:MIME-Version;
        b=DRaFxs+Ea9FiCwmbsj3Sr+BKATWKzAT9Llxo6dtbQ0S8X8rYUE0nUg1h+d7gQ3HdP
         pVE2bDfG5iU2etb6uxjPSRkLHxPpwPfQWJM4asSJMm9VKfZhJjWZEeSrKOTF3bOkOg
         /UdJ7U83VO6k1r0O1fw6bnHzurxgxUAu7YdmEDvYMDJIJjdJ2ytChll7peElWKX7bg
         3dkQlKLFcs4jc/uBDGtLdFzNIZfexwQwQcnD+rqZYxgQCyyRkA9RLiTD0xBLrLk0oQ
         nzYWKMcsgyBr493SswlqeCmTnyOSRUaLw0CFpQoW8FeTeCD/dTMiUADjmsBj1mk9Ka
         GDo8gNlSBpGOg==
Received: from Exchangemail-eme6.itn.ftgroup (unknown [xx.xx.13.73])
        by opfedar05.francetelecom.fr (ESMTP service) with ESMTP id 4CB6cn6zLFz2xCD;
        Wed, 14 Oct 2020 11:31:53 +0200 (CEST)
From:   <timothee.cocault@orange.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: Bug: ebtables snat drops small packets
Thread-Topic: Bug: ebtables snat drops small packets
Thread-Index: AdaiDCXbAG6o1RoDRYa681Sp+IMcHg==
Date:   Wed, 14 Oct 2020 09:31:52 +0000
Message-ID: <19748_1602667914_5F86C589_19748_131_22_585B71F7B267D04784B84104A88F7DEE0DB50179@OPEXCAUBM34.corporate.adroot.infra.ftgroup>
Accept-Language: fr-FR, en-US
Content-Language: fr-FR
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.114.13.245]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi !

I noticed a bug when using the snat module of ebtables.
If the ethernet payload of a packet is less than 12 bytes, the packet gets =
dropped.

I traced it down to this commit which changes calls to `skb_make_writable` =
to `skb_ensure_writable` :
https://github.com/torvalds/linux/commit/c1a8311679014a79b04c039e32bde34fb6=
8952fd

The diff gives a clear hint of the bug. For example, in `net/bridge/netfilt=
er/ebt_snat.c` :

-   if (!skb_make_writable(skb, 0))
+   if (skb_ensure_writable(skb, ETH_ALEN * 2))
        return EBT_DROP;

The goal was to make the ethernet source and destination address writable, =
but the function seems to expects a number of bytes after the Ethernet head=
er.
Hence, packets with a payload < 12 bytes are dropped. It probably applies t=
o the other changes of the commit too.

I can confirm that setting the `write_len` parameter back to 0 "fixes" the =
bug, but I'm not familiar with the code enough to know if the call is neede=
d altogether.


Given below is a "minimal" working example to reproduce the bug:

Setup two bridges, linked with veth adapters:

    ip link add veth1 type veth peer name veth2
    ip link set veth1 address 66:47:61:00:00:01
    ip link set veth2 address 66:47:61:00:00:02
    ip link add br1 type bridge
    ip link add br2 type bridge
    ip link set veth1 master br1
    ip link set veth2 master br2
    ip link set br1 up
    ip link set br2 up
    ip link set veth1 up
    ip link set veth2 up

Add a rule that changes the source of 802.1X packets from br1 to br2:

    ebtables -t nat -A POSTROUTING -s 66:47:61:00:00:01 -p 0x888e -j snat -=
-to-src 66:47:61:00:00:03 --snat-target ACCEPT

Send a packet to br2 (a dummy 802.1X packet with 12 bytes of payload):

    #!/usr/bin/env python3
    import socket
    size =3D 12
    s =3D socket.socket(socket.AF_PACKET, socket.SOCK_DGRAM)
    addr =3D ('br1', 0x888e, 0, 1, b'\x66\x47\x61\x00\x00\x02')
    s.sendto(b'\xff' * size, addr)
    s.close()

If we run tcpdump/wireshark on br2, we can see that the packets are present=
, with the snatted source MAC (:03).
However, if we send a packet with size =3D 11, the packet is dropped and we=
 don't see it on br2.


Regards,
Timoth=E9e.

___________________________________________________________________________=
______________________________________________

Ce message et ses pieces jointes peuvent contenir des informations confiden=
tielles ou privilegiees et ne doivent donc
pas etre diffuses, exploites ou copies sans autorisation. Si vous avez recu=
 ce message par erreur, veuillez le signaler
a l'expediteur et le detruire ainsi que les pieces jointes. Les messages el=
ectroniques etant susceptibles d'alteration,
Orange decline toute responsabilite si ce message a ete altere, deforme ou =
falsifie. Merci.

This message and its attachments may contain confidential or privileged inf=
ormation that may be protected by law;
they should not be distributed, used or copied without authorisation.
If you have received this email in error, please notify the sender and dele=
te this message and its attachments.
As emails may be altered, Orange is not liable for messages that have been =
modified, changed or falsified.
Thank you.

