From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: check timer active
Date: Sat, 4 Dec 2004 15:55:54 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0412041554150.14126@filer.marasystems.com>
References: <EINSTEINLVbNDN4CxpA000066fb@einstein.systemmetrics.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Richard <richard@o-matrix.org>
In-Reply-To: <EINSTEINLVbNDN4CxpA000066fb@einstein.systemmetrics.com>
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

On Thu, 2 Dec 2004, Richard wrote:

> It looks like that there are two ways to check if a timer for conntrack is
> active or not.
>
> ct->timeout->list.next != NULL
>
> test_bit(IPS_CONFIRMED_BIT, &ct->status)

These two tests for slightly different things

The first checks that there is a timeout.

The second checks that the conntrack entry is active (in the hash table 
etc...).

The two is at most if not all times equal as all active conntrack entries 
have a timeout of some sort, but maybe it is possible for the timeout to 
be established before the conntrack becomes confirmed or something..

Regards
Henrik
