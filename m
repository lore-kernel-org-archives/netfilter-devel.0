From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink delete conntrack performance
Date: Tue, 15 Mar 2005 19:57:47 +0100
Message-ID: <4237302B.5040606@trash.net>
References: <422C3A1B.5080604@ingate.com> <422C5370.9050204@trash.net>
	<42372984.9090807@ingate.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, KOVACS Krisztian <hidden@balabit.hu>
To: Marcus Sundberg <marcus@ingate.com>
In-Reply-To: <42372984.9090807@ingate.com>
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

Marcus Sundberg wrote:
> Patrick McHardy wrote:
>>
>> You can't drop the reference before calling the timeout function.
> 
> Makes sense ofcourse, so just reversing the calls should be fine?

Yes.

>> BTW: There is no ip_ct_death_by_timeout() AFAICT. Can you send a
>> new patch ?
> 
> Sure, what is the prefered form? There are currently two versions of the
> original patch in netfilter SVN: 
> netfilter-ha/patches/nfnetlink-ctnetlink.patch
> and patch-o-matic-ng/nfnetlink-ctnetlink-0.13. Do you prefer a patch 
> against
> any of the patches, a patch replacing any of them, or a patch against the
> patched code? :-)

I prefer a patch against patch-o-matic, changing just this part.
Not sure if it is also needed for the netfilter-ha patch, Krisztian ?

> Also, is there anyone else working on ctnetlink currently, or planning
> to work on it? Is the goal to get it into the standard kernel, and if
> so what must be done before that?

No, we won't try to get it into the kernel. If someone ports it over
to nf_conntrack we will think about it.

Regards
Patrick
