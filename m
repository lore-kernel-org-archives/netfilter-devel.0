From: Allen Francom <aef@prismnet.com>
Subject: Re: Statefull SOCKS filter
Date: Thu, 9 Mar 2006 10:49:27 -0600 (CST)
Message-ID: <20060309104524.B75323@tempest.prismnet.com>
References: <44101CA5.3070004@coolsystems.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Peter Christensen <pch@coolsystems.dk>
In-Reply-To: <44101CA5.3070004@coolsystems.dk>
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



Once upon a time I interacted with a project called "Hogwash".

This was all layer 2 and seemed to be off to a great start.

Sounds more like what you need, "transparent".

The maintainer resigned, however the code ran, based on
Snort and associated libraries.

With a lot of help from others, I made a binding
for these rules into IPTables via the QUEUE target... but
that wasn't all that clean.  Maybe skip the IPTables
entirely, and "do like hogwash did".

2 cents...

On Thu, 9 Mar 2006, Peter Christensen wrote:
> I'm currently in the development of a transparent firewall bridge, whose sole 
> purpose is to filter our everything but LAN traffic and traffic for a list of 
> privileged servers on the Internet. Since it is meant to work on an bunch of 
> different network configurations out-of-box, it must be able to detect and 
> filter proxy traffic as well.
