From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PROPOSAL]: Alias names for network interfaces
Date: Thu, 14 Jan 2010 09:41:48 +0100
Message-ID: <4B4ED8CC.5000207@trash.net>
References: <EDA0A4495861324DA2618B4C45DCB3EE5899AC@blrx3m08.blr.amer.dell.com><20100112194955.GA11752@mock.linuxdev.us.dell.com><4B4DC997.20306@trash.net><alpine.LSU.2.01.1001131439330.31436@obet.zrqbmnf.qr> <20100113082711.2dee7415@nehalam> <EDA0A4495861324DA2618B4C45DCB3EE5899C5@blrx3m08.blr.amer.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: shemminger@linux-foundation.org, jengelh@medozas.de,
	be-mail2009@lina.inka.de, net-tools@lina.inka.de,
	netfilter-devel@vger.kernel.org, jgarzik@users.sourceforge.net,
	Charles_Rose@Dell.com, Matt_Domsch@Dell.com, Shyam_Iyer@Dell.com,
	Jordan_Hargrave@Dell.com, Sandeep_K_Shandilya@Dell.com
To: Narendra_K@Dell.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60400 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab0ANIlv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jan 2010 03:41:51 -0500
In-Reply-To: <EDA0A4495861324DA2618B4C45DCB3EE5899C5@blrx3m08.blr.amer.dell.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Narendra_K@Dell.com wrote:
> Patrick,
> 
> If I understand your point correctly, you are saying that if a rule is
> specified in the command line as below
> 
> iptables -A INPUT -i Embedded_NIC_1 -j ACCEPT, then if the rule is saved
> by iptables-save the rule would look like 
> 
> iptables -A INPUT -i ethN -j ACCEPT and there is no way to know what the
> corresponding Embedded_NIC_1 name is. 
> 
> If this is correct, then I agree. I suppose that this concern can be
> addressed in one of these ways, if I am not missing
> something - 
> 
> a) The command line tool I mentioned above (point 2)would tell us the
> ethN -> Embedded_NIC_N mapping
> b) Or the iptables-save needs to be enhanced to save Embedded_NIC_N
> format instead of ethN by making a call to
> libnetdevname to get that mapping ( ethN -> Embedded_NIC_1).

Yeah, that could be done (but optionally please). What you can't
do however is display these two rules

iptables ... -i eth0 ...
iptables ... -i Embedded_NIC_N ...

the same way they were entered since you either map back or you don't.
I guess we can live with that though ...
