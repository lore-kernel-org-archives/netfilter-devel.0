From: "Eric Leblond" <eric@inl.fr>
Subject: Re: [RFC,ANNOUNCE] conntrack daemon (stateful replication)
Date: Mon, 29 May 2006 09:26:09 +0200 (CEST)
Message-ID: <55064.192.168.33.2.1148887569.squirrel@mail.inl.fr>
References: <447A1FB7.5080709@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <447A1FB7.5080709@netfilter.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
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

Hi,

> The project is called `conntrackd' that is the conntrack userspace daemon.
> - Stateful replication: the daemon keeps a cache of internal events via
> libnetfilter_conntrack and a cache of external event received from the
> other node.

That sounds good !

> - Support for classical Primary/Backup settings
...
>
> - install libnfnetlink and libnetfilter_conntrack from SVN (and apply
> the patch available in doc/)

A quick look at the patch seems to show that API has changed again :-(

Userspace handling of conntrack is a GREAT thing and conntrackd is one of
the elements that put it on the top of the great Netfilter things. But, it
definitively needs a fixed API because all related projects are at the
same point : "use svn and patch it!"

All nfnetlink related libraries should really been put in delivery state.
Userspace application (conntrackd, NuFW, ...) are waiting for it but they
need stability. For now, we can't even say to our users: "Use 0.999
release and it will work.".
This is the same for articles or documentations that could help spreading
the good word. They have nothing stable to relay on.

I think userspace libraries related to the new nfnetlink stuffs should be
released more frequently. Another way could be to have a stable and a
developement release but it has a cost.

Netfilter has an enormous advantage over other filtering system thanks to
this new features. Don't waste it for a simple release policy problem.

BR and thanks for the great work,
--
Éric Leblond
