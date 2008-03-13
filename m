From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Updated geoip patchlet for iptables 1.4.0 / 2.6.24.3
Date: Thu, 13 Mar 2008 22:12:06 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803132150210.14822@fbirervta.pbzchgretzou.qr>
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
Received: from sovereign.computergmbh.de ([85.214.69.204]:52084 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752690AbYCMVMI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Mar 2008 17:12:08 -0400
In-Reply-To: <ae6a86ba0803130643j7b5a83b1ub6141f60e0e4739a@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Mar 13 2008 09:43, Samuel Jean wrote:
>On Thu, Mar 13, 2008 at 9:31 AM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>>
>>  On Mar 13 2008 09:01, Samuel Jean wrote:
>>  >Would you mind to send a patch to Patrick about this ?
>>
>>  I am not sure whether this would go into mainline kernel.
>
>Uhm.. I don't think it will ever go into mainline, geoip is
>fully dependant on 3rd parties databases.

Is the db redistributable; what does the license say?

BTW, geoip.c is coded like checkentry() could be called twice
without a destroy in between -- how is this possible anyway?

        /* 
         * If info->refcount is not NULL, then it means that checkentry() 
         * already initialized this entry. Increase a refcount to prevent 
         * destroy() of this entry. 
         */
