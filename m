From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: More on LIST_DELETE message with kernels 2.4.23 through 2.4.25
Date: Thu, 25 Mar 2004 18:40:55 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403251839120.19747-100000@filer.marasystems.com>
References: <1080231132.1650.14.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Vijaya Chandra Vupputuri <vijay@tachyontech.net>,
   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1080231132.1650.14.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 25 Mar 2004, KOVACS Krisztian wrote:

>   I think the patch is buggy. The check should be
> 
>   if (!(info->initialized & (1 << maniptype))
>       && !(ct->status & IPS_CONFIRMED))
> 
> instead of
> 
>   if (!(info->initialized & (1 << maniptype))
>       && ct->status & IPS_CONFIRMED)


Indeed. I must have been a bit sleepy when I wrote that first patch..

Regards
Henrik
