From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Updated geoip patchlet for iptables 1.4.0 / 2.6.24.3
Date: Thu, 13 Mar 2008 14:31:19 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803131410170.14822@fbirervta.pbzchgretzou.qr>
References: <1205410278.16631.0.camel@localhost>
 <Pine.LNX.4.64.0803131351230.14822@fbirervta.pbzchgretzou.qr>
 <ae6a86ba0803130601o3bd10021o69effed74c6cc86c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, acidfu@people.netfilter.org
To: Samuel Jean <peejix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:33355 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358AbYCMNbU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2008 09:31:20 -0400
In-Reply-To: <ae6a86ba0803130601o3bd10021o69effed74c6cc86c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 13 2008 09:01, Samuel Jean wrote:
>Jan --
>
>On Thu, Mar 13, 2008 at 8:52 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>>  Nicolas has an all-around updated geoip at
>>  http://people.netfilter.org/acidfu/patchlets/ .
>>  Better check back first :)
>
>Would you mind to send a patch to Patrick about this ?

I am not sure whether this would go into mainline kernel.
  As I seem to recall, Nicolas still wanted to work on geoip,
but he was last seen in India with little time. I can see that the 
code does need cleanup, so I'll do that and import it into 
xtables-addons for the time being.
