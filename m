From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: module cleanup and timeouts
Date: Mon, 11 Dec 2006 14:44:29 +0100
Message-ID: <457D60BD.60400@netfilter.org>
References: <885896af0612110111v69660248vb65d78358aae5d11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Giacomo <delleceste@gmail.com>
In-Reply-To: <885896af0612110111v69660248vb65d78358aae5d11@mail.gmail.com>
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

I didn't read the full email, just did a really quick look.

Giacomo wrote:
> This works but, when i remove the module from the kernel,
> THERE IS A CRASH if one entry timeouts at the same time
> in which the module is removed.
> 
> [...]
>         tl = list_entry(pos, struct state_table, list);
>         del_timer(&tl->timer_statelist);
	  ^^
check the value returned by del_timer, if the timer is dying then skip 
the destroy process since the callback associated to the timer will do 
the work.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
