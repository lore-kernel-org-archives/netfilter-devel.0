From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: problem in iptables!!!
Date: Tue, 11 Apr 2006 10:04:20 +0900 (JST)
Message-ID: <200604110104.k3B14K6U026702@toshiba.co.jp>
References: <443A5907.7000202@rocsys.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: varun@rocsys.com
In-Reply-To: <443A5907.7000202@rocsys.com>
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

From: varun <varun@rocsys.com>
Date: Mon, 10 Apr 2006 18:39:27 +0530

> Hi all,
> 
>              I have a small problem with iptables. Iam trying to use 
> iptables in an Cyberton Board (ARM). I compiled it with ucLibc. and i 
> also put the images on the board. Then when board comes up i manually 
> insmoded the following modules.
> 
> ip_conntrack.ko    ipt_REJECT.ko      ipt_state.ko
> ip_tables.ko       ipt_conntrack.ko   iptable_filter.ko
> 
> Then i tried to add a policy
>                       iptables -t filter -A OUTPUT -j REJECT
>  This works well in my PC with the 2.6 kernel but gives this error on 
> the same kernel arm compiled.
>                       The error i get is
>                       iptables v1.2.11: Couldn't find target `REJECT'
> 
>                        Try `iptables -h' or 'iptables --help' for more 
> information.

This message means that shared library libipt_REJECT.so isn't not found.

> Can someone tell me what is wrong?

I think that you didn't install shared libraries for matches/targets
to your image even though you build iptables without statically linking
them.

If so, you have 2 options.
	- You can install them to /usr/local/lib/iptables (or path you
	  specified clearly when building iptables) on image.

	- You can build iptables statically linking them by
	  'make NO_SHARED_LIBS=1' .

-- Yasuyuki Kozakai
