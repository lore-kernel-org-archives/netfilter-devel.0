From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_tables.c: mark_source_chains: bad negative verdict
Date: Tue, 24 Jul 2007 18:40:58 +0200
Message-ID: <46A62B9A.9010009@trash.net>
References: <200707201725.50459.thomas.jarosch@intra2net.com>	<46A0E43D.1020606@trash.net>
	<200707211613.18112.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707211613.18112.thomas.jarosch@intra2net.com>
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

Thomas Jarosch wrote:
> Hello Patrick,
> 
> On Friday, 20. July 2007, Patrick McHardy wrote:
> 
>>>Jul 20 17:11:13 intratest2 kernel: mark_source_chains: bad negative
>>>verdict (-2140522486)
>>>
>>>How can the "bad negative verdict" code be triggered?
>>>How can it be fixed? :-)
>>
>>I'm pretty sure its related to the mark_source_chains optimization.
>>Try removing the " || visited" from the condition just before the
>>"negative verdict" printk.
> 
> 
> Thanks, that did the trick, the firewall plays nice again.
> Let me know if I can aid debugging/fixing the code.


Yes, what you could do is use the original ruleset (not the saved one)
and find out which rule causes the error.
