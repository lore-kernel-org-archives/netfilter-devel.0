From: Henrik Nordstrom <henrik@marasystems.com>
Subject: Re: iptables error reporting
Date: Wed, 21 Jan 2004 01:44:43 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401210121260.29823-100000@filer.marasystems.com>
References: <20040120130122.GC8642@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040120130122.GC8642@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 20 Jan 2004, Harald Welte wrote:

> we have no more verbose error reporting due to the getsockopt/setsockopt
> interface.  I don't see a way how this could change :(

There is ways to noticably improve the error reporting in the userspace
part of things on the type of errors discussed.

Today there is a single error message covering all three cases (No
chain/target/match by that name), but since the userspace knows in detail
what chains exists it should be easy to make the userspace use another
error for invalid chain chain names allowing the error repoting to be
improved into

  No chain by that name
  No match/target by that name

In addition the chain error could easily include the chain name in
question. it is after all the userspace which decides the chain does not
exists by reading the old table from the kernel so it should be trivial to 
report which chain we did not find in the table making this error read like

  No chain named '%s'

And with the addition of the /proc/net/ip_XX_names the second error could
be extended to include which match/target is not existing by looking for
the first unknown match/target in the new table, allowing both 
separation of target or match and which target/match is missing, making 
this error read like

  No match named '%s'
  No target named '%s'

Anyone wanting to take a shot at this?


What can not currently be solved in iptables is the case where a kernel
extension rejects the information given by userspace, or where there is
structural mismatches between user/kernel such as seen by the TRACE patch
if user/kernel binaries is not in sync. These have no choice but to give a
"operation failed" type error message with at best a more verbose error
message in the kernel log explaining who rejected the table and why.

Regards
Henrik
