From: Haris Koutsouris <harisk@epmhs.gr>
Subject: Re: netfilter vs iptables naming confusion
Date: Mon, 08 Dec 2003 17:28:57 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD498B9.6000107@epmhs.gr>
References: <Pine.LNX.4.44.0312081257120.10693-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0312081257120.10693-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thank you very much. This clears the picture A LOT.

Regards

Haris

Henrik Nordstrom wrote:

>On Mon, 8 Dec 2003, Haris Koutsouris wrote:
>
>  
>
>><my understanding>
>>Netfilter is a set of hooks in the networking code of the linux kernel
>>  that allows another piece of code (kernel module) to register for 
>>access  to the packets that pass through these points.
>>    
>>
>
>Yes.
>
>  
>
>>Several iptables kernel modules (e.g ip_tables,
>>iptable_mangle,ipt_conntrack, ipt_LOG)  implement the firewalling
>>functionality and in addition the user space utility iptables is used as
>>a user interface to the iptables functionality.
>>    
>>
>
>Many also consider the connection tracking as part of the netfilter
>framework, and maybe even the NAT core in some respect, but it is a thin
>boundary especially considering that it is mainly iptables which use 
>these.
>
>But it is certainly correct to say that netfilter is the hook
>infrastrucure allowing the firewall access to the packet flow, and
>iptables is the firewalling code of iptables.
>
>  
>
>>A final question are the kernel modules named iptables modules or 
>>netfilter modules?????
>>    
>>
>
>There are both. The design is layered with modules at both layers.
>
>modules which registers netfilter hooks are netfilter modules. This
>includes iptables itself and the connection tracking, but there is also
>several other netfilter modules such as Linux Virtual Server or the HiPac
>firewall.
>
>modules which registers iptables targets/matches for use in the iptables
>firewall are iptables modules.
>
>Regards
>Henrik
>
>
>
>
>  
>
