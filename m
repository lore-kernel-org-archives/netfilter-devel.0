From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: extensions: libxt_MARK: Add translation for
 revision 1 to nft
Date: Wed, 22 Jun 2016 19:51:04 +0200
Message-ID: <20160622175104.GA8772@salvia>
References: <1466539704-1666-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: rodanber@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44726 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235AbcFVRvJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 13:51:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 230FFE8E85
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:51:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 128189EBAC
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:51:08 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 130E6A5A9
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:51:06 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466539704-1666-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 21, 2016 at 10:08:24PM +0200, rodanber@gmail.com wrote:
> From: Roberto Garc=EDa <rodanber@gmail.com>
>=20
> Add translation for revision 1 of the MARK target to nft.
>=20
> Examples:
>=20
>   # iptables-translate -t mangle -A PREROUTING -j MARK --set-mark 0x6=
4
>   nft add rule ip mangle PREROUTING counter meta mark set 0x64
>=20
>   # iptables-translate -t mangle -A PREROUTING -j MARK --and-mark 0x6=
4
>   nft add rule ip mangle PREROUTING counter meta mark set mark and 0x=
64
>=20
>   # iptables-translate -t mangle -A PREROUTING -j MARK --or-mark 0x64
>   nft add rule ip mangle PREROUTING counter meta mark set mark or 0x6=
4

Applied, thanks.

Roberto, please make sure your editor highlights trailing whitespace
and unnecessary indentations. This is usually very easy to enable.

This time I have fixed this here, but you make it easier for me if you
already deal with this.

Note that otherwise I get this warnings:

Applying: iptables: extensions: libxt_MARK: Add translation for revisio=
n 1 to nft
patch:28: trailing whitespace.
        case XT_MARK_OR:=20
patch:32: trailing whitespace.

warning: 2 lines add whitespace errors.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
