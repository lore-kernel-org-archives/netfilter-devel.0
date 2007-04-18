From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.20.4] Connection tracking: New SIP ALG that actually
 works
Date: Wed, 18 Apr 2007 20:32:25 +0200
Message-ID: <46266439.2060805@trash.net>
References: <4625334F.40308@kenati.com> <4625A2F9.3030502@trash.net>
	<46265B28.2020501@kenati.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Ranjit Deshpande <ranjit@kenati.com>, netfilter-devel@lists.netfilter.org
To: Carlos Munoz <carlos@kenati.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46265B28.2020501@kenati.com>
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

Carlos Munoz wrote:
> Patrick McHardy wrote:
> 
>> What you should have done is report the problems you were seeing or send
>> patches for the existing version. We're not going to just toss in a
>> huge rewritten version, especially not since you're reintroducing
>> a lot of bugs and do lots of things that only work on 2.4.
>
> 
> I understand. We've had our sip alg before one was distributed with the
> kernel sources. When we upgrade to new kernel versions we regression
> test all features and the sip alg has always failed. So we keep using
> our sip alg. Management won't allocate resources to fix the sip alg in
> the kernel when ours works. However, that might change if our sip alg
> stops working.


I see. It will stop working in 2.6.22 since we're going to remove
ip_conntrack, so you will at least have to port it to nf_conntrack
when you upgrade your kernel. Of course it would be very much
appreciated if you can convince your management to fix the version
in the kernel instead :)
