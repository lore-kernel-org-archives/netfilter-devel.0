From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: Checking add/remove rules
Date: Thu, 25 Aug 2005 08:00:23 +0200 (CEST)
Message-ID: <Pine.LNX.4.58.0508250750040.23501@tux.rsn.bth.se>
References: <5ad977d1050822070113bd1e6b@mail.gmail.com>
	<5ad977d1050824201244abc978@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Silimite <silimite@gmail.com>
In-Reply-To: <5ad977d1050824201244abc978@mail.gmail.com>
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

On Wed, 24 Aug 2005, Silimite wrote:

> Should I take this silence as meaning this is not possible?  Or maybe
> no one knows?
>
> Even a "that's not possible" answer would be nice.

It is possible, it's ugly but possible.

Look at the geoip match in patch-o-matic-ng, more exactly the refcounting
in the checkentry()/destroy() functions in ipt_geoip.c And look at the
posision of the refcount member of the ipt_geoip_info struct in the
includefile. And look at the size and userspacesize members of struct
iptables_match in libipt_geoip.c

I hope that helps.

/Martin
