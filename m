From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Side effect? - Re: Changing the content of tcp timeouts in ip_conntrack_proto_tcp.c
Date: Thu, 15 Jan 2004 10:26:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40064EA0.3050603@netlab.hut.fi>
References: <Pine.LNX.4.44.0401141203530.29640-100000@filer.marasystems.com>	 <40053873.6000806@netlab.hut.fi> <1074084643.15865.6.camel@nienna.balabit> <400542BD.6050706@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

I was a bit optimistic in my last e-mail. Compilation is totally ok, 
insertion of the modules in the kernel seems to go fine... until I want 
to use them. The nat table does not work anymore.
The ip_tables module seems to be there:
pc104:# iptables -L   
Chain INPUT (policy ACCEPT)
target     prot opt source               destination        

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination        

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination  

But if I try the nat table:
pc104:# iptables -t nat -L
modprobe: Can't locate module ip_tables
iptables v1.2.9: can't initialize iptables table `nat': Table does not 
exist (do you need to insmod?)
Perhaps iptables or your kernel needs to be upgraded.

If I do not add my function in ip_conntrack_standalone.c, everything's 
ok (well except that I can't use my funciton of course).
To be very precise I just added the following:

In ip_conntrack_standalone.c:
EXPORT_SYMBOL(ip_ct_proto_tcp_set_timeouts);

In ip_conntrack.h:
extern void ip_ct_proto_tcp_set_timeous(/datatypes/);

In ip_conntrack_proto_tcp.c:
void ip_ct_proto_tcp_set_tcp_timeouts(unsigned long new_value, ...)
{
    ...
    ip_ct_tcp_timeout_established = new_value SECS;
    ...
}

And the calls to the function in ipt_MY_TARGET.c:
ip_ct_proto_tcp_set_timeouts(/values/);


What do I do wrong?

           Emmanuel



Emmanuel Guiton wrote:

> KOVACS Krisztian wrote:
>
>>  Hi,
>>
>> On Wed, 2004-01-14 at 13:39, Emmanuel Guiton wrote:
>>  
>>
>>>> Looks like you have not exported this function from ip_conntrack. 
>>>> To use a function from another module than it is defined in the 
>>>> function must first be exported from the module where it is defined.
>>>>     
>>>
>>> Well, I think I did. I defined my function in the 
>>> ip_conntrack_proto_tcp.c and I exported its prototype in 
>>> ip_conntrack.h.
>>> Then I call it in my target module which also uses ip_conntrack.h.
>>>   
>>
>>
>>  You have to explicitly export it using the EXPORT_SYMBOL() (or
>> EXPORT_SYMBOL_GPL) macro in ip_conntrack_standalone.c. It has a lot of
>> other exported symbols, just add another one.
>>
>>  
>>
> Right, it's working now.
> Thanks!
>
>           Emmanuel
>
