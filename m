From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Idea: Check session source and destination
Date: Thu, 29 Apr 2004 15:24:52 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404291521030.27094-100000@filer.marasystems.com>
References: <9D157DFC-99DB-11D8-8B47-000A957FD99E@src.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>,
   <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Mike Andersen <mike@src.no>
In-Reply-To: <9D157DFC-99DB-11D8-8B47-000A957FD99E@src.no>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 29 Apr 2004, Mike Andersen wrote:

> So, when I can't use DROP in iptables, can I do it with ebtables 
> instead?

Don't know. Not familiar with ebtables.

But from what I understnad you do not need to drop the packets, you can 
just blackhole them..  effectively the same thing, just happens a little 
later, forwarding the packets into a blackhole instead of dropping them in 
the middle of the forward process. See "ip route blackhole" or a "dummy 
device".

Regards
Henrik
