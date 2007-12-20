From: "Slagter, EM" <eslagter@wlz.nl>
Subject: Re: Possible bug ipsec and SNAT?
Date: Thu, 20 Dec 2007 11:51:56 +0100
Message-ID: <476A494C.1050606@wlz.nl>
References: <476903B4.8060303@wlz.nl> <47692E3D.7090008@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <47692E3D.7090008@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

>> As soon as I add SNAT to traffic originating from this vlan (as required
>> by our supplier), the rules that (properly) used to match on "-m policy
>> --pol ipsec --dir out --tunnel-src ... --tunnel-dst ..." no longer
>> match. Even if I remove the tunnel-src and --tunnel-dst the rule no
>> longer matches. If I change "the --pol ipsec" to "--pol none" the rule
>> matches again. This is wrong IMHO as the traffic is still encapsulated
>> (checked this with tshark) as expected.

> This is expected behaviour. Before NAT takes place, the packet
> doesn't match a policy, it only does after getting mangled by
> NAT, but at that point it already passed through your policy
> matches.

I think we're not talking about the same thing :-/

I have a rule in the filter table like this:

iptables -t filter -A FORWARD -i ... -o ... -s ... -d ... -m policy
--mode tunnel --pol ipsec --dir out --tunnnel-src ... --tunnel-dst ...
-j ACCEPT

This rule works as expected, it matches certain ipsec traffic as intended.

As soon as I add a rule like this to the nat table:

iptables -t nat -A POSTROUTING -s ... -d ... -j SNAT --to-source ...

then the OTHER rule (above, the one in the filter table) doesn't match
anymore. This has nothing to do with the source address having changed
because even in this "bare" form:

iptables -t filter -A FORWARD -i ... -o ... -m policy --pol ipsec --dir out

it doesn't match.

This one does match (changed --pol ipsec into --pol none):

iptables -t filter -A FORWARD -i ... -o ... -m policy --pol none --dir out

Yet the traffic IS being encapsulated like before I applied the SNAT rule.

That doesn't seem right to me.

Maybe it's just that I take the wrong approach to the problem; our
supplier requires an ipsec "tunnel" where our internal ip addresses are
translated to a public ip address, I am talking about the encapsulated
packets here, not the ESP packets. With my approach and the current
behaviour, I cannot apply policies properly for this traffic. I am not
at all happy with the situation, but I cannot change it :-(

Thx.
