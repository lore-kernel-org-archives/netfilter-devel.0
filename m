From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Optimizing rule loading, iptables-1.3.0 and iptables-batch
Date: Tue, 7 Sep 2004 13:15:07 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409071309410.23282@filer.marasystems.com>
References: <Pine.LNX.4.61.0409070017220.23341@vortex.int.webcon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert Hardy <rhardy@webcon.ca>
In-Reply-To: <Pine.LNX.4.61.0409070017220.23341@vortex.int.webcon.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 7 Sep 2004, Robert Hardy wrote:

> iptables-batch has the advantage of being able to batch install a single
> chain (or part of a chain) of a table in a more optimal manner. This was
> sorely lacking in iptables-restore. Even when patched with the recent "fixes
> patch" off the devel list, iptables-restore still only allows you to save
> and restore whole tables.

Not entirely true. There is the --noflush (-n) option to iptables-restore 
which allows you to do any kinds of operations you please.

Load a user chain:

iptables-restore --noflush << EOF
*filter
-F userchain
-A userchain .....
COMMIT
EOF

Insert a set of rules in the middle of an existing chain:

iptables-restore --noflush << EOF
*filter
-I userchain 4 .....
-I userchain 5 ....
-I userchain 6 ....
COMMIT
EOF


It is true that iptables-save only saves a complete table however.

> While it does compile nicely, it unforunately segfaults after every
> command. Even something simple like iptables -L with no rules loaded.

The iptables userspace is currently being rewritten quite extensively.

Regards
Henrik
