From: Grzegorz Piotr Jaskiewicz <gj@kde.org.uk>
Subject: Re: [PATCH] aggressive early_drop and reserved conntrack entries
Date: Thu, 09 Dec 2004 13:25:37 +0100
Message-ID: <41B84441.7080402@kde.org.uk>
References: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0412090845060.11649@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> Hi,
> 
> The included patch addresses the following issues:
> 
> - When the conntrack table is full, we search only in a single hash
>   bucket. We are in trouble anyway, so let's search harder for
>   droppable entries: the patch extends the search to at most the third of
>   all the buckets.
> - If the conntrack table is full, the remote management of the machine
>   becomes a little bit complicated :-). The patch adds the ability to
>   reserve a given number of entries to be used for management connections.
>   The following proc entries are added to /proc/sys/net/ipv4/netfilter:

That is a good idea, but asside that I think that we need some kind of 
'grabage collector' that is going to remove the oldests connections from 
the hash to make space for those new. This sounds a bit more 
complicated, I know, maybe someone has a better idea about it.
But to be honest letting someone to manage computer remotely is the one 
thing, and letting system to solve the problem on its own is another.
Now that you can get in, tell me what you can do ?
You can resize hash table size for instance, but so can netfilter on its 
own in case hash is filled to the brim.
So there are 2 ideas, either let it resize hash table by some value, but 
that would have it maximum too. You can also forget oldest connections, 
and spare memory for new ones.

-- 
GJ
