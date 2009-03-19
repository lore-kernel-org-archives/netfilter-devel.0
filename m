From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 14:52:35 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903191447140.27642@fbirervta.pbzchgretzou.qr>
References: <49C202EA.40006@trash.net> <49C23FD6.6010503@netfilter.org> <49C240DA.2070006@trash.net> <49C2443F.9080208@netfilter.org> <49C245AF.50802@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47008 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937AbZCSNwh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:52:37 -0400
In-Reply-To: <49C245AF.50802@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-19 14:16, Patrick McHardy wrote:
>>
>> I planned to distribute the kernel module separately until 2.6.30
>> arrives, add a page to conntrack-tools.netfilter.org, document this =
in
>> the conntrack-tools manual [1] to describe the active-active setup, =
and
>> so on. Basically, my motivation is to get some feedback from people =
as
>> soon as possible without waiting the whole kernel cycle release.
>>
>> I know that this seems something exceptional and it may confuse peop=
le.
>> Another choice is to keep it in pom-ng in the meantime, or perhaps
>> simply be a little bit patient :).
>>
>> [1] http://conntrack-tools.netfilter.org/manual.html
>
> How about just adding it as first commit after the release? That way
> people can get the latest stable version, including support for the
> cluster match. Otherwise they'd have to patch in the the extension
> anyways.

I am all for including it now. Distributions are known to forget
updating iptables, so the earlier it gets included, the higher is the
chance distros pick it [a new iptables release] up. Users (or these
days, too, Debian) often upgrading their kernel yet not dare to
manually install anything outside the package manager's realm, that
is my impression. For example etchnhalf=C2=A0=E2=80=94 nice kernel, but=
 it is
hopeless with the iptables version to get the new goodies.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
