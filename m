From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [BUG] ipt_SAME rule can't be deleted
Date: Tue, 07 Dec 2004 13:27:51 +0100
Message-ID: <41B5A1C7.5060608@eurodev.net>
References: <20041204150223.GA10247@dfbbb.opencjk.org>
	<Pine.LNX.4.61.0412060821280.10926@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Fang Han <fanghan@opencjk.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0412060821280.10926@filer.marasystems.com>
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

Henrik Nordstrom wrote:

> On Sat, 4 Dec 2004, Fang Han wrote:
>
>> Kernel 2.6.9 ac2
>>
>> Using the next test command:
>>
>> /sbin/iptables  -t nat -I POSTROUTING -s 192.168.100.23 -o eth0 -j 
>> SAME --to 192.168.1.60
>> /sbin/iptables  -t nat -D POSTROUTING -s 192.168.100.23 -o eth0 -j 
>> SAME --to 192.168.1.60
>>
>> generate error:
>> iptables: Bad rule (does a matching rule exist in that chain?)
>
>
> This is quite likely due to that kernel land pointer within the target 
> info...
>
>         u_int32_t *iparray;
>
> If I am right the same problem applies to -m limit and any other 
> extension storing private kernel side stuff within it's info data..


Right, we bite the dust when having pointers within the target private 
info... If we try to remove a rule, it won't match the existing because 
in user space that pointer is set to NULL, but in kernel space is set to 
whatever kmalloc reserved the space for us.

In iptables, target_difference() complains because, in the case of 
ipt_same, iparray isn't NULL. Same thing with iplimit. I think that in 
pkttables we need a private info part for match/targets which is not 
shared with user space.

--
Pablo
