From: Simon Lodal <simonl@parknet.dk>
Subject: Re: Multiple Address specification or match
Date: Thu, 30 Sep 2004 19:05:44 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415C3CE8.4060004@parknet.dk>
References: <018201c4a6ab$a1ecb6c0$2201010a@bluereef.local><415BAAF0.6030907@rediffmail.com><019d01c4a6b9$55278370$2201010a@bluereef.local>	<Pine.LNX.4.61.0409301033400.28021@filer.marasystems.com>
	<002901c4a6cb$d3ae6490$2201010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Temp02 <temp02@bluereef.com.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <002901c4a6cb$d3ae6490$2201010a@bluereef.local>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

> Is it hard to extend the source and destination match functions to accept
> multiple arguments?

Yes, they are pretty wired into iptables. And I would worry about their 
performance.

But it should be easy to create a new match to do it. There is already 
multiport and mport. The equivalent for addresses should not be hard.


Simon
