From: Samuel Jean <sj-netfilter@cookinglinux.org>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Fri, 14 Jan 2005 17:47:22 -0500
Message-ID: <41E84BFA.1030900@cookinglinux.org>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>	<20050114143722.GA10088@ti64.telemetry-investments.com>	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>
	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: olenf@ans.pl
In-Reply-To: <57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
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

I wrote:
> I use an ugly hack of this kind:
> 
>    /* We might not have a timestamp, get one */
>    if (skb->stamp.tv_sec == 0)
>       do_gettimeofday((struct timeval *)&skb->stamp);
> 
>    now = timeval_to_jiffies(&skb->stamp);
> 
> 
>    if (struct->curr != now)
>       struct->prev = xchg(&struct->curr, now);
> 

Hey, just realized it really doesn't make sense in that module 
(ipt_time). Sorry, I think I was blinded by my current module.

Please discard my post.

Samuel
