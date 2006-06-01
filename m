From: Patrick McHardy <kaber@trash.net>
Subject: Re: Concurrency issues with the iptables userspace program
	andexitcodes
Date: Thu, 01 Jun 2006 22:45:56 +0200
Message-ID: <447F5204.4080505@trash.net>
References: <1149153349.28481.15.camel@localhost.localdomain>
	<447F1227.7050900@trash.net>
	<Pine.LNX.4.61.0606012200260.27621@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jesper Dangaard Brouer <hawk@diku.dk>
In-Reply-To: <Pine.LNX.4.61.0606012200260.27621@ask.diku.dk>
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

Jesper Dangaard Brouer wrote:
> 
> On Thu, 1 Jun 2006, Patrick McHardy wrote:
> 
>> Wouldn't it make more sense to just make sure you don't have iptables
>> commands running concurrently?
> 
> 
> I already have implemented (f)locks in my code around the iptables
> invocations.  But the problem can still arise when root executes the
> iptables command from the shell. Thus, I still need to handle the
> situation in my code, and a proper exitcode would be nice.
> 
> In iptables-standalone.c it would be very easy to simply return the
> errno instead of !res (which always will return 0 or 1).  Would that be
> a feasable solution?

It would probably break other scripts that check for the current
(documented) exit codes. I guess adding a new one for this case
is fine, other code can't really expect that no new values are
ever added.
