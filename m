From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnetfilter_conntrack checks for (getuid() == 0)
Date: Tue, 15 Aug 2006 19:12:52 +0200
Message-ID: <44E20094.8080309@trash.net>
References: <44E1FFF7.2010103@memespace.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sebastian Hagen <sebastian_hagen@memespace.net>
In-Reply-To: <44E1FFF7.2010103@memespace.net>
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

Sebastian Hagen wrote:
> I'm in the process of writing a program that depends on
> libnetfilter_conntrack (currently using the current version, that is svn
> revision 6663), and have run into an annoyance.
> Obviously interfacing with the ip_conntrack_netlink module requires elevated
> privileges; I'm not quite certain what the required set of required
> privileges for initializing the socket is, but after that CAP_NET_ADMIN is
> definitely sufficient for using dump_conntrack_table().
> 
> None of these operations, afaict, really require the process to have an uid
> of 0. Unfortunately libnetfilter_conntrack checks for that anyway,
> specifically in nfct_event_conntrack() and nfct_event_expectation(). The
> specific code is in both cases:
> 
> if (getuid() != 0)
>    return -EPERM;
> 
> The actual useful code of these functions appears to me to be a strict
> subset of that of dump_conntrack_table(); so since dump_conntrack_table()
> continues to work with only CAP_NET_ADMIN, so should nfct_event_conntrack()
> and nfct_event_expectation().
> Additionally, if one does drop CAP_NET_ADMIN from the effective capability
> set, dump_conntrack_table() will return the error correctly.
> 
> IMHO, these explicit checks for getuid() == 0...
> a) are wrong as they prevent the library user from dropping 'privileges'
> (uid==0 isn't strictly a privilege, but considering the file ownership on
> many systems, it might as well be) they really should be able to drop
> 
> b) allow false negatives as uid 0 processes don't necessarily have CAP_NET_ADMIN
> 
> c) are afaict completely useless in any event, since nfnl_listen() will fail
> correctly in the absence of CAP_NET_ADMIN
> 
> ...and should therefore be removed.

Fully agreed.

> Please do correct me if I'm mistaken about any of this.
> If I'm not, should I make a patch for this? Since the fix would simply
> consist of removing the four mentioned lines from the source, doing that
> would be trivial.


Please send a patch.
