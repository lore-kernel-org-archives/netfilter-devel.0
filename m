From: Anders Fugmann <afu@fugmann.dhs.org>
Subject: Re: Fixed proken MARK target in POM.
Date: Fri, 10 Jan 2003 16:28:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E1EE68C.7030004@fugmann.dhs.org>
References: <3E1D7419.1060502@fugmann.dhs.org> <20030110140024.GU1353@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030110140024.GU1353@sunbeam.de.gnumonks.org>
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
> On Thu, Jan 09, 2003 at 02:07:37PM +0100, Anders Fugmann wrote:
> 
> 
>>The patch maintains backward compability, and I request that this patch 
>>is applied to mainstream (and pushed to the Andrea for kernel 
>>inclusion), 
> 
> 
> 1) Where is the compatibility?  I cannot see how this code change would
>    ensure that
> 	a) old, unpatched kernel works with new, patched userspace
> 	b) new, patched kernel works with old, unpatched userspace
>    Those two conditions need to be fulfilled, otherwise we cannot make a
>    change during the stable kernel series.
I meant compability in form of userspace syntax, but I will make a new 
patch that sorts out the things above (if possible).

> 
> 2) Which Andrea are you talking about?  Therer is no Andrea involved in
>    netfilter/iptabls updates.
Andrea Arcangeli (2.4.x maintainer, just to recite what you already 
know), but as you wrote in the previous mail, all patches will go 
through netfilter-devel (And let the core team choose what to have 
included in the kernel).

> 
> 
>>as I as a software developer of a firewall cannot ask users 
>>of the software to appliy patches to POM.
> 
> 
> I regard this as critic to my recent patch-o-matic announcement, where I
> was asking people to use patch-o-matic.  I was talking about
Actually not, but thats ok.

> bugfixes/updates which are in 2.4.20 (or 2.4.21-preX)... but people are
> still running older kernels than that... and they should indeed use
> patch-o-matic for the netfilter fixes.
Agreed. Compability between kernel and userspace should be maintained no 
matter version, and patches exist in POM for users of older kernels.

> 
> Apart from that, everything in patch-o-matic are new features or
> extensions, which are either not fully stable or we strongly doubt that
> they are useful for the big public.  And if somebody wants to test one
> of those non-standard extensions, we can ask people to use patch-o-matic.
Yes. I'm aware of that. My question is "How can a patch be proven stable 
enough to be included, and is the functionality provided 'importent' 
enough for the general public?

Regards
Anders Fugmann
