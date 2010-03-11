From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Assignment port procedure
Date: Thu, 11 Mar 2010 01:37:16 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003110131090.6618@obet.zrqbmnf.qr>
References: <700FD7E4-E34D-4020-8748-F2DDCAA661A0@uic.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: =?UTF-8?Q?Giuseppe_Macr=C3=AC?= <gmacri2@uic.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:43114 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932907Ab0CKAhS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Mar 2010 19:37:18 -0500
In-Reply-To: <700FD7E4-E34D-4020-8748-F2DDCAA661A0@uic.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-03-11 00:06, Giuseppe Macr=C3=AC wrote:

>Very new in netfilter developing.
>I would like change assignment port procedure into the nat part of net=
filter. I'm looking at nf_nat_proto_common.c, exactly at get_unique_tup=
le function (linux/net/ipv4/netfilter).
>Is it the correct way to proceed?
>Last question: does iptables handle nat with the nf_nat.ko module or=20
>with something else?

"iptables does not handle NAT with nf_nat,
nf_nat handles NAT with iptables."

More precisely, nf_nat works mostly autonomically, but consults
the "nat" table from Xtables for new transformations.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
