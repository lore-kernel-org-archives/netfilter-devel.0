From: Pablo Neira <pablo@eurodev.net>
Subject: Re: ULOG buffer flush timeout
Date: Tue, 22 Feb 2005 03:09:39 +0100
Message-ID: <421A9463.5070009@eurodev.net>
References: <20050221213602Z4894129-2319+546@kps6.test.onet.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: gofers@poczta.onet.pl
In-Reply-To: <20050221213602Z4894129-2319+546@kps6.test.onet.pl>
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

gofers@poczta.onet.pl wrote:

>I'm developing an application which uses the ULOG target as a manner of copying
>packets from the FORWARD chain to the userspace. One of the goals of the
>application is to store received packets as soon as they arrive from the
>network.  Unfortunately I found annoying problem with the timeout of a netlink
>queue. I set the ulog-qthreshold parameter of the ULOG target to the lowest
>possible value (1). When new packets are not arriving, the last received packet
>is not being passed to the userspace but stays in buffer for about 10 seconds.
>  
>

That was fixed some time ago, please have a look at:

https://lists.netfilter.org/pipermail/netfilter-devel/2004-July/016102.html

--
Pablo
