From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH/RFC 1/2] optimization updating timer in connection
	tracking
Date: Mon, 20 Sep 2004 14:27:08 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414ECC9C.8000105@eurodev.net>
References: <414DFB56.1050503@eurodev.net> <414E5128.3040204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <414E5128.3040204@trash.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy escribió:

> We can't use mod_timer because it will re-add a timer that
> already went off and dropped it's reference count to the conntrack.
> mod_timer is equivalent to del_timer(); add_timer(); but we do
> del_timer() && add_timer();


thanks for the hint, in that case, is it worthy adding something like

----- from kernel/timer.c  ----
261         /*
262          * This is a common optimization triggered by the
263          * networking code - if the timer is re-modified
264          * to be the same thing then just return:
265          */
266         if (timer->expires == expires && timer_pending(timer))
267                 return 1;
----- end -------

inside the write_lock section?

regards,
Pablo
