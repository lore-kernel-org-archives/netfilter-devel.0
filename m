From: "Samuel Jean" <jix@bugmachine.ca>
Subject: Re: iptables match rule for DNS RR?
Date: Wed, 4 Apr 2007 13:49:28 -0000
Message-ID: <twig.1175694568.67940@bugmachine.ca>
References: <20070404131825.GB20515@kallisti.us>
Reply-To: jix@bugmachine.ca
To: "Ross Vandegrift" <ross@kallisti.us>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070404131825.GB20515@kallisti.us>
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

On Wed, Apr 4, 2007, Ross Vandegrift <ross@kallisti.us> said:

> Hi everyone,

Hi!

> 
> Is there any netfilter work, either production or in development, that
> provides a way to filter traffic based on DNS RR type?

Sorry -- matching packets based on RR is not possible inside the kernel.
Netfilter needs to make a decision pretty fast and cannot wait for DNS
queries
each time a packet passes by. IMO, this makes huge sense.

However, it's possible to queue packets and let userspace tools handle the
decision. That's where such match should be implemented. Still, the
latency remains the same.

> 
> Thanks in advance for any info,
> 
> Ross
>

HTH,
Samuel
