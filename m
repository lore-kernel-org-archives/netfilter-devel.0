From: Patrick McHardy <kaber@trash.net>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 18:01:19 +0200
Message-ID: <44E09E4F.3040506@trash.net>
References: <44E07BCD.8030206@trash.net>
	<20060814142559.GS7194@kriss.csbnet.se>
	<44E08946.1040105@trash.net>
	<20060814152026.GU7194@kriss.csbnet.se> <44E09746.60302@trash.net>
	<20060814154005.GW7194@kriss.csbnet.se>
	<44E09AF3.2080406@trash.net>
	<20060814155642.GA15328@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814155642.GA15328@kriss.csbnet.se>
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
> 2006-08-14 17:46:59+0200, Patrick McHardy <kaber@trash.net> ->
> 
>>Thats not true, the master pointer is reinitialized on every change by
>>the checkentry function (which, as you note, is called on all rules for
>>every change). The simple reason why it keeps its current state is
>>because it is dumped to userspace and echoed back. If you move it out of
>>the structure shared with userspace, this can not happen anymore.
> 
> 
> I think we define reinitiated differently then. I define reinitated by
> checkentry() being runned even tho the match/rule isn't a new (or altered)
> match/rule. 
> 
> If checkentry() is runned for _all_ matches/targers everytime an unrelated
> rule is altered then limit will lose its state because the code resets the
> bucket and refills it.


You're right. That is actually a bug in my opinion.

> Meaning that if I have a limit of 1 packet each hour
> and I change an (unrelated) rule every 30mins the limit will be a limit of 1
> packet every 30min instead. The (ugly) workaround i posted will solve this
> issue by keeping track if it has been running the checkentry() before. This
> is where the priv_data is needed.


No, we can simply check if f.e. credit is non-zero.

> But if you say that the priv_data pointer will be lost for all rules on any
> alter of rules its kinda void to have it. However a solution keeping that
> priv_data pointer intact could be very useful. 


That would mean the kernel needs to associate new rules with rules in
the old table (or the individual modules itself need to do it somehow,
like hashlimit or recent). This is really getting too ugly to even
consider in my opinion, especially since the obvious solution of not
doing an atomic table exchange also solves a lot of other problems.
