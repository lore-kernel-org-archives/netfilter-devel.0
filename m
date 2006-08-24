From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_LOG and friends. Question
Date: Thu, 24 Aug 2006 18:14:53 +0200
Message-ID: <44EDD07D.1020805@trash.net>
References: <20060824140320.GJ31235@kriss.csbnet.se>
	<20060824151923.GK31235@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060824151923.GK31235@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> The default 29-32 chars as a prefix is far too little for me. Needs to
> change to 128. But again i see some code allocating this on the stack. It
> this a problem?

We can't change it due to binary compatibility. In your local tree you
can simply increase both sizes (not on the stack of course).

> The code says that a maximum of 830 chars can be used (ICMP-pcaket with
> one recursion level).

Are you sure? That sounds a bit high.

> 128 char prefix and some more on IN, OUT, PHYSIN/OUT
> and MAC fields will give an overall figure of around 1024 chars a good
> buffer length. Anything above that can probably be cut. It won't happen
> alot.
> 
> Another idea of not allocating on the stack nor using GFP_ATOMIC is to have
> a global buffer per CPU. Is this a good idea with the hot adding and
> removing of CPUs? Are linux kernel guarantied to continue on the same CPU if
> an interupt occurs and so on? 

That seems overkill, one global buffer protected by a lock will do fine.
