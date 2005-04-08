From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Fri, 08 Apr 2005 16:54:17 +0100
Message-ID: <4256A929.6080601@ufomechanic.net>
References: <424747D5.8060500@eurodev.net>	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>	<4254265F.6080607@eurodev.net>	<42554200.3020405@ufomechanic.net>	<42555F99.8010201@ufomechanic.net>	<42564BA6.3040702@ufomechanic.net>	<42564FAA.2050302@eurodev.net>	<425658A8.6050200@ufomechanic.net>	<42565AB4.5000803@eurodev.net>	<42567910.4090601@ufomechanic.net>	<42567D15.8090102@eurodev.net>	<42569E2F.3070802@ufomechanic.net>
	<42569FA1.8060909@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42569FA1.8060909@ufomechanic.net>
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

Now ip_conntrack_netlink.ko is being build, but modprobe fails, dmesg shows:

ip_conntrack_netlink: Unknown symbol __nfa_fill
ip_conntrack_netlink: Unknown symbol nfnetlink_subsys_register
ip_conntrack_netlink: Unknown symbol nfnetlink_subsys_alloc
ip_conntrack_netlink: Unknown symbol nfnetlink_send
ip_conntrack_netlink: Unknown symbol nfnetlink_subsys_unregister
ip_conntrack_netlink: Unknown symbol nfnetlink_check_attributes


Some of these at least (but not nfa_fill) are defined in:
net/netfilter/nfnetlink.c which, is not built to a .o file either

No doubt similar magic used to link in net/netfilter/Kconfig is to be 
used to link in net/netfilter/Makefile, let me discover the spell
[slight pause while Amin "discovers" the spell]

OK, I inserted:

just before:

(I'm not doing 1-liner patches when there is a good chance someone will 
want to move the position of the line, cos I just guessed where to put it)

now, try:
# modprobe nfnetlink
FATAL: Error inserting nfnetlink 
(/lib/modules/2.6.11.6/kernel/net/netfilter/nfnetlink.ko): Operation not 
permitted
# dmesg -c
Netfilter messages via NETLINK v0.12.
cannot initialize nfnetlink!

bah, that would be nfnetlink.c:
         nfnl = netlink_kernel_create(NETLINK_NETFILTER, nfnetlink_rcv);
         if (!nfnl) {
                 printk(KERN_ERR "cannot initialize nfnetlink!\n");
                 return -1;
         }

OK, I'll keep looking, but I thought it important to log the omissions 
in net/Kconfig and net/Makefile which fail to bring in 
net/netfilter/Kconfig and net/netfilter/Makefile

Amin

Amin Azez wrote:
> Fix for this was to insert:
> source "net/netfilter/Kconfig"
> 
> just before:
> source "net/ipv4/Kconfig"
> 
> in linux-2.6.11.6/net/Kconfig
> 
> 
> Sorry to spam you all so much, I'll try and reduce my posting rate.
> 
> Sam
> 
> 
> Amin Azez wrote:
> 
>> The procedure I outline below is not complete;
>>
>> I found that I can't set CONFIG_NETFILTER_NETLINK in the config file 
>> using
>> make xconfig (which I use to sanity check .config done by hand)
>>
>> beause of this, IP_NF_CONNTRACK_NETLINK cannot be set, and so 
>> ip_conntrack_netlink.c is never compiled.
>>
>> CONFIG_NETFILTER_NETLINK is available from 
>> linux-2.6.11.6/net/netfilter/Kconfig (as opposed to 
>> ipv4/netfilter/Kconfig)
>>
>> For some reason it has spaces instead of tabs in it (most Kconfig have 
>> tabs) but even if I fix this I still can't get NETFILTER_NETLINK to 
>> show in the gui kernel config tools, which indicates something is wrong.
>>
>> Amin
> 
> 
> 
> 
