From: Pablo Neira <pablo@eurodev.net>
Subject: Re: sparc64 match module - bug id 94
Date: Thu, 06 May 2004 16:56:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <409A521C.5020406@eurodev.net>
References: <Pine.LNX.4.44.0405061211230.29759-100000@filer.marasystems.com> <1083852576.1822.18.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1083852576.1822.18.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Krisztian,

KOVACS Krisztian wrote:

>  A possible hack: let's define two separate structures, one for
>in-kernel use, and one for the userspace.
>  
>

I thought about that possibility, it's an interesting hack, but I think 
that the problem is much more specific, we have only this problem with 
ipt_limit. Actually, when we have some internal match information which 
is shared by some processors, we need to know which one is the selected 
to work with. So, we could add a pointer to the master of internal match 
data in struct ipt_entry_match. what do you think?

regards,
Pablo
