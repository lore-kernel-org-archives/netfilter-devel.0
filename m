From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: NFQUEUE target with --treat-accept-as-continue?
Date: Tue, 3 Apr 2012 14:25:34 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1204031424550.15235@frira.zrqbmnf.qr>
References: <1333202982.55963.YahooMailNeo@web193402.mail.sg3.yahoo.com> <20120401175159.GA11401@1984> <1333336294.99244.YahooMailNeo@web193406.mail.sg3.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Amm Snort <ammdispose-snort@yahoo.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:45232 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656Ab2DCMZf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Apr 2012 08:25:35 -0400
In-Reply-To: <1333336294.99244.YahooMailNeo@web193406.mail.sg3.yahoo.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2012-04-02 05:11, Amm Snort wrote:
>
>>From man page: (for NFLOG)
>
>=C2=A0=C2=A0=C2=A0 Like LOG, this is=C2=A0 a=C2=A0 non-terminating=C2=A0=
 target, i.e. rule
>traversal continues at the next rule.

Traversal continues after a copy of the packet has been queued
for userspace. It does not mean traversal continues after
userspace has rendered a verdict.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
