From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Conntrack proc interface for tuple removal
Date: Thu, 19 May 2005 05:10:28 +0200
Message-ID: <428C03A4.7060401@eurodev.net>
References: <11148.217.169.232.210.1115923639.squirrel@hupie.xs4all.nl>	<4284378B.8080401@eurodev.net>
	<428A151E.9090107@ufomechanic.net>
	<Pine.LNX.4.58.0505180847060.9582@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <Pine.LNX.4.58.0505180847060.9582@blackhole.kfki.hu>
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
> On Tue, 17 May 2005, Amin Azez wrote:
> 
> 
>>Pablo Neira wrote:
>>
>>>- READ_LOCK'ing while trying to delete a conntrack is racy, you must use
>>>write_lock instead. Someone else could be reading the conntrack table
>>>while you try to delete a conntrack.
>>>- check the value returned by del_timer, currently racy as well.
>>>- Deadlock on SMP: calling conntrack->timeout.function
>>>(death_by_timeout) is illegal if you've got ip_conntrack_lock.
>>
>>Where should one read to learn about the rules and intricacies of such
>>locking dependancies.
> 
> 
> Rusty's 'Unreliable Guide To Locking' is an excellent paper on the locking
> issues in the Linux kernel.

Robert Love has also written some stuff about this. Look for "Kernel 
locking techniques". It could help you out together with Rusty's stuff.

--
Pablo
