From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Mon, 20 Oct 2003 05:09:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F9351D4.3070704@trash.net>
References: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com> <3F934FFD.7090700@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Harald Welte <laforge@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <3F934FFD.7090700@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:

> - we can use some sorting algorithm which benefits from pre-sorted 
> input. this would
>  give better average performance. IIRC new conntracks are added at the 
> head of the
>  chains, so if we sort and walk backwards through the chains we only 
> have to resort
>  after an id counter wrap. Sorting is also pretty easy in that case: 
> move all entries at
>  head of list whose id is smaller than the last one's to the tail 
> while preserving order,
>  stop at first one thats bigger. This also means we only need the 
> write lock in a very
>  very rare case. 


One small addition, this it not completly correct we need to resort more 
often, but never
before the first counter wrap.

Best regards,
patrick
