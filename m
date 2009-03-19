From: Patrick McHardy <kaber@trash.net>
Subject: Re: next iptables release
Date: Thu, 19 Mar 2009 14:56:24 +0100
Message-ID: <49C24F08.3040208@trash.net>
References: <49C202EA.40006@trash.net> <49C23FD6.6010503@netfilter.org> <49C240DA.2070006@trash.net> <49C2443F.9080208@netfilter.org> <49C245AF.50802@trash.net> <alpine.LSU.2.00.0903191447140.27642@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35935 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZCSN4e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Mar 2009 09:56:34 -0400
In-Reply-To: <alpine.LSU.2.00.0903191447140.27642@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
>
>> How about just adding it as first commit after the release? That way
>> people can get the latest stable version, including support for the
>> cluster match. Otherwise they'd have to patch in the the extension
>> anyways.
>>    =20
>
> I am all for including it now. Distributions are known to forget
> updating iptables, so the earlier it gets included, the higher is the
> chance distros pick it [a new iptables release] up. Users (or these
> days, too, Debian) often upgrading their kernel yet not dare to
> manually install anything outside the package manager's realm, that
> is my impression. For example etchnhalf =E2=80=94 nice kernel, but it=
 is
> hopeless with the iptables version to get the new goodies.
>  =20

Sorry, no way. I'm not going back to the random-crap model.

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
