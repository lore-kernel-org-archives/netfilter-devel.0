From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: extensions: libxt_MARK: Fix translation of
 --set-xmark option
Date: Wed, 22 Jun 2016 19:55:40 +0200
Message-ID: <20160622175540.GC8772@salvia>
References: <1466543023-15740-1-git-send-email-rodanber@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: rodanber@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45426 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbcFVRzw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 22 Jun 2016 13:55:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2B412E8E91
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:55:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1C4E1A827A
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:55:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 07D769EBA4
	for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2016 19:55:49 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1466543023-15740-1-git-send-email-rodanber@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jun 21, 2016 at 11:03:43PM +0200, rodanber@gmail.com wrote:
> From: Roberto Garc=EDa <rodanber@gmail.com>
>=20
> Fix translation of MARK target's --set-xmark option.
>=20
> Before:
>=20
>  # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x6=
4/0xaf
>   nft add rule ip mangle PREROUTING counter meta mark set mark xor 0x=
64 and 0xaf
>=20
> After:
>=20
>   # iptables-translate -t mangle -A PREROUTING -j MARK --set-xmark 0x=
64/0xaf
>   nft add rule ip mangle PREROUTING counter meta mark set mark xor 0x=
64 and \
>   0xffffff50

Applied, thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
