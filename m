From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: ctnetlink kernel dump while running multiple libnfct clients
Date: Mon, 28 Mar 2011 09:01:21 -0700
Message-ID: <AANLkTi=LNMqTMf34OnjP3rgp5hrw=bLgrdZneZ4cyffi@mail.gmail.com>
References: <AANLkTi=17VZ6Sjgj57LTa-xcJj00BSjv_-4DveiutNo1@mail.gmail.com>
	<4D908351.5010407@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:35729 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754207Ab1C1QBW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:01:22 -0400
Received: by vws1 with SMTP id 1so2394120vws.19
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2011 09:01:21 -0700 (PDT)
In-Reply-To: <4D908351.5010407@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 28, 2011 at 5:47 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On 25/03/11 01:21, Sam Roberts wrote:
>>
>> Screenshot attached.
>>
>> At the time I had 3 connections to nfnetlink open
>> - a userspace connection tracker
>
> what protocol are you tracking from user-space?

A dummy protocol for purposes of developing this prototype, I call it
"echo port broker".

It listens on port 9999 for control connections. An echo port is
requested by the client, and server opens an ephemeral listen port and
returns the number. The client then reconnects to that ephemeral port,
which acts as an echo server.

> AFAICS, the only way to hit this problem is to have some connection tracking
> helper in the kernel which overlaps your user-space helper, ie. someone is
> attaching a kernel helper to your conntrack.

That's quite surprising, I've no firewall rules attaching anything
else to port 9999. See a dump of my rule setup at end of mail. Note it
assumes localhost client connects to localhost server.

> Need more info to know what's going on.

What info would you like me to provide?

Thanks,
Sam


cmd=<iptables -L -n>
Chain INPUT (policy ACCEPT)
target     prot opt source               destination

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
cmd=<iptables -t filter -P INPUT DROP>
cmd=<iptables -t filter -A OUTPUT -p tcp --sport 9999 -j QUEUE>
cmd=<iptables -t filter -A INPUT -p tcp -m state --state
RELATED,ESTABLISHED -j ACCEPT>
cmd=<iptables -t filter -A OUTPUT -p tcp -m state --state
NEW,RELATED,ESTABLISHED -j ACCEPT>
cmd=<iptables -t filter -A INPUT -p tcp --dport 9999 -m state --state
NEW -j ACCEPT>
cmd=<iptables -L -n>
Chain INPUT (policy DROP)
target     prot opt source               destination
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state
RELATED,ESTABLISHED
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           tcp
dpt:9999 state NEW

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination
QUEUE      tcp  --  0.0.0.0/0            0.0.0.0/0           tcp spt:9999
ACCEPT     tcp  --  0.0.0.0/0            0.0.0.0/0           state
NEW,RELATED,ESTABLISHED
