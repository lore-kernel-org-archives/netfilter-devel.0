From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT breaks my TCP SYN/ACK?
Date: Tue, 16 Dec 2003 18:51:09 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312161850090.3671-100000@filer.marasystems.com>
References: <3FDF2795.500@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Emmanuel Guiton <emmanuel@netlab.hut.fi>
In-Reply-To: <3FDF2795.500@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 16 Dec 2003, Emmanuel Guiton wrote:

> In my tests, I'm trying from a host at adress X to reach a website at 
> address Y. However this website does not exist on that address but on 
> address Z. Thus, basically in my target, I change address Y for Z. But 
> the connection to the website is refused, and tcpdump shows the following:
> 
> 17:25:21.568709 11.11.11.10.1262 > 10.10.10.10.www: SWE 
> 1338652779:1338652779(0) win 5840 <mss 1460,sackOK,timestamp 
> 8306468[|tcp]> (DF)
> 17:25:21.569136 10.10.10.10.www > 11.11.11.10.1262: R 0:0(0) ack 
> 1338652780 win 0 (DF)

What does tcpdump on the "website" indicate?

My quess is that the port is not mapped correcly causing the SYN to hit 
another port on the server than you intended.

Regards
Henrik
