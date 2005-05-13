From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] Conntrack proc interface for tuple removal
Date: Fri, 13 May 2005 07:13:47 +0200
Message-ID: <4284378B.8080401@eurodev.net>
References: <11148.217.169.232.210.1115923639.squirrel@hupie.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: ferry@Hupie.com
In-Reply-To: <11148.217.169.232.210.1115923639.squirrel@hupie.xs4all.nl>
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

Ferry Huberts wrote:
> I badly needed to be able to remove conntrack tuple because of some very
> dynamic application behaviour, so I wrote a patch.
> Hope it lives up to your standards, I find it quite usefull :-)
> 
> The patch is based on work from Yutaka Kondo.
> 
> The patch is against 2.4.30 since that is the kernel I'm using, haven't
> looked into applying it against 2.6.x.y

You should do this with ctnetlink. It actually provides a more flexible 
interface to user space applications: I mean, more actions like 
creation, update, deletion, whatever... instead of doing this via /proc. 
Have a look at the conntrack tool in netfilter SVN.

BTW, some comments about your patch:

- READ_LOCK'ing while trying to delete a conntrack is racy, you must use 
write_lock instead. Someone else could be reading the conntrack table 
while you try to delete a conntrack.
- check the value returned by del_timer, currently racy as well.
- Deadlock on SMP: calling conntrack->timeout.function 
(death_by_timeout) is illegal if you've got ip_conntrack_lock.

--
Pablo
