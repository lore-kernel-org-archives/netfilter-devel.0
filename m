From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Multiple Address specification or match
Date: Thu, 30 Sep 2004 10:34:52 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409301033400.28021@filer.marasystems.com>
References: <018201c4a6ab$a1ecb6c0$2201010a@bluereef.local>
	<415BAAF0.6030907@rediffmail.com>
	<019d01c4a6b9$55278370$2201010a@bluereef.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, Swapnil Nagle <swapsn@rediffmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Temp02 <temp02@bluereef.com.au>
In-Reply-To: <019d01c4a6b9$55278370$2201010a@bluereef.local>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 30 Sep 2004, Temp02 wrote:

> No obviously a single source can't be both addresses, but the intent is to
> allow a single rule to be used to match sources from both source ranges.

There is two ways for doing this

a) Using two rules, one per IP address.

b) Using an ippool/ipset storing the IP addresses.

Regards
Henrik
