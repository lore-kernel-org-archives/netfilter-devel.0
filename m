From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Fri, 08 Apr 2005 16:13:37 +0100
Message-ID: <42569FA1.8060909@ufomechanic.net>
References: <424747D5.8060500@eurodev.net>	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>	<4254265F.6080607@eurodev.net>	<42554200.3020405@ufomechanic.net>	<42555F99.8010201@ufomechanic.net>	<42564BA6.3040702@ufomechanic.net>	<42564FAA.2050302@eurodev.net>	<425658A8.6050200@ufomechanic.net>	<42565AB4.5000803@eurodev.net>	<42567910.4090601@ufomechanic.net>	<42567D15.8090102@eurodev.net>
	<42569E2F.3070802@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42569E2F.3070802@ufomechanic.net>
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

Fix for this was to insert:
source "net/netfilter/Kconfig"

just before:
source "net/ipv4/Kconfig"

in linux-2.6.11.6/net/Kconfig


Sorry to spam you all so much, I'll try and reduce my posting rate.

Sam


Amin Azez wrote:
> The procedure I outline below is not complete;
> 
> I found that I can't set CONFIG_NETFILTER_NETLINK in the config file using
> make xconfig (which I use to sanity check .config done by hand)
> 
> beause of this, IP_NF_CONNTRACK_NETLINK cannot be set, and so 
> ip_conntrack_netlink.c is never compiled.
> 
> CONFIG_NETFILTER_NETLINK is available from 
> linux-2.6.11.6/net/netfilter/Kconfig (as opposed to ipv4/netfilter/Kconfig)
> 
> For some reason it has spaces instead of tabs in it (most Kconfig have 
> tabs) but even if I fix this I still can't get NETFILTER_NETLINK to show 
> in the gui kernel config tools, which indicates something is wrong.
> 
> Amin
