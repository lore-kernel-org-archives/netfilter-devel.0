From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Hardware Address
Date: Mon, 27 Sep 2004 17:44:15 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409271743040.18975@filer.marasystems.com>
References: <018401c4a4a7$ea627030$b2aca8c0@AMBERJACK>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ryan Hagelstrom <rhagelstrom@atcorp.com>
In-Reply-To: <018401c4a4a7$ea627030$b2aca8c0@AMBERJACK>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 27 Sep 2004, Ryan Hagelstrom wrote:

> When filtering outgoing packets using the netfilter rules, the packets that
> I get do not have the hardware header on the packet on them. It seems that
> the hardware header is placed on the packet after the packet has gone though
> netfilter.

Correct.

> Can anyone suggest any way to get the hardware header for an
> outgoing packet? I'm looking for a good workaround approach.

Tricky.. but in theory you should be able to guess this by looking at the 
destination device and querying it for it's MAC address provided it is an 
Ethernet interface.

Regards
Henrik
