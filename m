From: Patrick McHardy <kaber@trash.net>
Subject: Re: CLASSIFY target
Date: Sat, 24 Feb 2007 16:57:42 +0100
Message-ID: <45E06076.1000208@trash.net>
References: <E09867F2FE69EC47B0A631E3183C62C97BA7@exchange.innovates>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Chip Schweiss <chip@innovates.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <E09867F2FE69EC47B0A631E3183C62C97BA7@exchange.innovates>
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

Chip Schweiss wrote:
> Is there a technical reason why the CLASSIFY target can only be called
> from the POSTROUTING chain of the mangle table?  
> 
> It seems rather wasteful to repeat all the logic necessary to classify a
> packet in the POSTROUTING chain that in most case will already be done
> in the filter table.

It can also be called in the FORWARD and OUTPUT chains, but thats not
the point of course. Technically there is no reason for this, its more
of a convention to do packet mangling in the mangle table. The only
case where it is really necessary is marking packets for routing by
fwmark in the output chain, since these packets need to be rerouted.

I guess we could remove this restriction.

> Besides, in my testing the overhead of classifying
> packets in the mangle table seems to be many magnitudes greater than in
> the filter table.

How did you test this? Please post numbers if you have any.

> Would it be possible to simply remove the checks if the rule is being
> added in the POSTROUTING chain of mangle table from the kernel &
> iptables sources and have the CLASSIFY target work from the filter
> table?

Feel free so send a patch, but please also do this for all other
targets restricted to the mangle table and update the manpage.
