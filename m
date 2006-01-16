From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: x_tables userspace
Date: Mon, 16 Jan 2006 13:38:28 +0100
Message-ID: <43CB93C4.4060500@eurodev.net>
References: <333e1ca10601160212g4a9f21e8p78c26fd113197a60@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Michal Rokos <michal.rokos@gmail.com>
In-Reply-To: <333e1ca10601160212g4a9f21e8p78c26fd113197a60@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Michal Rokos wrote:
> now when x_tables are merged one question has to come:
> 
> Is there any userspace prog that can manage x_tables? Something like ip46tables?

No, this does not suppose any change from userspace side. It's just part
 of the ipv4-ipv6 code reunification.

> (All I really want is to finally use ipv6 stateful netfilter. And when
> iptables and ip6tables are already merged somewhere it would be
> great!)

Stateful ipv6 went into 2.6.15, so you can give it a try in this -rc1.
Just check the following boxes:

Network packet filtering (replaces ipchains) ---> Core Netfilter
Configuration  --->  Layer 3 Independent Connection tracking (EXPERIMENTAL)

And then add support for IPv4 and IPv6:

Network packet filtering (replaces ipchains) ---> IP: Netfilter
Configuration --->  IPv4 support for new connection tracking (EXPERIMENTAL)

Network packet filtering (replaces ipchains) ---> IPv6: Netfilter
Configuration (EXPERIMENTAL)  --->  IPv6 support for new connection
tracking (EXPERIMENTAL)

Previously, don't forget to uncheck the old connection tracking support.
Otherwise the IPv6 support won't be available.

-- 
Pablo
