From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Getting the current RTT for an active connection
Date: Wed, 28 Apr 2004 09:28:27 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404280916280.4504-100000@filer.marasystems.com>
References: <1083109593.15705.11.camel@Fallen.FAMILIA>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Alfonso Presa <AlfPresa@msn.com>
In-Reply-To: <1083109593.15705.11.camel@Fallen.FAMILIA>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 28 Apr 2004, Alfonso Presa wrote:

> I'm trying to develop an iptables extension that needs to get the rtt
> for an already established connection. Is there any "eassy" way to do
> this through a conntrack module, or do I have to meassure the delay time
> between each packet and it's ACK?

conntrack does not care about the RTT, just that packets is flowing.

further, measuring the delay between data and ACK won't really give you 
the RTT due to the delayed ack feature of TCP. But I suppose that if you 
keep a running average with high weight to smaller values then you should 
end up in a good approximate.

Also you need to pair data packet to it's ACK. Not just any data packet to 
any ACK. This requires a small memory of what data packets (or their last 
sequence number) has been seen when. Don't forget about window scaling 
option.

> I'm newie in programming modules for the kernel, so I would apreciate
> any kind of help ,explanations and advices you can give me.

It is not very different from any other C programming, except that making 
errors have bigger effects..

UML <http://user-mode-linux.sf.net/> is a great tool to even out the
differences while developing.

Regards
Henrik
