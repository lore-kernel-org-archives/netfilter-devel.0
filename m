From: Brad Fisher <brad@info-link.net>
Subject: Re: ipt_time fixes (resend, sorry)
Date: Fri, 14 Jan 2005 10:27:06 -0600
Message-ID: <41E7F2DA.608@info-link.net>
References: <Pine.LNX.4.61.0501141503220.9908@bizon.gios.gov.pl>
	<20050114143722.GA10088@ti64.telemetry-investments.com>
	<Pine.LNX.4.61.0501141542230.3572@bizon.gios.gov.pl>	<57991.142.169.215.10.1105716756.squirrel@142.169.215.10>
	<Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Samuel Jean <sj-netfilter@cookinglinux.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Krzysztof Oledzki <olenf@ans.pl>
In-Reply-To: <Pine.LNX.4.61.0501141622190.4865@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:

>
> -        packet_local_time = skb->stamp.tv_sec;
> +    /* We might not have a timestamp, get one */
> +    if (skb->stamp.tv_sec == 0)
> +        do_gettimeofday((struct timeval *)&skb->stamp);
>
>      /* First we make sure we are in the date start-stop boundaries */
> -    if ((packet_local_time < info->date_start) || (packet_local_time 
> > info->date_stop))
> +    if ((skb->stamp.tv_sec < info->date_start) || (skb->stamp.tv_sec 
> > info->date_stop))
>          return 0; /* We are outside the date boundaries */
>
I'd like to see the above like become:

+    if ((skb->stamp.tv_sec >= info->date_start) && (skb->stamp.tv_sec 
<= info->date_stop))
         return 0; /* We are outside the date boundaries */

This will have the same logic in most situations, and fix a problem with 
the time match where you need 2 rules to match something like all times 
between 20:00-04:00 (ie. the start time is "greater" than the end 
time).  I've used something similar for years and enjoy not needing 
multiple rules for this.  I also have a patch (and I believe I've 
submitted it in the past) for grabbing the kernel time if no time is 
known (and with that patch, or what's being discussed here, I believe 
the time match should work in any chain).

-Brad Fisher
