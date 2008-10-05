From: Christoph Paasch <christoph.paasch@gmail.com>
Subject: Re: Connection Protocol in the state?
Date: Sun, 5 Oct 2008 10:51:19 +0200
Message-ID: <200810051051.19999.christoph.paasch@gmail.com>
References: <200810012206.52512.christoph.paasch@gmail.com> <alpine.LNX.1.10.0810031004350.3893@fbirervta.pbzchgretzou.qr>
Reply-To: Christoph Paasch <christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:46986 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYJEIvb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 04:51:31 -0400
Received: by ey-out-2122.google.com with SMTP id 6so712130eyi.37
        for <netfilter-devel@vger.kernel.org>; Sun, 05 Oct 2008 01:51:29 -0700 (PDT)
In-Reply-To: <alpine.LNX.1.10.0810031004350.3893@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

>
> Read the really-really-really-nice manpage (which has gotten so much care
> from me). I mean, hey, it's directly below --ctstate! :-)
>
>        [!] --ctproto l4proto
>               Layer-4 protocol to match (by number or name)

Hmm... so, you mean that the established connection doesn't makes the 
difference between the different protocols, as long as those aren't specified 
with "--ctproto".

So, if I got an established TCP-connection, I can do run any other protocol 
(UDP, ... and in particular shim6 ;-) in any direction. And also on any port 
number? 

Sorry, but I think, that it's not clear, what is stored in the state, of a 
connection, if the iptables rule doesn't specifies the protocol, portnumber, 
...

Thanks for answering, and have a nice day...

Christoph Paasch
