From: Pablo Neira <pablo@eurodev.net>
Subject: Re: patch for conntrack expectations
Date: Wed, 18 Feb 2004 06:15:10 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4032F4DE.3050402@eurodev.net>
References: <403014C5.8080102@eurodev.net> <20040217213217.GF30968@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <20040217213217.GF30968@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>This is indeed a true observation and good suggestion. 
>
>Hoever, I'm not sure whether it would make any measurable difference.
>The expect was allocated on the stack [which is cheap], and now we have
>one additional (inter-module) function call instead of the allocation of
>a couple of bytes on the stack.  I'm not sure which one is really worse.
>  
>
well, sorry because I'm going to be a bit repetitive but this way 
everyone's going to understand my patch clearly.

in some steps:

1) helper function is called
2) a pointer to a ip_conntrack_expect structure is allocated on the stack
3) if the pattern which we are looking for is *not* found
    -> return NF_ACCEPT
4) else
    -> a ip_conntrack_expect structure is allocated in memory
5) all the fields of the expectation are fulfilled
6) helper calls ip_conntrack_expect_related to insert the expectation
but it passes a pointer to a structure allocated in memory.

what's the different between this approach and the current one?

If the pattern which we are looking for is not found, nothing will 
change, we just allocated less memory on the stack but of course this 
doesn't improve the performance, so it's the same.

By other hand, in the current approach if the pattern is found, the 
function ip_conntrack_expect_related does a memcpy of a structure of 116 
bytes (expectation) from the stack to memory. This is not needed anymore 
since with the new approach the helper works with the future expectation 
already allocated in memory.

I also think that this will result in a cleaner API to manage the 
expectations. well, maybe you could also use this to allocate an 
expectation for the connection tracking replication (well... i just 
started talking so much).

>Also, 2.4.x kernel series are heading for a freeze pretty soon.
>  
>
yes it's true

>So if at all, such a patch would be accepted for 2.6.x.  But then I
>would like to ask you to change all the helpers (esp. the ones in
>patch-o-matic-ng), too.
>  
>
I had a look at almost all the helpers which are in patch-o-matic-ng 
(even the pptp helper). I have no problem about modifying them. BTW, the 
documentation should be updated as well if this change is applied.

Pablo
