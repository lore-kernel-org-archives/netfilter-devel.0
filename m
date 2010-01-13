From: Bernd Eckenfels <be-mail2010@lina.inka.de>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Wed, 13 Jan 2010 12:04:25 +0100
Message-ID: <20100113110425.GA5095@lina.inka.de>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com> <20100112194955.GA11752@mock.linuxdev.us.dell.com> <alpine.LSU.2.01.1001130039020.4567@obet.zrqbmnf.qr> <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com>
Reply-To: net-tools@lina.inka.de
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: jengelh@medozas.de, shemminger@linux-foundation.org,
	net-tools@lina.inka.de, netfilter-devel@vger.kernel.org,
	jgarzik@users.sourceforge.net, Charles_Rose@Dell.com,
	Matt_Domsch@Dell.com, Shyam_Iyer@Dell.com,
	Jordan_Hargrave@Dell.com, Sandeep_K_Shandilya@Dell.com
To: Narendra_K@Dell.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from quechua.inka.de ([193.197.184.2]:36867 "EHLO mail.inka.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab0AMLEa (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 06:04:30 -0500
Content-Disposition: inline
In-Reply-To: <EDA0A4495861324DA2618B4C45DCB3EE5899B5@blrx3m08.blr.amer.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Wed, Jan 13, 2010 at 12:17:16PM +0530, Narendra_K@Dell.com wrote:
> The implementation is for char device node solution we proposed earli=
er.
> It would be extended to handle the current proposal if it is acceptab=
le.

=46or the record: I still dont like the idea to add another namespace (=
besides
interface index number and kernel names (possibly renamed)) to network
devices (especially in usermode), however if nobody else objects I will=
 keep
quiet and accept the patches.

One thing for the library: the smbname of the devices can be the defaul=
t
alias, but please allow usermode to configure patterns (based on driver=
,
mac) or maps for using even better interface names. The quality of syst=
em
management informations, especially when mixing hardware, tends to be l=
ess
than optimal.

Gruss
Bernd
--=20
  (OO)     -- Bernd_Eckenfels@M=F6rscher_Strasse_8.76185Karlsruhe.de --
 ( .. )    ecki@{inka.de,linux.de,debian.org}  http://www.eckes.org/
  o--o   1024D/E383CD7E  eckes@IRCNet  v:+497211603874  f:+497211515161=
29
(O____O)  When cryptography is outlawed, bayl bhgynjf jvyy unir cevinpl=
!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
