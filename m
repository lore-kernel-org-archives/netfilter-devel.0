From: Joakim Axelsson <gozem@gozem.se>
Subject: Re: new ABI
Date: Wed, 16 Aug 2006 14:29:41 +0200
Message-ID: <20060816122941.GB31235@kriss.csbnet.se>
References: <200608142312.41851.max@nucleus.it>
	<20060816121653.GA31235@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Massimiliano Hofer <max@nucleus.it>,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20060816121653.GA31235@kriss.csbnet.se>
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

2006-08-16 14:16:53+0200, Joakim Axelsson <gozem@gozem.se> ->
> We keep the idea of rules (rather than essay, compiled or other form). To
> make the new implementation as easy and as fast as possible i think using
> XML to express the firewall is a good way to go. Now before you turn on all
> your negatives, here's why:
> 
> - We want the old (todays) iptables to be compliant.
> - We want an easy library that implements the ABI to kernel.
> - We want to make the smallest possible effort writing a userspace tool.
>   Leaving the more advacned for others / other projects.
> 
> XML already has good parsers. We can very easily rewrite todays iptables to
> output XML. XML has no real limits on how to express things. Ofcourse can
> other future userspace program use the new ABI-library directly, not using
> the XML-parser. However, for those who doesn't want to learn the new library
> XML is very easy. Both for humans, scripts and programs.
> 
> So we need one userspace library that talks the ABI with kernel. We also
> need a library using this ABI that parses XML-files and passes them to the
> ABI-library. Finally other userspace tools (that we do not need to write)
> that dumps from kernel passed by the kernel->ABI->XML and pushes XML rules.
> 
> iptables is now easily ported like:
> iptables <-> XML <-> ABI <-> kernel
> 

Too already demonstrate the greatness of XML; I forgot to add in my previous
mail the need/wish for being able to list all state data of one module. For
example i have a module just making counters, represented in /proc. I can
easy list them all by a simple "grep *" (gives both filename and content).
With XML this extra isn't needed. As long as i can get the full kernel
config and state in XML, i can apply my favorite XML-parser and figure out
the data i need. :-)

--
Joakim Axelsson
