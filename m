From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] [PATCH] clean up nf_log API
Date: Thu, 11 May 2006 08:56:49 +0200
Message-ID: <4462E031.4090206@trash.net>
References: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060510191034.GA29531@sunbeam.de.gnumonks.org>
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
> Hi!
> 
> After spending some more time with the nf_log API, I think it still
> needs some further cleanup.
> 
> The main point of nf_log was to get some unfied support for packet
> logging backends, independent of the ruleset.  We currently have logging
> backend functionality tied to ipt_LOG, ipt_ULOG packet filter rules,
> which is inflexible and unsuitable for other entities within netfilter
> that want to log packets.
> 
> However, on thing that I missed during the nf_log implementation was the
> fact that it was no longer possible to have some rules using LOG, some
> others ULOG.  With the introduction of nf_log, it was only possible to
> use only one logging mechanism at any given point in time.
> 
> Also, there was no fallback support.  If you had configured
> nfnetlink_log as your backend and the admin decides to remove that
> module, nothing will be logged, even though other mechanisms might be
> available and present in the kernel.
> 
> Another problem was that neither the ULOG nor the LOG target supported
> all of the arguments/parameters that the nfnetlink_log backend needed.
> Therefore, it is practically impossible to exploit all the features 
> with the current kernel.
> 
> Therefore, I now propose the following patchset, which
> 
> 1) enhances 'struct nf_logger' with a list_head, usage counter a
>    priority and pf field
> 2) cleans up the api.  we now call nf_log_[un]register() once from every
>    backend.  registering doesn't mean that it's actually active.
>    successive calls to nf_log_[un]bind_pf() will actually bind a given
>    backend to the specified protocol family.
> 3) introduction of a new NFLOG target.  Only that NFLOG target supports
>    all the arguments that all our backends support.
> 4) Adds 'fallback' support.  This means that during unbind or
>    unregistration of a given backend, we check in the global list of
>    logging backends and chose the one with the hightest priority that
>    supports our protocol family.
> 4) modify ipt_LOG, ipt_ULOG, ip6t_LOG and nfnetlink_log to reflect the
>    abovementioned changes.

That all sounds very reasonable. How is the priority of a backend
determined?


> I have implemented the NFLOG target as iptables target (not xtables) due
> to 'customer need'.  However, once we decide that this patch should be
> merged, I'll provide an x_tables version.
> 
> There are some open questions:
> 
> a) we only search for 'fallback' backends during unregistration/unbind.
>    Should we also do this during registration?  Or whenever we receive
>    a packet and don't have a backend?  Early registration might become
>    problematic, since we don't really know what the user wants...


I think after each change we should just search for the highest priority
backend and use that.

> b) reference counting.  We could actually get_module / put_module the
>    module that implements a specific backend rather than using our own
>    use counter.

I guess it depends on whether we want to block unloading while it is
in use or do automatic fallback. I tend to prefer the later.
