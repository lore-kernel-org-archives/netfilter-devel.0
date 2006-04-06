From: Patrick McHardy <kaber@trash.net>
Subject: Re: Multiple programs for QUEUE target
Date: Thu, 06 Apr 2006 12:57:35 +0200
Message-ID: <4434F41F.3020509@trash.net>
References: <859616420604040655h6312ac86g3c8661c29bf4c7e5@mail.gmail.com>	<859616420604040702g1e74bcacr2115fb36e0e7298e@mail.gmail.com>	<20060405152409.GH20558@sunbeam.de.gnumonks.org>
	<859616420604060350q379873b4j5b7e27c71958b93b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: David Vogt <beunlovable@gmail.com>
In-Reply-To: <859616420604060350q379873b4j5b7e27c71958b93b@mail.gmail.com>
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

David Vogt wrote:
> 2006/4/5, Harald Welte <laforge@netfilter.org>:
> 
>>On Tue, Apr 04, 2006 at 04:02:41PM +0200, David Vogt wrote:
>>Please don't use any of that old 'crap' (I'm the author, so I can call
>>it that).  These days, you use NFQUEUE, nf_queue, nfnetlink_queue,
>>libnetfilter_queue, and you get up to 65535 distinct queues for
>>different userespace processes.
> 
> 
> Is it possible to run libnetfilter_queue and libipq (for old
> applications) in parallel? I did some testing and it doesn't seem to
> work.

Only a single queue handler can register for an address family inside
the kernel, so most likely one of them is simply not receiving any
packets. There is an ipq compat library for nfnetlink_queue, I'm not
sure but I think you should be able to use those in parallel.
