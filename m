From: serjio <serjio@tajik.net>
Subject: Re: Is this an ULOG error?
Date: Wed, 02 Feb 2005 14:30:02 +0500
Message-ID: <42009D9A.9080309@tajik.net>
References: <41FF2188.3040300@tajik.net>
	<20050201134607.GN6878@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050201134607.GN6878@sunbeam.de.gnumonks.org>
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

Hello Harald,


>>I would like to use ULOG and ULOGD for traffic accounting. 
>>    
>>
>
>This is not what ULOG is meant for.But after I have installed these tools on my router I was surprised
>that I cannot check my traffic with 100% accuracy.
>  
>
>
>Please give more information, such as exact kernel version, exact ulogd
>version, any patches you might be using, ...
>  
>
Please look at the below description of what I am using:
kernel 2.6.2-rc3
ulogd ver 1.02
CPU: Intel(R) Pentium(R) 4 CPU 2.40GHz
RAM: 256M
Network loading is about 500K per sec.
We are ISP and using this server as our primary shaper.

I found this problem when I used a fresh 2.6.10 kernel without any 
patches as well.


>>I think that there are some problems in transmit data via kernel socket 
>>to userspace.
>>    
>>
>
>probably.  even if your buffers are large enough - if the system
>forwards more packets than it is able to ULOG, then you will have holes
>in your logs.  ULOG is best-effort.
>
>  
>
I added to the ipt_ULOG.c file some debug information just after 
netlink_broadcast function.

ret = netlink_broadcast(nflognl, ub->skb, 0, (1 << nlgroupnum), GFP_ATOMIC);
if(ret!=0){
     PRINTR("%s\n  throwing %d packets","ipt_ULOG:netlink_broadcast 
error",ub->qlen);
};


And I didn't get any errors from this function.
So for my mind information is lost somewhere in the way between ulog 
kernel module
and  ulogd daemon.
What do you think if I will change ULOG module so it will send data via 
proc fs?
Can it solve a problem with lost data?

>>Changing a socket network buffer size up to 4M didn't help me.
>>
>>sysctl -w net.core.rmem_max=8388608
>>    
>>
>>sysctl -w net.core.rmem_default=4194304
>>sysctl -w net.core.wmem_max=8388608
>>sysctl -w net.core.wmem_default=4194304
>>    
>>
>
>there are multiple buffers involved, please see the ulogd documentation.
>  
>
Unfortunatelly I didn't find any related. There is only one place in the 
ulogd daemon
when ulogd is receiving a data from ulog.
Look at the below code:
libipulog.c:81      status = recvfrom(h->fd, buf, len, 0, (struct 
sockaddr *)&h->peer,&addrlen);

How I can trace this way between call netlink_broadcast function and 
recvfrom in the ulogd daemon?
I would be grateful for any suggestions, information links or hints etc.

Thanks,
Sergei Filippov
