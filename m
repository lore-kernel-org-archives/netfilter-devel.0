From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: DNAT/SNAT and logging
Date: Wed, 21 Jan 2004 21:16:52 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401212112170.12563-100000@filer.marasystems.com>
References: <1074710915.16080.4.camel@ankarloo.got.volvo.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Johan Ankarloo <johan.ankarloo@volvo.com>
In-Reply-To: <1074710915.16080.4.camel@ankarloo.got.volvo.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 21 Jan 2004, Johan Ankarloo wrote:

> So you don't think that this is a lot of work just to get the logging to
> work correctly? I mean that this is something that ( in my opinion )
> should be done out of the box so to say. 

It is some work, but not very much.

> How should this be done through /dev/net/ip_conntrack?

When I say conntrack I mean in the kernel, not the proc files. By writing 
another LOG target using the information from conntrack rather than the 
packet you can log the information you requested.

See the LOG target and the conntrack match for details, also read the NAT 
& Conntrack sections of the hacking howto.

The most tricky part is when to log the first packet of the session. This
has to be done after all information has been entered into the session,
i.e. after any SNAT targets have been applied.

Another approach is to look into using ctnetlink for detailed session
logging. This is something we are currently implementing.

Regards
Henrik
