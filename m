From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_tables.c: mark_source_chains: bad negative verdict
Date: Fri, 20 Jul 2007 18:35:09 +0200
Message-ID: <46A0E43D.1020606@trash.net>
References: <200707201725.50459.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707201725.50459.thomas.jarosch@intra2net.com>
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
> Hello there,
>
> I've upgraded to kernel 2.6.21.6 / iptables 1.3.7 and now a big firewall table 
> fails to load. The error message from the iptables command is
> "iptables: Too many levels of symbolic links", so I've enabled debugging in 
> net/ipv4/netfilter/ip_tables.c. Here's the debug output from it
> after trying to run "iptables -A C70 -j forward_ok":
> [...]
> Jul 20 17:11:13 intratest2 kernel: Jump rule 232340 -> 232960
> Jul 20 17:11:13 intratest2 kernel: Jump rule 232960 -> 215940
> Jul 20 17:11:13 intratest2 kernel: Jump rule 233176 -> 215940
> Jul 20 17:11:13 intratest2 kernel: mark_source_chains: bad negative verdict 
> (-2140522486)
>
> How can the "bad negative verdict" code be triggered?
> How can it be fixed? :-)
>   

I'm pretty sure its related to the mark_source_chains optimization.
Try removing the " || visited" from the condition just before the
"negative verdict" printk.
