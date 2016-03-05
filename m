From: christophe leroy <christophe.leroy@c-s.fr>
Subject: Seeking help for implementing CT HELPER in nftables
Date: Sat, 5 Mar 2016 12:37:38 +0100
Message-ID: <56DAC502.2060809@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:62254 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbcCEMBh convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Mar 2016 07:01:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I'm trying to implement support for CT HELPERs in linux kernel for=20
nftables and need some help/guidance.

The rule beeing 'udp dport tftp ct helper set "tftp"', I get=20
nft_ct_set_init() called when I add the rule in the table output filter=
=20
table.

I believe I have to call nf_ct_helper_ext_add() from nft_ct_set_init(),=
=20
but for that I need the name of the helper that is to be set, ie 'tftp'=
=2E
How do I get the name of the requested helper in that function ? I=20
suppose once I get it I can do the same as  xt_ct_set_helper() does.

Christophe

---
L'absence de virus dans ce courrier =C3=A9lectronique a =C3=A9t=C3=A9 v=
=C3=A9rifi=C3=A9e par le logiciel antivirus Avast.
https://www.avast.com/antivirus

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
