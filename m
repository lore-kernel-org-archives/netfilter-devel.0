From: Philip Craig <philipc@snapgear.com>
Subject: Re: Problem with new --physdev-out style
Date: Wed, 24 Oct 2007 18:22:52 +1000
Message-ID: <471F00DC.9070001@snapgear.com>
References: <20071024071854.GA18581@volker-sauer.de> <471EF68A.702@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Volker Sauer <volker@volker-sauer.de>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <471EF68A.702@trash.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
>> $IPTABLES -A FORWARD -i $BR_GUEST -o $BR_INT -m physdev --physdev-out $IF_DMZ -p tcp --dport 3389 -j ACCEPT
> 
> Try adding "--physdev-is-bridged" to your rules. Without that the kernel
> is not able to tell whether they apply only to bridged packets or also
> to forwarded or locally generated ones.

That won't work for the above rule, for example, since the packet is
being forwarded between two different bridges, so it is not bridged.

The only solution I am aware of is to stop bridging and use routing
and arp proxy.
