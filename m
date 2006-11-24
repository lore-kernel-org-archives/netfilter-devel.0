From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_nat tree updated
Date: Fri, 24 Nov 2006 15:31:32 +0100
Message-ID: <45670244.5070905@trash.net>
References: <Pine.LNX.4.64.0611240036380.21966@blackhole.kfki.hu>	<45669021.8060109@trash.net>	<4566AA49.5020706@trash.net>
	<200611241427.kAOERapt022342@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611241427.kAOERapt022342@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Fri, 24 Nov 2006 09:16:09 +0100
> 
>>This is a first attempt - its quite ugly because of all the
>>new exports it needs. But even worse - what should we do about
>>proc entries added by modules, like the SCTP protocol module?
>>Should we just put this in nf_conntrack_standalone or in case
>>of SCTP in the module itself?
> 
> 
> I like later one from the point of view of modularity. BTW, in the first
> place, why sysctl entries for tcp/udp/icmp are registered by
> nf_conntrack_standalone, not each module ?


Good question - I guess its a relict from ip_chains compatibility
times, like the entire _core/_standalone split.

I'll take another stab at this :)
