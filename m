From: Brad Fisher <brad@info-link.net>
Subject: Re: libnetfilter_queue man page
Date: Wed, 08 Feb 2006 12:18:38 -0600
Message-ID: <43EA35FE.6000000@info-link.net>
References: <1139235549.30902.3.camel@localhost.localdomain>	<20060208141927.GX31060@sunbeam.de.gnumonks.org>
	<43EA2683.3030606@info-link.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Kevin Spiteri <kspiteri@hobsoft.com.mt>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <43EA2683.3030606@info-link.net>
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

Brad Fisher wrote:
> One small thing I should mention - possibly a bug:  I tried playing 
> around with nfq_get_packet_hw() yesterday and the hw_addrlen returned 
> seemed to be much too large...  For an ethernet packet I'd expect it 
> to be 6 (ethernet MAC address is 6 octets), but it was something like 
> 1520 or so.  Needless to say, much larger than expected.  Perhaps I'm 
> interpreting it wrong.  I haven't had a chance to look too deeply into 
> it yet.
I've determined that this is not a bug.  The hw address length is 
returned in network byte order, and thus the confusion.  The value of 
1536 I was seeing on an Athlon system is actually 6 in network order.  A 
simple ntohs() fixed it.  Sorry if this confused anyone...  Sure 
confused me for a bit :)

-Brad
