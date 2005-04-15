From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: CONNMARK behaviour
Date: Fri, 15 Apr 2005 02:31:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504150220340.3687@filer.marasystems.com>
References: <200504141447.19432.adrian.turcu@gmvinteractive.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Adrian Turcu <adrian.turcu@gmvinteractive.com>
In-Reply-To: <200504141447.19432.adrian.turcu@gmvinteractive.com>
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

On Thu, 14 Apr 2005, Adrian Turcu wrote:

> What really made me post it here was to ask the question of "How the various
> CONNMARK options work?", aside from the brief description of parameters found
> on netfilter manual in relation to this target. It seems that the connection
> mark set with --set-mark is "reset" if followed by --save-mark. If the mark
> is set at the packet level (by MARK), then --save-mark saves it to the
> connection and restore it as needed. I thought that this marking stuff should
> work at the connection level too.

You can only use on of --set-mark or --save-mark at a time.

--set-mark sets the connection mark to the given value.

--save-mark sets the connection mark to the same as the packet mark (set 
by MARK or other means)

--restore-mark is the opposite of --set-mark, copies the connection mark 
to the packet mark similar to the MARK target.

> Just to mention that the behaviour bellow was also tested on 2.6.10 kernel and
> with iptables 1.3.0 as well, but with the same result: most times CONNMARK
> does not preserve the mark when set at connection level and I cannot say why
> it's working when is working.

The connection mark is distinct from the packet mark. They have no 
relation other than that CONNMARK --save/restore-mark can copy one to the 
other if you desire.

The intention of the --save/restore-mark options is that you

1. When the session is NEW set the desired connection mark with CONNMARK 
--set-mark.

2. On all packets (including NEW), copy the connection mark to the packet 
mark by CONNMARK --restore-mark.

Or alternatively you

1. On NEW packets set the mark with MARK, then CONNMARK --save-mark to 
remember it for the next packet in the session.

2. On other packets use CONNMARK --restore-mark.

>> # match 'n' skip already marked traffic
>> /sbin/iptables -t mangle -A PREROUTING -m connmark --mark 0x8000/0x8000 \
>> 	-j CONNMARK --restore-mark --mask 0xffff
>> /sbin/iptables -t mangle -A PREROUTING -m connmark --mark 0x8000/0x8000 \
>> 	-j RETURN

ok.

>> #
>> # Assign different marks to different traffic:
>> # 192.168.1.218/32 is my server IP address and
>> # the traffic refers to Ingress (Egress will be similar)
>>
>> # create a class :3280x
>> /sbin/iptables -t mangle -N class_3280x
>> /sbin/iptables -t mangle -A PREROUTING -i eth1 \
>> 	-d ! 192.168.1.218/255.255.255.255 -j class_3280x
>> # mark the traffic matchin this class and return
>> # class :32801	(section 1)
>> /sbin/iptables -t mangle -A class_3280x -j CONNMARK --set-mark
>> 0x8021/0xFFFF /sbin/iptables -t mangle -A class_3280x -j RETURN
>>
>> # create a class: 6550x
>> /sbin/iptables -t mangle -N class_6550x
>> /sbin/iptables -t mangle -A PREROUTING -i eth1 \
>> 	-d 192.168.1.218/255.255.255.255 -j class_6550x
>> # mark the traffic matching this class and return
>> # class 65501 (section 2)
>> /sbin/iptables -t mangle -A class_6550x -j CONNMARK --set-mark
>> 0xFFDD/0xFFFF /sbin/iptables -t mangle -A class_6550x -j RETURN

You are missing to set the packet mark here. Only the connection mark is 
set by the above CONNMARK --set-mark .... You either need a MARK or 
CONNMARK --restore-mark to set the packet mark on these packets.

Regards
Henrik
