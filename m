From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables_target and unknown size data.
Date: Wed, 26 Nov 2003 11:18:54 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311261111490.8657-100000@filer.marasystems.com>
References: <3FC47AEA.5090104@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <3FC47AEA.5090104@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 26 Nov 2003, Emmanuel Guiton wrote:

> I am writing an iptables extension. It's a new target. My problem is 
> that I need to use a linked list whose size is unknown when registering 
> the target. As I am not very familiar with the alignment problems, I am 
> wondering if it can cause any trouble?

Not sure doing this is even possible. The target/match size needs to be 
static in iptables extensions.

What surely is possible is to have the list loaded into another module via 
/proc or something, and then look up the list in the check() function of 
the target/match.

Extending iptables to support variable sized targets/matches is possible 
bu simply dropping the size checks from ip_tables.c and extending the 
userspace to allow matches/extensions to grow their data, but you will 
need to encode the data using offsets not pointers.

Regards
Henrik
