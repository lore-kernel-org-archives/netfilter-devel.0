From: Pablo Neira <pablo@eurodev.net>
Subject: Re: REJECT using invalid data
Date: Tue, 07 Dec 2004 12:07:15 +0100
Message-ID: <41B58EE3.5050709@eurodev.net>
References: <20041207010130.GC4757@netnation.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Simon Kirby <sim@netnation.com>
In-Reply-To: <20041207010130.GC4757@netnation.com>
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

Simon Kirby wrote:

>After some recent interesting network issues involving an onboard Tigon3
>card with faulty buffer memory, we discovered that netfilter has some
>issues with handling corrupted packets.  This took quite some time to
>diagnose, I might add. :)
>
>It appears that a packet with a bad TCP checksum will be disregarded by
>the state tracking code (and apparently shows up as "INVALID").  Fine.
>
>However, the same packet will then likely continue traversing rules until
>it hits some kind of REJECT rule.
>

not really, my ruleset drops it, actually another rule here is 
previously logging it.

-A INPUT -m state --state INVALID -j DROP

>  REJECT can be set to reject with a
>tcp-reset or some ICMP response at this point.  If so, it will actually
>use the possibly-incorrect information from the bad TCP packet and send a
>rejection packet.  As far as I can tell, this is a bug.
>  
>

yes, that's a bug, but in your ruleset, people should log/drop/let 
continue invalid packets, but not reject them. So I don't see the point 
of sending a patch. Maybe you could send a patch to clarify this in the 
man page.

--
Pablo
