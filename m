From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: extensions: libxt_MARK: Add translation to nft
Date: Tue, 14 Jun 2016 19:14:16 +0200
Message-ID: <20160614171416.GA2500@salvia>
References: <1465924342-2680-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: rodanber@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51754 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153AbcFNROW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 Jun 2016 13:14:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E531DED063
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 19:14:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D35F29EBA7
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 19:14:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 983B79EBA9
	for <netfilter-devel@vger.kernel.org>; Tue, 14 Jun 2016 19:14:18 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1465924342-2680-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 14, 2016 at 07:12:22PM +0200, rodanber@gmail.com wrote:
> From: Roberto Garc=EDa <rodanber@gmail.com>
>=20
> Add translation for the MARK target to nftables.
>=20
> Examples:
>=20
> $ sudo iptables-translate -t mangle -A OUTPUT -j MARK --set-mark 64
>=20
> nft add rule ip mangle OUTPUT counter meta mark set 0x40
>=20
> $ sudo iptables-translate -t mangle -A OUTPUT -j MARK --set-xmark 0x4=
0/0x32
>=20
> nft add rule ip mangle OUTPUT counter meta mark set mark xor 0x40 and=
 0x32
>=20
> $ sudo iptables-translate -t mangle -A OUTPUT -j MARK --or-mark 64
>=20
> nft add rule ip mangle OUTPUT counter meta mark set mark or 0x40
>=20
> $ sudo iptables-translate -t mangle -A OUTPUT -j MARK --and-mark 64
>=20
> nft add rule ip mangle OUTPUT counter meta mark set mark and 0x40
>=20
> $ sudo iptables-translate -t mangle -A OUTPUT -j MARK --xor-mark 64
>=20
> nft add rule ip mangle OUTPUT counter meta mark set mark xor 0x40

This one applies. Applied, thanks :)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
