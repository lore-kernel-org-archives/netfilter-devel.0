From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 14:49:15 +0200
Message-ID: <471F3F4B.80205@trash.net>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net> <471F00DC.9070001@snapgear.com> <471F03B1.3090909@trash.net> <471F0AD5.2050202@snapgear.com> <471F136D.6090907@trash.net> <20071024120622.GB27593@volker-sauer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Volker Sauer <volker@volker-sauer.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20071024120622.GB27593@volker-sauer.de>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Volker Sauer wrote:
> 99% of my rules on all my firewalls are like that:
> 
> $IPTABLES -A FORWARD -i $BR_INT -m physdev --physdev-in $IF_INT
> --physdev-out $IF_DMZ -s $ZAPHOD -j ACCEPT
> 
> IF_INT (eth1) and IF_DMZ (vlan3) are both members of BR_INT (br-intern):
> 
> fw1: ~ # brctl show
> br-intern               8000.000d88cd28c1       yes     eth1
>                                                         vlan3
> 
> This means, that all rules like that are valid even with the new concept
> of netfilter, right?? But why do I get error messages like quoted in my
> first mail for these rules - it *is* bridged traffic inside *one*
> bridge!
> And: I don't see how --physdev-is-bridged should help, since it's a
> match and not a command to the kernel saying: "this *is* bridged
> traffic". It the kernel does not see this by itself,
> --physdev-is-bridged doesn't help.


Whether you believe it or not, this is the only way to tell
the physdev match that the rule only affects purely bridged
traffic.

> If my arguments are correct, I suggest the following improvement:
> 
> In case someone is using physdev in OUTPUT, display the message like it
> is now: "using --physdev-out in the OUTPUT chains for non-bridged traffic
> is not supported anymore".
> 
> In case it is used inside FORWARD, check if all physdev interfaces are
> members of the same bridge. If yes, accept the rule, because then it is
> allowed to use it!!!  (Which is the case all the thousands of rules in
> my firewalls except the 5 that I sent to this list :-().


Does not work since one of the devices might be put in a different
bridge after you loaded the rules.

> If no, display a message like this:
> 
> "physdev match: using --physdev-out in the FORWARD chains is only 
> allowed if all physical interfaces are members of the same bridge."


Feel free to send a patch to improve the error messages.
