From: Patrick McHardy <kaber@trash.net>
Subject: Re: Error reporting in Netlink (Re: Xtables2 Netlink spec)
Date: Fri, 17 Dec 2010 00:31:15 +0100
Message-ID: <4D0AA143.3090608@trash.net>
References: <alpine.LNX.2.01.1011242314580.32646@obet.zrqbmnf.qr>	 <alpine.DEB.2.00.1011261950100.18019@blackhole.kfki.hu>	 <alpine.LNX.2.01.1012150547590.2888@obet.zrqbmnf.qr>	 <alpine.DEB.2.00.1012150921330.3983@blackhole.kfki.hu>	 <Pine.LNX.4.64.1012161041200.8276@ask.diku.dk>	 <alpine.LNX.2.01.1012161322450.6728@obet.zrqbmnf.qr> <1292507013.3395.19.camel@lsx>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Jesper Dangaard Brouer <hawk@diku.dk>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, netfilter@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: tgraf@redhat.com
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <1292507013.3395.19.camel@lsx>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Am 16.12.2010 14:43, schrieb Thomas Graf:
> Thinking of netlink protocols in general and netfilter in specific,
> maintaining a list of reserved error codes for each subsystem/target/
> module will result in an unbearable pain if the error codes are not
> separated into individual namespaces for each module.
> 
> That would in turn require each module to define a unique number or
> some form of namespace resolution mechanism which does not help to keep
> things simple.
> 
> This is the main reason why I advocate the use of error strings.

I completely disagree. As I said previously, userspace has to have
knowledge of the kernel interpretation anyways.

We already have libc calls which define complex errors like:

stdtod(): if val == HUGE_VAL && errno == ERANGE: positive overflow

I see no reason why we can't define combination of attributes
and errno values for netlink messages.

Something like:

[IFLA_VLAN_ID] == NULL && errno == EINVAL: missing attribute
[IFLA_VLAN_LINK] && errno == ENODEV: lower link does not exist

and so on.

