From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 09:38:50 +0200
Message-ID: <471EF68A.702@trash.net>
References: <20071024071854.GA18581@volker-sauer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Volker Sauer <volker@volker-sauer.de>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20071024071854.GA18581@volker-sauer.de>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Volker Sauer wrote:
> with recent kernels, I have this problem:

Bugreports to netfilter-devel please.

> kernel: physdev match: using --physdev-out in the OUTPUT, FORWARD and
> POSTROUTING chains for non-bridged traffic is not supported anymore.
> 
> What does "non-bridged" in this context mean?? If it means rules (or
> traffic) that goes over the INPUT our OUTPUT chain, I do not understand,
> why my rule set causes this message to appers a thousand times.
> 
> Here's all my rules with --physdev-out:
> 
> arthur: ~ # grep physdev-out /etc/init.d/firewall
> $IPTABLES -A FORWARD -o $BR_INT -m physdev --physdev-out $IF_INT -i $IF_EXT -d $localnet -s $Any -m state --state ESTABLISHED,RELATED -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_INT -m physdev --physdev-in $IF_INT --physdev-out $IF_DMZ -s $ZAPHOD -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_INT -m physdev --physdev-in $IF_INT --physdev-out $IF_DMZ -s $localnet -p tcp -d $MARVIN --dport 3389 -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_INT -m physdev --physdev-in $IF_DMZ --physdev-out $IF_INT -d $ZAPHOD -p tcp --dport 135:139 -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_INT -m physdev --physdev-in $IF_DMZ --physdev-out $IF_INT -d $ZAPHOD -p udp --dport 135:139 -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_INT -m physdev --physdev-in $IF_DMZ --physdev-out $IF_INT -d $ZAPHOD -p tcp --dport 445 -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_INT -m physdev --physdev-in $IF_DMZ --physdev-out $IF_INT -d $ZAPHOD -p udp --dport 445 -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_INT -m physdev --physdev-in $IF_INT --physdev-out $IF_DMZ -s $ZAPHOD -m state --state ESTABLISHED,RELATED -j ACCEPT
> $IPTABLES -A FORWARD -o $BR_INT -m physdev --physdev-out $IF_INT -i $BR_GUEST -m state --state ESTABLISHED,RELATED -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_GUEST -o $BR_INT -m physdev --physdev-out $IF_DMZ -p tcp --dport 3389 -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_GUEST -o $BR_INT -m physdev --physdev-out $IF_INT -p tcp --dport ssh -j ACCEPT
> $IPTABLES -A FORWARD -i $BR_GUEST -o $BR_INT -m physdev --physdev-out $IF_INT -p tcp --dport 30022 -j ACCEPT
> $IPTABLES -A FORWARD -i $IF_EXT -o $BR_INT -m physdev --physdev-out $IF_DMZ -p tcp --sport 22 -m state --state ESTABLISHED,RELATED -j ACCEPT
> $IPTABLES -A FORWARD -i $IF_EXT -o $BR_INT -m physdev --physdev-out $IF_DMZ -s $i -p udp --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
> 
> 
> Where: 
> 
> BR_INT="br-intern"
> BR_GUEST="br-guest"
> IF_EXT="eth0"
> IF_INT="eth1"
> IF_DMZ="vlan3"
> 
> You see, I use --physdev-out only in the FORWARD with bridged traffic, 
> because the Interfaces given with -i or -i in these rules are always 
> bridges (br-intern or br-guest).
> 
> Why do I get thousands of these error messages?

Try adding "--physdev-is-bridged" to your rules. Without that the kernel
is not able to tell whether they apply only to bridged packets or also
to forwarded or locally generated ones.

Suggestions how to improve this are welcome.


