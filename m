From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: MARK bit operations patch #2
Date: Tue, 14 Jan 2003 22:29:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E24811C.7000604@fugmann.dhs.org>
References: <3E240801.8080801@fugmann.dhs.org> <20030114211436.GL18686@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030114211436.GL18686@sunbeam.de.gnumonks.org>
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
> On Tue, Jan 14, 2003 at 01:52:17PM +0100, Anders Fugmann wrote:
> 
>>The patch is compatible in the following ways:
>>
>>new kernel - old userspace: OK
>>new kernel - old userspace: OK
> 
> 
> twice the same? 
My bad, should have said:
new kernel - new userspace: OK
old kernel - new userspace: OK
new kernel - old userspace: OK(*)
* - Only if the new userspace is compiled against the old kernel.

(And of course: old kernel - old userspace :-))

>>
>>Please comment. I'm not use if the compatibility satifies the 
>>requirements needed for such a patch to go into the 2.4 series.
> 
> 
> I think this is fine.  The major cases we have to think about are:
> 
> 1) user updates kernel (new kernel, old userspace)
>    The firewall should start up as expected without any changes in
>    userspace
Works.
> 
> 2) user has old kenel running and is updating iptables userspace
>    In this case iptables userspace has to compile without any warnings.
Also Works.
> 
> 
>>Attached: MARK_TARGET.patch - patch against 2.4 (applies to 2.5 aswell))
>>Attached: MARK_operations.patch.userspace  - patch against iptables .1.2.7a)
> 
> 
> Looks fine so far.  The only issue remaining is:
> 
> You are assuming that 
> 
> IPT_ALIGN(sizeof(struct ipt_mark_target_info)) 
> 	!= IPT_ALIGN(sizeof(struct ipt_mark_bitops_target_info))
> 
> while this may be true on x86, I assume it is different on 64bit
> plaforms. Do you have access to any ia64/sparc64/ppc64/mips64 machine
> with linux?
Unfortunatly not. But why could this introduce an problem on a non x86
platform? Also do you know where to look for more information on this?

I also forgot the manpage update. It will come in the next batch.
Thanks for the positive feedback.

Regards
Anders Fugmann
