From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] Conntrack proc interface for tuple removal
Date: Tue, 17 May 2005 17:00:30 +0100
Message-ID: <428A151E.9090107@ufomechanic.net>
References: <11148.217.169.232.210.1115923639.squirrel@hupie.xs4all.nl>
	<4284378B.8080401@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4284378B.8080401@eurodev.net>
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

Pablo Neira wrote:
> - READ_LOCK'ing while trying to delete a conntrack is racy, you must use 
> write_lock instead. Someone else could be reading the conntrack table 
> while you try to delete a conntrack.
> - check the value returned by del_timer, currently racy as well.
> - Deadlock on SMP: calling conntrack->timeout.function 
> (death_by_timeout) is illegal if you've got ip_conntrack_lock.

Where should one read to learn about the rules and intricacies of such 
locking dependancies.

Amin
