From: Mike Acar <mikeacar@gmail.com>
Subject: Re: DROP still returns -EPERM to userspace in OUTPUT chain
Date: Sat, 6 Jun 2009 21:22:41 -0700
Message-ID: <4664d77a0906062122w7ec23b73p9a322b02b5fb3744@mail.gmail.com>
References: <alpine.LSU.2.00.0905211707050.23519@fbirervta.pbzchgretzou.qr>
	 <4A17D45C.6040909@netfilter.org>
	 <alpine.LSU.2.00.0905231309250.361@fbirervta.pbzchgretzou.qr>
	 <4A17E14B.5040701@netfilter.org>
	 <alpine.LSU.2.00.0905231517400.4949@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.251]:65350 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbZFGEWk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 7 Jun 2009 00:22:40 -0400
Received: by an-out-0708.google.com with SMTP id d40so4410050and.1
        for <netfilter-devel@vger.kernel.org>; Sat, 06 Jun 2009 21:22:41 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.00.0905231517400.4949@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'd like to re-open this discussion. I apologize for not responding
sooner; I've been a bit busy. I'm also not subscribed to
netfilter-devel, so this message may bounce from there.

On Sat, May 23, 2009 at 6:20 AM, Jan Engelhardt<jengelh@medozas.de> wrote:

> Then again, people might be using -m limit -j DROP to simulate actual
> packet loss, for whatever scientific interests they currently have.

Which is precisely what happened: I was using DROP to simulate packet
loss to test timeout handling in a program. The program in question
does handle errors, but that wasn't the code path I wanted to
exercise. I wasn't aware of netem, but DROP would be all I needed in
this case (if it didn't return -EPERM).

In my former life as a sysadmin, it never occurred to me to interpret
DROP as "administratively prohibited"; that is what REJECT is for. I
interpreted DROP as "drop the packet silently, without any response",
which I think is the intuitive interpretation. An ICMP reply to a
remote machine is a response, and changing the return value of a
system call is also a response; neither is desirable.

The current behavior produces different results on local and remote
machines - programs on the remote machine time out, while programs on
the local machine get an error. I think this inconsistency - or
asymmetry - is undesirable.

What happens when adding an INPUT DROP rule for a protocol and port
bound for a socket where a daemon is listening? If we apply this
interpretation consistently, then when the rule is added, those
listen() calls should be interrupted and return -EPERM. I don't think
that's desirable behavior either - I think the kernel should drop the
packets when they arrive, and the listening daemon should never know
it happened.

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Reporting -EPERM seems to me a good practise to report user-space
> applications that the kernel is explicit dropping the packet. Otherwise,
> while diagnosing problems, people cannot be sure where the packet has
> been lost.

I don't agree. In fact, the current behavior makes this worse, because
the -EPERM behavior is unexpected (I think the interpretation of DROP
as silent is very common) and inconsistent (different things happen if
you're dropping remotely versus locally) - so it's not like you can
forget that you must check both end's firewalling rules when you're
diagnosing a problem.

-- Mike Acar
