From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] libnetfilter_queue naming problem
Date: Wed, 26 Oct 2005 10:14:38 +0200
Message-ID: <435F3AEE.6040801@eurodev.net>
References: <1130312714.4872.57.camel@localhost.localdomain>	<435F370A.6040703@eurodev.net>
	<1130313725.14426.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1130313725.14426.4.camel@localhost.localdomain>
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

Eric Leblond wrote:
>>>I don't like the fact that it uses "struct nfattr* nfa[]" as parameter
>>>for high-level function because it is too much linked with the kernel
>>>implementation. But I do not have much time to find and propose a more
>>>elegant solution. Any idea ?
>>
>>We can provide a higher level interface abstracted from the netlink 
>>sockets, let me see if I can do something.
> 
> Great ! I've thought about adding a simple opaque structure which
> encapsulate "struct nfattr* nfa[]". That should be enough as high level
> functions are already available.

Yes, I think that's the way to go. That's how libnetfilter_conntrack is 
currently doing things.

cheers,
Pablo
