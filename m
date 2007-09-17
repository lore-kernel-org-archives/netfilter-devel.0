From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter List cross-subscription [Re: Test]
Date: Mon, 17 Sep 2007 16:08:53 +0200
Message-ID: <46EE8A75.4030609@trash.net>
References: <46EE6679.3000103@trash.net> <46EE6956.10608@trash.net>
	<46EE840D.20209@microbus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Core Team <coreteam@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@vger.kernel.org>
To: Robbie Dinn <robbie@microbus.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Received: from stinky.trash.net ([213.144.137.162]:41668 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbXIQOPF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Sep 2007 10:15:05 -0400
In-Reply-To: <46EE840D.20209@microbus.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <http://lists.netfilter.org/pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Robbie Dinn wrote:
> /Lurk mode off/
> Replying off list because this might be stupid/irrelevant/off topic.


It was on-list but I prefer to keep the discussion open anyways :)

> Patrick McHardy wrote:
> 
>>The cross-subscription appears to work, unfortunately (due to the
>>subscriber-only posting settings of the old list) senders to the
>>new lists that are not subscribed to the old one will receive a
>>"held for moderator approval" mail for each post. Since this is
>>probably quite annoying for everyone, I'm not sure whether we
>>should really do the cross-subscription thing.
>>
>>Any better ideas or suggestions?
> 
> 
> You could bounce messages sent to netfilter-devel@lists.netfilter.org
> If the bounce message contained a
> "mailing list has moved to netfilter-devel@lists.netfilter.org" message,
> then assuming that people bother to read their bounces or don't routinely
> discard them, then they would eventually get to send the message to the
> right list.
> 
> Postfix has a relocated table for these "user has moved  to new_location"
> messages. But you are using exim. I am not familiar with exim but perhaps
> it has something similar?


I don't know, but something like that should work. I think its not
too much asked of people to resubscribe, so my suggestion is to
simply disable the netfilter.org lists, generate a bounce message
and have people resubscribe. The amount of dead subscriptions seems
to be very high anyways, after only 10 hours of forwarding bounce
messages to my address I got around 6000 emails.

If there are no (reasonable) objections I'll try to reconfigure
mailman to do this tonight.

