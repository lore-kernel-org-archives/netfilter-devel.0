From: Pablo Neira <pablo@eurodev.net>
Subject: Re: libipq scaling
Date: Thu, 05 Aug 2004 08:31:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4111D449.8080806@eurodev.net>
References: <1091658643.32021.91.camel@marx.mindlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Matt Walters <mattw@parasun.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1091658643.32021.91.camel@marx.mindlink.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Matt,

Matt Walters wrote:

>	We're considering using netfilter to do some packet filtering/tagging
>based on external information, and it seems like libipq is the best way
>to do it.  I'm wondering if there are any issues with using this tool in
>an environment where sustained 30Mbit/s throughput is to be expected. 
>The target platform is a dual Xeon 2.8 with gobs of memory, 2.6.7
>kernel.
>  
>

I think that it will work fine with 30 Mbit/s.

>	Has anyone experimented with it?
>

I don't think so AFAIK. I've been benchmarking netlink sockets which is 
the method used but libipq to pass information from/to user space.

>  If not, when we do some performance testing, is anyone interested in the results?
>  
>
I didn't test libipq performance, but I suppose that it won't work for 
gigabit networks because of netlink sockets limitations. If you do those 
performance testings, please post the results to the mailling list.

To do the testing, I propose you to set three boxes, a client and a 
server with iperf and a box between both of them with libipq enqueuing 
all the packets for a 100Mbit/s network.

regards,
Pablo
