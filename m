From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: condition for 2.6.16
Date: Fri, 28 Apr 2006 14:44:50 +0200
Message-ID: <200604281444.50982.max@nucleus.it>
References: <200604201919.19246.max@nucleus.it>
	<200604281246.40488.max@nucleus.it> <4451F745.4070900@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4451F745.4070900@trash.net>
Content-Disposition: inline
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

On Friday 28 April 2006 1:06 pm, Patrick McHardy wrote:

> > I'll set to work on it. I'll need to change the userspace interface,
> > though. The only O(1) way to do it is to store a pointer (or any other
> > id) in the rule itself. I didn't do it in the previous version because I
> > though this was really ugly. I can't find any other match doing a similar
> > thing. Anyway I can do it.
>
> Unfortunately its ugly, but this is a well-known limitation of iptables
> itself. Since its the only way to do certain things, I won't complain
> if this part is ugly :)

OK. This time I warned you. :)

> > On the other hand I can make it a guaranteed O(log n) or average O(1)
> > without meddling the rule descriptor and with compatible userspace. What
> > do you prefer?
>
> How would you achieve O(1) average?

Hash. But it adds complexity to the code and unnecessary complexity is a form 
of ugliness.

While we're talking about varying degrees of ugliness, how bad would it be if 
I optionally allowed to keep a persistent state across rule removal and 
reinsertion (for example whene someone flushes the table and restarts the 
firewalling script)?
I concede that this would really be easy to do in userspace, so maybe I'm 
answering myself. :)

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
