From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: question regarding iptables tuning (was Re: iptables denial of
 services)
Date: Sat, 17 Apr 2004 20:18:51 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404172007210.22427-100000@filer.marasystems.com>
References: <408167F2.9060501@fl.priv.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <408167F2.9060501@fl.priv.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 17 Apr 2004, Friedrich Lobenstock wrote:

> Thanks, but can you give some background info about the hash size parameter 
> of ip_conntrack as the description on the page above is rather lacking any 
> reasons:
> - Is this parameter automatically sized according to the amount of
>    installed memory?

Yes.

> - How is it related to ip_conntrack_max?

ip_conntrack_max = 8 * hah_size

> - What's the amount of memory that is allocated based on this
>    parameter?

Depends a little on what conntrack & nat helpers etc you enabled when the
kernel is built. In my kernel each conntrack currently uses ca 384 bytes, 
most others probably use less..

The amount of memory allocated based on the hash size is pretty marginal, 
what one needs to keep track of is the total number of connections as this 
is the bulk of the memory usage.

As for suggested defaults: If this is a general purpose server then the
automatic defaults. On a dedicated firewall scale the memory and conntrack
based on how many concurrent sessions you need to support but I would not
recommend to assign more than 50% of your memory to conntrack.

Regards
Henrik
