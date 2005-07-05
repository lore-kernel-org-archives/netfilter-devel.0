From: Juha Heljoranta <juha.heljoranta@evtek.fi>
Subject: Re: Extending LOG target to display pid
Date: Tue, 05 Jul 2005 21:05:31 +0300
Message-ID: <42CACBEB.9070901@evtek.fi>
References: <42CAAFE2.3050606@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nick Hay <nickjhay@hotmail.com>
In-Reply-To: <42CAAFE2.3050606@hotmail.com>
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

Nick Hay wrote:
> 2. Any ideas on how I can get the pid of a local packet's creator in the
> log module?  I couldn't find any structures connected to the sk_buff
> that might contain it, and couldn't think of where the data would
> originally come from.

You can copy-paste code from the owner match extension to LOG target to
implement it.

In short, you can do it but to make it pretty requires lot of work (and
knowledge).

You might find this helpful:
http://www.fsfe.org/Members/juha/thesis/thesis.pdf

FYI The owner match extension is just betting when it locates the packet
owner. Although, I admit that it bets right in ~99% of cases... :)

Some body at the netfilter-devel might known could the "socket hooks" be
used:
https://lists.netfilter.org/pipermail/netfilter-devel/2005-May/thread.html#19654

> Actually... would current->pid work?

No. The netfilter code executes quite often in interrupt context (e.g.
when sending tcp syn packets). The current macro might or might not
point to task that sends data.

Regards,
Juha Heljoranta
