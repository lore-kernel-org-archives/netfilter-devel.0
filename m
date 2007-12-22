From: Patrick McHardy <kaber@trash.net>
Subject: Re: Possible bug ipsec and SNAT?
Date: Sat, 22 Dec 2007 08:37:54 +0100
Message-ID: <476CBED2.8050808@trash.net>
References: <476903B4.8060303@wlz.nl> <47692E3D.7090008@trash.net> <476A494C.1050606@wlz.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: "Slagter, EM" <eslagter@wlz.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33407 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885AbXLVHiN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 22 Dec 2007 02:38:13 -0500
In-Reply-To: <476A494C.1050606@wlz.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Slagter, EM wrote:
> Patrick McHardy wrote:
> 
>> This is expected behaviour. Before NAT takes place, the packet
>> doesn't match a policy, it only does after getting mangled by
>> NAT, but at that point it already passed through your policy
>> matches.
> 
> I think we're not talking about the same thing :-/
> 
> I have a rule in the filter table like this:
> 
> iptables -t filter -A FORWARD -i ... -o ... -s ... -d ... -m policy
> --mode tunnel --pol ipsec --dir out --tunnnel-src ... --tunnel-dst ...
> -j ACCEPT
> 
> This rule works as expected, it matches certain ipsec traffic as intended.
> 
> As soon as I add a rule like this to the nat table:
> 
> iptables -t nat -A POSTROUTING -s ... -d ... -j SNAT --to-source ...
> 
> then the OTHER rule (above, the one in the filter table) doesn't match
> anymore. This has nothing to do with the source address having changed
> because even in this "bare" form:
> 
> iptables -t filter -A FORWARD -i ... -o ... -m policy --pol ipsec --dir out
> 
> it doesn't match.
> 
> This one does match (changed --pol ipsec into --pol none):
> 
> iptables -t filter -A FORWARD -i ... -o ... -m policy --pol none --dir out
> 
> Yet the traffic IS being encapsulated like before I applied the SNAT rule.
> 
> That doesn't seem right to me.


Does this rule apply in the direction you do SNAT or to reply packets?
Please post the rules including IP addresses.
