From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Updated geoip patchlet for Xtables 1.5.2 / 2.6.18--2.6.25 (was:
 iptables 1.4.0 / 2.6.24.3)
Date: Sun, 16 Mar 2008 06:48:34 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803160627320.14822@fbirervta.pbzchgretzou.qr>
References: <1205410278.16631.0.camel@localhost>
 <Pine.LNX.4.64.0803131351230.14822@fbirervta.pbzchgretzou.qr>
 <ae6a86ba0803130601o3bd10021o69effed74c6cc86c@mail.gmail.com>
 <Pine.LNX.4.64.0803131410170.14822@fbirervta.pbzchgretzou.qr>
 <ae6a86ba0803130643j7b5a83b1ub6141f60e0e4739a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, acidfu@people.netfilter.org
To: Samuel Jean <peejix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38657 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751604AbYCPFsf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Mar 2008 01:48:35 -0400
In-Reply-To: <ae6a86ba0803130643j7b5a83b1ub6141f60e0e4739a@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mar 13 2008 09:43, Samuel Jean wrote:
>
>>  I can see that the
>>  code does need cleanup, so I'll do that and import it into
>>  xtables-addons for the time being.
>
>Looks great but updating the patch-o-matic's sources.list file
>with the proper URL and maintainer name will make people
>stop wasting precious time hacking geoip unless they are
>aware that geoip's been imported into xtables-addons.
>And by the way, keep up the good work.

Well well, it is just a recent idea that lived for 48h so far.
But I am done with it now with the prerelease, please give it
some testing!
    git://dev.computergmbh.de/xtables-addons : "geoip" branch
or as .tar:
    http://jengelh.hopto.org/files/geoip/
    (you need geoip_iv0 too - the geoip database).

There was a fair bit to do, changelog is http://tinyurl.com/2xbvpa
