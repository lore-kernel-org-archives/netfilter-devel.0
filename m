From: Oskar Andreasson <blueflux@koffein.net>
Subject: Re: confusion about mangle
Date: Mon, 14 Oct 2002 17:53:23 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0210141748270.2696-100000@laptop1.agatha>
References: <20021014165810.23290.qmail@web40303.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kevin McConnell <kevymac@yahoo.com>
In-Reply-To: <20021014165810.23290.qmail@web40303.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On this same topic, I just updated the iptables tutorial, which contains
updates which should hopefully reflect the mangle5hooks.patch. Would
anyone take a look at
http://iptables-tutorial.frozentux.net/images/tables_traverse.jpg and tell
me if it's wrong?

As a sidenote, Kevin, you may also be interested in that image since it is 
pretty much what you asked for:). 

Thanks,

Oskar

On Mon, 14 Oct 2002, Kevin McConnell wrote:

> Hi :)
> I noticed that 2 releases ago (1.2.6) the mangle table
> acquired some new chains... 3 to be exact. How do
> these new chains effect the flow of packets? Does
> anyone have it laid out somewhere? I am really trying
> hard to imagine the benefits of adding those
> particular chains, since the docs said never to filter
> in the mangle table. Could someone enumerate on this
> please? Any help is greatly appreciated. Thanks.
> 
> 
> =====
> Kevin C. McConnell --RHCE-- <Red Hat Certified Engineer>
> 
> __________________________________________________
> Do you Yahoo!?
> Faith Hill - Exclusive Performances, Videos & More
> http://faith.yahoo.com
> 
> 

-- 
----
Oskar Andreasson
http://www.frozentux.net
http://iptables-tutorial.frozentux.net
http://ipsysctl-tutorial.frozentux.net
mailto:blueflux@koffein.net
