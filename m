From: Max Kellermann <max@duempel.org>
Subject: Re: linux 2.6.10: ip_conntrack table overflowing
Date: Tue, 4 Jan 2005 15:50:11 +0100
Message-ID: <20050104145011.GA29076@roonstrasse.net>
References: <20050104124034.GA28010@roonstrasse.net>
	<1104845507.4725.31.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Content-Disposition: inline
In-Reply-To: <1104845507.4725.31.camel@nienna.balabit>
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

On 2005/01/04 14:31, KOVACS Krisztian <hidden@balabit.hu> wrote:
> > later (last night), all of them stopped responding; the conntrack
> > tables were full:
> 
>   Seems to be the problem already reported and fixed by Martin. Take a
> look at
> 
> https://lists.netfilter.org/pipermail/netfilter-devel/2004-December/017908.html

True. That patch solved my problem. Thanks for your help (and Patrick
Schaaf who also sent me this URL). I saw it's already included in
2.6.10-mm1.

Max
