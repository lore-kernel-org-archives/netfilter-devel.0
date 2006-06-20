From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] entry_data
Date: Tue, 20 Jun 2006 15:17:21 +0200
Message-ID: <4497F561.4000503@trash.net>
References: <200606050029.08602.max@nucleus.it>
	<200606200035.07197.max@nucleus.it> <44972FB3.5070603@trash.net>
	<200606201325.02775.max@nucleus.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>
In-Reply-To: <200606201325.02775.max@nucleus.it>
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

Massimiliano Hofer wrote:
> I changed the API on the (possibly wrong) assumption that most modules will 
> need it for shared data (that's what I and at least some other modules need), 
> but thinking about it there are other uses (multiple data with different 
> sharing, non shared data that has no business in the userspace struct, etc.). 
> In other words, you're right.
> 
> Following your suggestion I could add a .priv_size field and if it is non zero 
> I allocate the requested memory and pass it as void * (the same type passed 
> to (*checkentry)(), (*destroy)() and (*match)()).
> 
> We have 2 ways to implement this:
> - we can allocate priv_size more bytes after data;
> - we can separately allocate priv_size bytes and store a pointer in 
> u.kernel.entry_data.
> 
> Seeing how the initialization code works, the first one is a bit hairy. The 
> latter is really easy to implement, but if someone just needs 4 bytes we end 
> up storing a pointer to a pointer with no good reason.


The case of just needing a pointer is just an optimization for a
special-case in my opinion (avoid lookup of globally shared state),
per-instance state is probably more common. So I'd suggest to go
with the second possibility.
