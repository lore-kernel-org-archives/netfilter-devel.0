From: Patrick McHardy <kaber@trash.net>
Subject: Re: Deadlock in netfilter code (ftp-conntrack)
Date: Wed, 11 Aug 2004 15:51:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <411A247E.3020305@trash.net>
References: <20040811132802.GA20963@swift.xantronnet.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20040811132802.GA20963@swift.xantronnet.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Max Kellermann wrote:

>Hi,
>
>I am currently hunting a deadlock bug in the netfilter code on severel
>of our servers. I will provide more information when I can analyze the
>next crash.
>
>Two servers are crashing once a week since we upgraded to 2.6.7
>(2.4.22 before; 2.4.23+ seemed to have a similar problem, though I
>never debugged them). All servers are dual Xeon 2.6 GHz with 2 GB
>memory, CCISS controller. Hyperthreading is enabled, making 4 virtual
>CPUs. I used KDB remotely to debug (the Compaq boxes have a web
>interface with a really ugly applet for remote console access - I have
>no physical access to the servers).
>
>Today, all CPUs except one hung in ip_ct_refresh(), trying to get a
>write lock. The last CPU waited for a spinlock in ip_nat_ftp.c,
>function help(). Unfortunately, KDB crashed before I could find out
>more. On the previous crash, I was able to manually revive the server
>by resetting the spinlock directly in kernel memory with KDB twice.
>
>Is this a known bug in netfilter?
>  
>
There is a known deadlock condition in the ftp/irc helper which
matches your description. Please try the helper-locking-fix from
patch-o-matic-ng and let us know if it helped.

Regards
Patrick
