From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Suggestion: Marker option in iptable, netfilter chains
Date: Mon, 10 Nov 2003 16:10:08 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311101607200.3272-100000@filer.marasystems.com>
References: <200311090446.21825.kreuzritter2000@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kreuzritter2000@gmx.de
In-Reply-To: <200311090446.21825.kreuzritter2000@gmx.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 9 Nov 2003 kreuzritter2000@gmx.de wrote:

> It should be clear that such a feature would be realy helpfull for debugging 
> the firewall script, especially when it is a very long firewall with a lot of 
> ramifications.
> 
> Now my question is, would such a feature in iptables/netfilter be possible?

The easiest way I see for implementhing this is implementing it as a dummy 
match always returning true, with the rule "mark" as parameter to the 
match.

See the netfilter hacking howto for instructions how to write a new match 
module. It is not at all a difficult thing to do if you know a little (not 
much) C programming.

Regards
Henrik
