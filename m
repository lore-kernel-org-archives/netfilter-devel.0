From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH/RFC 1/2] optimization updating timer in connection
	tracking
Date: Mon, 20 Sep 2004 05:40:24 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414E5128.3040204@trash.net>
References: <414DFB56.1050503@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <414DFB56.1050503@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> Hi Patrick,
>
> I think that I found something interesting reading kernel/timer.c some 
> weeks ago, well I would like to know about this idea. The comment 
> above mod_timer speaks by itself...
>
> * mod_timer(timer, expires) is equivalent to:
> *
> *     del_timer(timer); timer->expires = expires; add_timer(timer);
> *
> * Note that if there are multiple unserialized concurrent users of the
> * same timer, then mod_timer() is the only safe way to modify the 
> timeout,
> * since add_timer() cannot modify an already running timer.
> *
> * The function returns whether it has modified a pending timer or not.
> * (ie. mod_timer() of an inactive timer returns 0, mod_timer() of an
> * active timer returns 1.)
>
> so I think that you could use mod_timer in 2.6 and remove that 
> WRITE_LOCK when updating the timer, because it's there to serialize 
> timer updates and now mod_timer controls this possible situation. I 
> don't have a smp machine here but this week I'll look for a platform 
> to test it.
>
> If I'm missing something, please let me know.

We can't use mod_timer because it will re-add a timer that
already went off and dropped it's reference count to the conntrack.
mod_timer is equivalent to del_timer(); add_timer(); but we do
del_timer() && add_timer();

Regards
Patrick
