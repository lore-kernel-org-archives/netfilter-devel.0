From: Patrick McHardy <kaber@trash.net>
Subject: Re: possible Bug in ip_conntrack
Date: Mon, 14 Aug 2006 14:50:36 +0200
Message-ID: <44E0719C.9050307@trash.net>
References: <1155545885.44e03b1dcec01@www.domainfactory-webmail.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Maik Hentsche <netfilter@mm-double.de>
In-Reply-To: <1155545885.44e03b1dcec01@www.domainfactory-webmail.de>
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

Maik Hentsche wrote:
> Hi!
> While debugging a new version of conntrackd, I (nearly) every time get
> athe following error "BUG: soft lockup detected on CPU#1!" which
> completely hangs the system. Here is, what I do to reproduce the error:
> I ue keepalived to manage a virtual IP, that is default gw for two other
> machines, which communicate over this IP. I use a client-server-program
> to count connections, which simply opens a tcp-socket and immediately
> closes it. The gateway uses keepalived and conntrackd-0.8.3 for hot
> standby. The HS-master (thta produces the error) has kernel 2.6.18-rc4
> running (with no other patches), the slave is a 2.6.17.3 (also
> vanilla).  I use valgrind --leak-check=yes for debugging. After some
> time, usually between 1 and 5 minutes, the system hangs and writes
> something like this out on the serial console.
> 
> BUG: soft lockup detected on CPU#1!
> Call Trace:
>  <IRQ> [<ffffffff80252bc9>] softlockup_tick+0xf9/0x140
>  [<ffffffff80239367>] update_process_times+0x57/0x90
>  [<ffffffff80216243>] smp_local_timer_interrupt+0x23/0x50
>  [<ffffffff802167a8>] smp_apic_timer_interrupt+0x38/0x40
>  [<ffffffff8020a962>] apic_timer_interrupt+0x66/0x6c
>  <EOI> [<ffffffff8042028d>] _write_lock_irqsave+0x6d/0x90
>  [<ffffffff8042026a>] _write_lock_irqsave+0x4a/0x90
>  [<ffffffff80420416>] _write_lock_bh+0x6/0x20
>  [<ffffffff8811b2a9>] :ip_conntrack:destroy_conntrack+0x69/0x100
>  [<ffffffff88137da6>]
> :ip_conntrack_netlink:ctnetlink_dump_table+0x116/0x160


Can you test current -git please? We had some changes in that area ..
I don't recall any explicit bugfixes, but who knows ..
