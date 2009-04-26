From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Wrong MAC in redirected packet
Date: Sun, 26 Apr 2009 23:29:50 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904262328470.16867@fbirervta.pbzchgretzou.qr>
References: <17e3a8f80903250727q739fac53r6325a8eefff96a97@mail.gmail.com>  <49CA8A6B.1020603@gmail.com>  <alpine.LSU.2.00.0903252047020.28681@fbirervta.pbzchgretzou.qr>  <49CA8C5A.1030908@gmail.com>  <alpine.LSU.2.00.0903252057190.29156@fbirervta.pbzchgretzou.qr>
  <49CA9B8B.7080605@gmail.com>  <17e3a8f80903260326i636c7c0byaf4d9b0b8e77c514@mail.gmail.com>  <alpine.LSU.2.00.0903262106140.15111@fbirervta.pbzchgretzou.qr>  <49CBEB9E.7080902@gmail.com>  <alpine.LSU.2.00.0904261143001.28183@fbirervta.pbzchgretzou.qr>
 <17e3a8f80904260922v6525aac3hbcb2398ce514446d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60426 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750AbZDZV3z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Apr 2009 17:29:55 -0400
In-Reply-To: <17e3a8f80904260922v6525aac3hbcb2398ce514446d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2009-04-26 18:22, Kristian Evensen wrote:
>>
>> I am just rethinking this. There are cases where we do not want MAC punning.
>> (E.g. when a packet still needs to be routed through another gateway
>> instead of being delivered directly to the final ethernet segment.)
>>
>> Is --to-mac aa:bb:cc:dd:ee:ff sufficient, or did you want --to-mac IPaddr?
>
>The last one would be the easiest to use and would therefore be
>desirable. However, forcing the user to write the full MAC-address
>might limit scenarios where it is used wrongly.

You know what, I am just pushing rawnat out now (merged into master
as of today), and everything else is "patches please" :-)

It does work for modifying packets-in-transit as a start. Have not
tested local address manipulation tho.
