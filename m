From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: 2.4.20 and user space ICMP REDIRECT
Date: Sun, 09 Mar 2003 10:01:57 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303090001.h2901wq08424@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: "Netfilter Development Mailinglist" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Patrick Schaaf" <bof@bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> >   Harald's name came up in the kernel code (of course ;-) some
> > place like ip_nat_core (sample of the interesting bit below - but
> > not incl Harald ref) ..  is there something like this in the kernel
> > that is causing me problems?
> 
> You said you are doing this, and seeing the problem, without any
> active iptables rules, right? And you see suitable counters go up?
Yeah, no active rules, and I didn't check counters without the rules,
but with a single permit rule, its counter didn't go up, so my gut
feeling is that its either not iptables, or tables is doing something and
not reporting it.


> > Ie -  Is there some sort of safe guard or config option that I'm missing?
> 
> I would almost bet that this is a generic feature of the network stack.
> The linux-net mailing list would probably be the more helpful place
> to ask.  I strongly doubt that is has anything to do with netfilter
> or iptables.  You could easily try to prove that, by recompiling the
> kernel to not contain any iptables stuff.
Thanks Patrick ... I'll go and find linux-net and ask them ...


 
> best regards
>   Patrick
> 
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
