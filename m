From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ctnetlink kernel dump while running multiple libnfct clients
Date: Tue, 29 Mar 2011 12:12:19 +0200
Message-ID: <4D91B083.2000001@netfilter.org>
References: <AANLkTi=17VZ6Sjgj57LTa-xcJj00BSjv_-4DveiutNo1@mail.gmail.com>	<4D908351.5010407@netfilter.org> <AANLkTi=LNMqTMf34OnjP3rgp5hrw=bLgrdZneZ4cyffi@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Sam Roberts <vieuxtech@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33024 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab1C2KM0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2011 06:12:26 -0400
In-Reply-To: <AANLkTi=LNMqTMf34OnjP3rgp5hrw=bLgrdZneZ4cyffi@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 28/03/11 18:01, Sam Roberts wrote:
> On Mon, Mar 28, 2011 at 5:47 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On 25/03/11 01:21, Sam Roberts wrote:
>>>
>>> Screenshot attached.
>>>
>>> At the time I had 3 connections to nfnetlink open
>>> - a userspace connection tracker
>>
>> what protocol are you tracking from user-space?
> 
> A dummy protocol for purposes of developing this prototype, I call it
> "echo port broker".
> 
> It listens on port 9999 for control connections. An echo port is
> requested by the client, and server opens an ephemeral listen port and
> returns the number. The client then reconnects to that ephemeral port,
> which acts as an echo server.
> 
>> AFAICS, the only way to hit this problem is to have some connection tracking
>> helper in the kernel which overlaps your user-space helper, ie. someone is
>> attaching a kernel helper to your conntrack.
> 
> That's quite surprising, I've no firewall rules attaching anything
> else to port 9999. See a dump of my rule setup at end of mail. Note it
> assumes localhost client connects to localhost server.

Please, send me the code so I can reproduce the problem here.
