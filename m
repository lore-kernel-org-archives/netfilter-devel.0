From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Connection Protocol in the state?
Date: Fri, 3 Oct 2008 10:05:26 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0810031004350.3893@fbirervta.pbzchgretzou.qr>
References: <200810012206.52512.christoph.paasch@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Christoph Paasch <christoph.paasch@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42401 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbYJCOF1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Oct 2008 10:05:27 -0400
In-Reply-To: <200810012206.52512.christoph.paasch@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-10-01 16:06, Christoph Paasch wrote:
>
>I would like to know, that if I have a filter like the one shown below 
>(allowing outgoing connections of every protocol-type), does netfilter stores 
>in the state of the established outgoing connection also the protocol which 
>established the connection? (TCP, UDP, ....) Or does it opens the connection 
>for any protocol?
>
>iptables -A FORWARD -i eth0 --ctstate NEW, RELATED, ESTABLISHED -j ACCEPT

Read the really-really-really-nice manpage (which has gotten so much care
from me). I mean, hey, it's directly below --ctstate! :-)

       [!] --ctproto l4proto
              Layer-4 protocol to match (by number or name)
