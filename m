From: Evan Harris <eharris@puremagic.com>
Subject: Re: Bug/Problem with DNAT on OUTPUT chain (-t nat -A OUTPUT) that
 breaks routing? (fwd)
Date: Thu, 23 Oct 2003 11:30:36 -0500 (CDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0310231127470.29188-100000@kinison.puremagic.com>
References: <3F973F04.8090703@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@lists.netfilter.org, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F973F04.8090703@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Ok, I've upgraded to kernel 2.4.22, and the same behaviour is being
exhibited.

To recap the problem:

Packets being nat'd on the OUTPUT chain of a machine are still being sent on
the same interface they would have without the nat, and ignoring the route
that aims them to the right iface for that dest addr.

Evan


On Thu, 23 Oct 2003, Patrick McHardy wrote:

> Evan Harris wrote:
>
> >I am using a stock linux kernel 2.4.20, with iptables 1.2.8.
> >
> >
> >
> Try 2.4.22 first, there were countless changes, some related to
> routing.
>
> Best regards,
> Patrick
