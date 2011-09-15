From: "Israel G. Lugo" <israel.lugo@lugosys.com>
Subject: Re: conntrack: ICMP type 3 code 3 responses should break TCP connections
Date: Thu, 15 Sep 2011 23:09:07 +0100
Message-ID: <4E727783.8090904@lugosys.com>
References: <4E6E67FA.2040800@lugosys.com> <alpine.DEB.2.00.1109131327230.502@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lugosys.com ([85.214.120.94]:42126 "EHLO mail.lugosys.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935198Ab1IOWJS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Sep 2011 18:09:18 -0400
In-Reply-To: <alpine.DEB.2.00.1109131327230.502@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On 09/13/2011 12:49 PM, Jozsef Kadlecsik wrote:
> Yes, at present ICMP(v6) error codes does not terminate TCP connections in 
> conntrack. The problem with acting at receiving ICMP error codes is that 
> it's easier to fake an ICMP error packet than a TCP RST one, because the 
> latter must be acceptable according to the receiver's window too.
>

I hadn't thought of that; you are correct of course. It might be a bad
idea to enable this for all cases, out of the box. Still, it think it
would be good for the option to be available. It could be disabled by
default, as you suggested, with a new switch --match state
--honor-icmp-errors or something.

I believe this would also make sense for UDP state tracking (perhaps
even more so than for TCP, since UDP has no receive window). I don't
have the data in front of me now, but I'm pretty sure I saw UDP sessions
in UNREPLIED state on my router, although the host had replied with an
ICMP type 3, code 3. Of course, the UDP timer is usually quite short,
but it wouldn't hurt to have the _option_ to honor ICMP errors, as
stated above.

Best regards,
Israel G. Lugo
