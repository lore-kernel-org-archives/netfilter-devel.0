From: Amin Azez <azez@ufomechanic.net>
Subject: Re: l7-filter patch for p-o-m
Date: Tue, 12 Jul 2005 09:42:55 +0100
Message-ID: <42D3828F.3040809@ufomechanic.net>
References: <Pine.LNX.4.61.0505312259080.6304@localhost.localdomain>	<429D89EB.5000605@eurodev.net>
	<Pine.LNX.4.62.0506221258490.9129@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthew Strait <quadong@users.sourceforge.net>
In-Reply-To: <Pine.LNX.4.62.0506221258490.9129@localhost.localdomain>
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

Matthew Strait wrote:
> Please let me know what the requirements for acceptance are.  Removing
> nfcache is trivial, so I will do it, but your other suggestions are not
> (and several of them aren't really possible yet).  The current state of
> the patch is stable and fairly well tested, so I'd like to get it into
> p-o-m more or less as-is, if that is possible.

I've been using l7 stuff for a while and find it to be good and stable.

I'm also interested in Rusty's conntrack extension infrastructure which
I hadn't heard of till now, I've been extending ip_conntrack struct in
the same way L7 has.

All I can find is
http://www.netfilter.org/documentation/HOWTO//netfilter-hacking-HOWTO-4.html#ss4.4
which I don't think is the same thing.

It's not obvious how ct->help is any less intrusive on the ip_conntrack
struct than what L7 currently does.

Amin
