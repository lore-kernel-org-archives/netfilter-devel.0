From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] fine grain locking for tcp helper
Date: Mon, 03 May 2004 15:55:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40964F69.1040508@eurodev.net>
References: <Pine.LNX.4.33.0405031034400.24224-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
 Patrick McHardy <kaber@trash.net>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.33.0405031034400.24224-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

Jozsef Kadlecsik wrote:

>I'm not conviced that much could be gained with per TCP locking assuming
>normal traffic, predominated by TCP. I'm fairly sure that per bucket
>locking is the way we should go.
>  
>

Actually I was having a look at conntrack_locking for per bucket locking 
some days ago, I find it interesting. I had in mind to port them to 2.6 
but Patrick was faster :-).

BTW, is there any problem in using both patches at the same time? If we 
have a machine with mostly tcp traffic, when we take a conntrack, two 
buckets will be locked (for original and reply tuples), but when calling 
tcp specific functions, it will spin until tcp_lock is released possibly 
by other conntrack.

mmm could this reduce the time both buckets are locked?

>Could you check and revive the patches
>
>conntrack_arefcount	- revised reference counting
>  
>
     ^^^
Is conntrack_locking dependent of this patch? in pom-ng is marked as 
dependent, but I don't understand why.

If there's no real dependency I think that I could only test 
conntrack_locking which is more simple (well, I think), this way we 
could push for kernel inclusion, and after that, go test the revised 
reference counting. Am I missing anything?

>conntrack_locking	- per bucket locking
>[conntrack_nonat	- optimization for the conntrack-only case]
>
>The patches could be pushed forward if there were independent
>success reports for general cases, not just performance test reports.
>  
>
sure, I'll have a look at them :-).

regards,
Pablo
