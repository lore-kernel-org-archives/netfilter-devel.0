From: "Hans Schillstrom" <hans@schillstrom.com>
Subject: Re[2]:  [RFC] netfilter: xt_TEE: IPv4 Don't Fragmet options
Date: Thu, 14 Jun 2012 21:50:57 +0200 (CEST)
Message-ID: <8oegugq.e343308a83567a5279c6a2f60d68ffa1@obelix.schillstrom.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "Jan Engelhardt" <jengelh@medozas.de>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-gw21.han.skanova.net ([81.236.55.21]:45420 "EHLO
	smtp-gw21.han.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755409Ab2FNTvA convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Jun 2012 15:51:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

>
>On Thu, Jun 14, 2012 at 07:52:23PM +0200, Pablo Neira Ayuso wrote:
>> On Thu, Jun 14, 2012 at 08:17:35AM +0200, Hans Schillstrom wrote:
>> > Hello,
>> > 
>> > I  think it is wrong to always force the DF bit in IPv4, it's better
>> > to have an option If an application don't set the DF bit, usually it
>> > doesn't expect to get an icmp back either.  The result is that the
>> > packet will be dropped...
>
>I don't understand what effect you're observing to propose this
>change. Could you clarify this?

Ex. syslog do not use DF it relies on L3 fragmentation handling.
So when sending big syslog datagrams to the "copy" with  DF bit set
the receiver will drop the packets and send back an ICMP "packet to big"
which is not handled by syslog...

/Hans





