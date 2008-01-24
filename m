From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in clamp-to-pmtu
Date: Thu, 24 Jan 2008 10:57:01 +0200
Message-ID: <479852DD.9000304@uls.co.za>
References: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr> <4797BFE3.6090603@trash.net> <Pine.LNX.4.64.0801232341160.12676@fbirervta.pbzchgretzou.qr> <47980A57.2020702@uls.co.za> <47984409.9020204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp02.isdsl.net ([196.26.208.200]:60185 "EHLO smtp02.isdsl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752869AbYAXI5K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 03:57:10 -0500
In-Reply-To: <47984409.9020204@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> Jaco Kroon wrote:
>> Jan Engelhardt wrote:

[[ -- snip -- ]

>>>> use routing rules based on source address, iif etc., so I
>>>> think we should make this optional.
>>>>     
>>> iif yes; should be a matter of in->ifindex or so.
>>>   
>> I'd reckon that's a definite "yes, we should fill in iif and saddr"! 
> 
> 
> saddr and iif don't work without more complicated changes since
> we'd have to use input routing.

Oh well.  For my needs the original simpler patch to simply look at the 
mtu of the in net_device is good enough.  So as far as I'm concerned 
this is "nice to have for the day I need to do IPSec with some 
disfunctional router" or "some really funky asymmetric routing".

>> This should cover 99.99% of cases where this is useful, and the only
>> potentially problematic case I can envision is with asymmetric routing
>> between the gateway this is running on and the final destination.  And
>> chances are that even in those cases the oif of two different incoming
>> routes are going to be the same.
> 
> The problem is that we can't determine all keys used in the
> reverse direction, which becomes obvious if you think of
> mark based routing. So I'm wondering how many setups this
> would break. Leaving the routing as it is and making it
> optional looks safer, with the downside that most users
> probably want this and won't notice the new option.

Or keep to the original "simply look at the mtu of the in net_device as 
provided".  Which is a major improvement and should cover the vast 
majority of cases.  Just make it clear in the man page exactly what 
--clamp-mss-to-pmtu does do, and possibly add a "--clamp-to-mtu 
mtu_value" or "--clamp-to-mss mss_value" option (I'd prefer 
--clamp-to-mtu), which works like --set, but only if the new mss value 
is less than the existing one.  I prefer the mtu version simply because 
it doesn't require me to know how much space needs to be reserved for 
ip/tcp headers.

It's possible to do the path routing stuff with somewhat complicated 
iptables chains, as an example, originally I thought to do this for my 
case (the one described in the need case):

iptables -A FORWARD -i ppp+ -p tcp --tcp-flags SYN,FIN,RST SYN -j CLAMP_MSS
iptables -A FOWARD -p tcp --tcp-flags SYN,FIN,RST SYN -j TCPMSS 
--clamp-mss-to-pmtu

iptables -A CLAMP_MSS -i ppp0 -p tcp --tcp-flags SYN,FIN,RST SYN -j 
TCPMSS --set-mss $(( $mtu_of_ppp0 - 40 ))
iptables -A CLAMP_MSS -i ppp1 -p tcp --tcp-flags SYN,FIN,RST SYN -j 
TCPMSS --set-mss $(( $mtu_of_ppp1 - 40 ))
etc ...

More complex situations can also do this, and people actually setting up 
those kind of setups should be (made) aware of this.

*sigh* if there just wasn't so many flippen firewalls blocking icmp 
fragmentation required packets, and if these packets were handled 
correctly ...

Jaco
