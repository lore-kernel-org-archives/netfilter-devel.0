From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 10:39:41 +0200
Message-ID: <4462F84D.5000100@trash.net>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
	<4462E031.4090206@trash.net>
	<20060511082555.GB10324@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060511082555.GB10324@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Thu, May 11, 2006 at 08:56:49AM +0200, Patrick McHardy wrote:
> 
> 
>>That all sounds very reasonable. How is the priority of a backend
>>determined?
> 
> 
> statically.  nfnetlink_log overrules ULOG, which overrules LOG.
> 
> We could make that configurable, but I think that's too much
> flexibility.  If a user _wants_ a specific backend, he can chose it. if
> not, we'll fallback on something.


I'm not sure about this. I assume a user would choose the backend
by specifying extra arguments to the NFLOG target, but that isn't
possible for internal logging.

>>>b) reference counting.  We could actually get_module / put_module the
>>>   module that implements a specific backend rather than using our own
>>>   use counter.
>>
>>I guess it depends on whether we want to block unloading while it is
>>in use or do automatic fallback. I tend to prefer the later.
> 
> 
> I agree, I prefer automatic fallback while giving the user the ability
> to unload.  However, if people automatically unload 'unused' modules,
> then there might be a problem (however, for both ULOG and nfnetlink_log,
> userspace listeners would increment the refcount, I think).


Do people still do that? I think distributions stopped the
"rmmod -something" triggered by cron a long time ago.
Anyway, netlink listeners will keep the module pinned.


> Also, there is another unresolved problem:  What if we actually have
> e.g. nfnetlink_log loaded, but it is unable to send a specific packet to
> userspace because there is no listener for this Address family or log
> group?   Should we then also fall back on some other backend?
> 
> At the moment we only fall back if a backend is unbound, but not if it
> e.g. returns an error code because it was unable to log a specific
> packet.


If the user explicitly specifies the backend we shouldn't fall back.
Otherwise I'm not sure .. it probably makes sense as long as we don't
permanently disable the higher priority backend.

BTW, I have a patch queued for 2.6.18 that makes the logging functions
return a status. I guess your patch already includes that, shall
I drop my patch?
