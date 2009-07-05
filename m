From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: arptables ruleset not working when compiling on  fedora6,7,8/centos
 5/redhat 5
Date: Sun, 5 Jul 2009 17:59:46 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907051758550.22722@fbirervta.pbzchgretzou.qr>
References: <b2d58cb80906290712k33c1ebbvfc8e661cb34c502c@mail.gmail.com>  <56378e320906290721i63f969edm90aed19619decf71@mail.gmail.com>  <b2d58cb80906290751j7fb3976bx9d04fed852c8b451@mail.gmail.com>  <4A48D6AD.4010005@trash.net>
 <b2d58cb80906290818t66616f70k2fe7596b906a8a4e@mail.gmail.com>  <4A48E14A.3060708@trash.net>  <b2d58cb80906290918q2da5af1ap87772755b3363032@mail.gmail.com> <b2d58cb80906300108q2ee5a060gf8013a88560d8820@mail.gmail.com> <4A4B32C4.8050800@trash.net>
 <4A50A3BA.8060905@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Nishit Shah <nsshah.82@gmail.com>,
	Richard Horton <arimus.uk@googlemail.com>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60155 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084AbZGEP7p (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Jul 2009 11:59:45 -0400
In-Reply-To: <4A50A3BA.8060905@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-07-05 14:59, Bart De Schuymer wrote:
>>>>-       /usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_REPEAT
>>>>+       /usr/include/linux/netfilter.h:#define NF_MAX_VERDICT NF_STOP
>>
> Nishit, please try the attached file. It uses more recent kernel headers that
> use x_tables. I prefer that approach...

You need to use the unifdef'ed headers or funny things like
compiler complaining about __user might pop up.
