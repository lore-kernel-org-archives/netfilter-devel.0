From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/2] extensions: restore matching any SPI id by default
Date: Mon, 10 Aug 2015 14:15:44 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1508101400520.10742@nerf40.vanv.qr>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de> <1436964819-28109-3-git-send-email-jengelh@inai.de> <20150715162442.GA22476@salvia> <alpine.LSU.2.20.1507151837110.15534@nerf40.vanv.qr> <20150715165515.GA4177@salvia>
 <alpine.LSU.2.20.1507151907560.1320@nerf40.vanv.qr> <20150715173035.GA5675@salvia> <alpine.LSU.2.20.1507151937160.528@nerf40.vanv.qr> <20150807110754.GA13279@salvia> <alpine.LSU.2.20.1508071321280.18255@nerf40.vanv.qr> <20150810120407.GA3291@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:37415 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbbHJMPq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Aug 2015 08:15:46 -0400
In-Reply-To: <20150810120407.GA3291@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2015-08-10 14:04, Pablo Neira Ayuso wrote:
>> I oppose that idempotent expressions in rules, implicit or explicit,
>> shall lead to output when the ruleset is read back. A rule like
>>=20
>> 	-A INPUT -m policy --dir in
>>=20
>> should not, by default, cause `iptables -S` to output a
>> rule with terms essentially irrelevant to the human reader.
>>=20
>> 	-A INPUT -m policy --dir in --reqid 0:4294967295 [...]
>
>The point is that this has been broken for two years, chances that
>users have fixed this in the ruleset without reporting is high, so
>restoring the old behaviour may break things again for them.

Users that went that route have nothing to worry. If their input
ruleset explicitly specified some --reqid x:y, then they will get the
desired x=C2=A0<=3D=C2=A0reqid=C2=A0<=3D=C2=A0y test no matter the ipta=
bles version.


>That's why I'm insisting on the fact that switching to a less obscure
>behaviour is a good idea in the very specific case of 'ah' since they
>can easily detect that things have change by diffing the new and old
>iptables-save output.

Mind you, diffing is exactly how this bug _was_ discovered. A modified=20
print/save function would have done _nothing_ to prevent the bug.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
