From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH][v3] netfilter: use kvmalloc_array to allocate memory for
 hashtable
Date: Fri, 3 Aug 2018 18:37:16 +0200
Message-ID: <20180803163716.7ut6zdlwoyswha6t@salvia>
References: <1532505133-9398-1-git-send-email-lirongqing@baidu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, kadlec@blackhole.kfki.hu, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        edumazet@google.com
To: Li RongQing <lirongqing@baidu.com>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1532505133-9398-1-git-send-email-lirongqing@baidu.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Jul 25, 2018 at 03:52:13PM +0800, Li RongQing wrote:
> nf_ct_alloc_hashtable is used to allocate memory for conntrack,
> NAT bysrc and expectation hashtable. Assuming 64k bucket size,
> which means 7th order page allocation, __get_free_pages, called
> by nf_ct_alloc_hashtable, will trigger the direct memory reclaim
> and stall for a long time, when system has lots of memory stress
> 
> so replace combination of __get_free_pages and vzalloc with
> kvmalloc_array, which provides a overflow check and a fallback
> if no high order memory is available, and do not retry to reclaim
> memory, reduce stall

Applied, thanks.
