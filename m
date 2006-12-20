From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: problems building conntrack w/ uclibc - no output
Date: Wed, 20 Dec 2006 12:01:14 +0100
Message-ID: <458917FA.2080406@netfilter.org>
References: <200611221144.00766.alan.ezust@presinet.com>
	<200612081043.59816.alan.ezust@presinet.com>
	<457CB353.1010409@netfilter.org>
	<200612191557.43981.alan.ezust@presinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alan Ezust <alan.ezust@presinet.com>
In-Reply-To: <200612191557.43981.alan.ezust@presinet.com>
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

Alan Ezust wrote:
> Anyway, I'm still not quite sure what my problem is with building conntrack.
> I have an older executable that I somehow built successfully, and I can make  
> my currently needed changes to libnetfilter_conntrack and run the original 
> executable against my patched versions, so I am able to proceed for now, but 
> it would be so nice to know why my conntrack builds are always creating 
> executables that HANG here:
 >
> libnetfilter_conntrack.c
> int nfct_event_conntrack(struct nfct_handle *cth)
> {
> 	cth->handler = nfct_conntrack_netlink_handler;
> 	return nfnl_listen(cth->nfnlh, &callback_handler, cth); // NEVER RETURNS FROM 
> HERE
> }

It's *not* hanging, nfnl_listen blocks waiting to receive events from 
kernel space, this is the *expected behaviour*. Make sure you have 
enabled the conntrack event API.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
