From: Kevin McConnell <kevymac@yahoo.com>
Subject: Re: [PATCH] wanted: testers for ip_nat_cuseeme module
Date: Mon, 4 Nov 2002 22:17:15 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021105061715.6681.qmail@web40311.mail.yahoo.com>
References: <1036460255.689.34.camel@exile>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Filip Sneppe \(Cronos\)" <filip.sneppe@cronos.be>,
  netfilter-devel@lists.netfilter.org
In-Reply-To: <1036460255.689.34.camel@exile>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--- "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
wrote: 
> - You will find that there is only an ip_nat_cuseeme
> module.
>   Since there are no random ports being opened, but
> payloads
>   do contain embedded IP addresses, there is only a
> need for
>   packet payload "mangling" in NAT scenarios.
>   I was quite happy to find out that
> netfilter/iptables
>   happily supports this!

So did you add your module into the CVS repository or
where can we get it from? Is this particular module in
addition to the H323 patches or or is it in place of?

> Regards,
> Filip
> 
> ps. Unless someone else has started working on this,
> I will probably
> end up writing a conntrack/nat helper for Microsoft
> MSN Messenger, 
> now that I still have a Windows partition on a test
> box, so feel free
> to volunteer as a tester for that too :-)

I would be happy to test out both modules. Where is
the first one available and when will the second be
available?


=====
Kevin C. McConnell --RHCE-- <Red Hat Certified Engineer>

__________________________________________________
Do you Yahoo!?
HotJobs - Search new jobs daily now
http://hotjobs.yahoo.com/
