From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BUG] Netfilter ipt_owner deadlock
Date: Mon, 17 May 2004 23:55:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40A934DB.8070202@trash.net>
References: <20040517070258.GD26147@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040517070258.GD26147@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Unfortunately I also can't think of a solution except
for marking it broken on SMP ;(

Regards
Patrick

Harald Welte wrote:
> 
> ------------------------------------------------------------------------
> 
> Subject:
> [BUG] Netfilter ipt_owner deadlock
> From:
> Christophe Saout <christophe@saout.de>
> Date:
> Fri, 14 May 2004 17:19:05 +0200
> To:
> linux-net@vger.kernel.org
> 
> To:
> linux-net@vger.kernel.org
> 
> 
> Hi,
> 
> there's a nasty problem with the ipt_owner netfilter code:
> 
> It does a spin_lock(&files->file_lock), sometimes from softirq context.
> This can lead to deadlocks on SMP systems. The lock must not be taken
> from softirq context because the rest of the kernel doesn't use
> spin_lock_bh.
> 
> On a UP machine (that had an SMP compiled kernel) the machine repeatedly
> locked up after approx. five minutes. SysRQ shows backtraces like fput
> -> timer interrupt -> softirq -> ipv4 -> netfilter -> ipt_owner -> hang.
> 
> I don't see a clean solution for this (except for changing all the
> spin_locks to spin_lock_bhs which I think is way too aggressive).
> 
> Any ideas?
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-net" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
