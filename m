From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: Waiting for user space response in Kernel Mode
Date: Mon, 05 Dec 2005 10:52:26 +0100
Message-ID: <43940DDA.3050908@eurodev.net>
References: <20051205094858.34850.qmail@web36409.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Guru Prasad <guru_netfilter@yahoo.com>
In-Reply-To: <20051205094858.34850.qmail@web36409.mail.mud.yahoo.com>
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

Guru Prasad wrote:
> I am a newbie to Kernel and Netfilter development.
>   
> When a new connection with specific parameters (for
> example a certain destination IP address) is created,
> I would like to indicate this event to a daemon
> process in user space which takes some decision before
> proceeding. I detect this event from 
> ip_conntrack_netlink.c in the following function.
>   
>   int ctnetlink_conntrack_event(struct notifier_block 
> *this,                                     
> unsigned long events, void *ptr) -->    "if (events & 
> (IPCT_NEW | 
> IPCT_RELATED)) {"
>   
> When I detect a new connection,I tried to use
> Wait_queues and call schedule() so that I could wait
> on this process before receiving response from user
> space, but using this mechanism leads to crashes. It
> seems that one can only use this mechanism (wait
> queues and schedule)  when a process is executing in
> the context of a user space application.  

Yes, ctnetlink_conntrack_event is always called from interrupt context.
Don't do that in kernelspace. Use libnetfilter_conntrack and work in
userspace please.

-- 
Pablo
