From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: user-space xtables ABI [was Re: [Fwd: Re: iptables pull
 request]]
Date: Sun, 17 May 2009 19:11:45 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0905171907060.12523@fbirervta.pbzchgretzou.qr>
References: <4A0E9786.8060407@netfilter.org>  <1242566196.3996.23.camel@dogo.mojatatu.com>  <4A10235B.3070607@netfilter.org>  <alpine.LSU.2.00.0905171711230.6819@fbirervta.pbzchgretzou.qr>  <4A103751.9060501@netfilter.org>  <alpine.LSU.2.00.0905171822570.6819@fbirervta.pbzchgretzou.qr>
 <1242579553.3996.81.camel@dogo.mojatatu.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: jamal <hadi@cyberus.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35311 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488AbZEQRLp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 May 2009 13:11:45 -0400
In-Reply-To: <1242579553.3996.81.camel@dogo.mojatatu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-05-17 18:59, jamal wrote:
>On Sun, 2009-05-17 at 18:39 +0200, Jan Engelhardt wrote:
>
>> Compatibility is the ultimate killer argument against about anything. 
>
>Once you have user of an API, that arguement becomes hard to defend.
>It is certainly a lesson learnt on the development of the
>internet: You cant just replace IPV4, TCP, NAT and a lot of other
>protocols and practises that people are using. You can incrementally
>"fix them". You can the parallel provide the new way (IPv6).

The hurdle with IPv6 is just like patches that would add a copy of a
function with a slightly different signature or semantics: it would
be met with reluctance. I already given up on submission of
Xtables-addons modules to upstream for the same reason because there
are so much "no no"s coming back. I don't get it.
