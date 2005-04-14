From: Adrian Turcu <adrian.turcu@gmvinteractive.com>
Subject: CONNMARK behaviour
Date: Thu, 14 Apr 2005 14:47:17 +0100
Message-ID: <200504141447.19432.adrian.turcu@gmvinteractive.com>
Reply-To: adrian.turcu@gmvinteractive.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi,

I have posted the message below to netfilter's user list. I got an answer to 
satisfy my immediate need for to configure my iptables rules. It's just that 
a member of that list suggested to post it here as well in case I suspect it 
as a bug (I'm not 100% sure is a bug but I'm suspicious). The positive answer 
I got is on the message at:

http://marc.theaimsgroup.com/?l=netfilter&m=110894240806358&w=2

What really made me post it here was to ask the question of "How the various 
CONNMARK options work?", aside from the brief description of parameters found 
on netfilter manual in relation to this target. It seems that the connection 
mark set with --set-mark is "reset" if followed by --save-mark. If the mark 
is set at the packet level (by MARK), then --save-mark saves it to the 
connection and restore it as needed. I thought that this marking stuff should 
work at the connection level too.

Just to mention that the behaviour bellow was also tested on 2.6.10 kernel and 
with iptables 1.3.0 as well, but with the same result: most times CONNMARK 
does not preserve the mark when set at connection level and I cannot say why 
it's working when is working. (I mentioned bellow 2.6.11.6 kernel and 1.3.1 
iptables because I want to remain at the latest stable versions).

Thanks in advance,
Adrian


-- snip ; original on netfilter@lists.netfilter.org ---

> I experience some intermittent problems with CONNMARK chain when try to
> conserve the connection mark. Sometimes it works just fine, but sometimes
> it seems that it stops working for whatever reason. Let me explain my setup
> (it's a test environment):
>
>
> outside world | ---- | eth1 Linux_box eth0 | ---- | server
>
> The traffic to the server has to be marked in order to shape it with tc
> (iproute2). Well, I envisage that the rules in iptables will be growing
> fast for the production environment, so I took advise from someone (Wang
> Jiang) on LARTC who suggested to use CONNMARK to skip processing the long
> rules-list for each packet enters/output my Linux box (which is really cool
> stuff). The discussion was there on a different subject, but the problems I
> have are related (I believe) with CONNMARK behaviour.
>
> So, I have the rules as follows:
>
>
> # match 'n' skip already marked traffic
> /sbin/iptables -t mangle -A PREROUTING -m connmark --mark 0x8000/0x8000 \
> 	-j CONNMARK --restore-mark --mask 0xffff
> /sbin/iptables -t mangle -A PREROUTING -m connmark --mark 0x8000/0x8000 \
> 	-j RETURN
> #
> # Assign different marks to different traffic:
> # 192.168.1.218/32 is my server IP address and
> # the traffic refers to Ingress (Egress will be similar)
>
> # create a class :3280x
> /sbin/iptables -t mangle -N class_3280x
> /sbin/iptables -t mangle -A PREROUTING -i eth1 \
> 	-d ! 192.168.1.218/255.255.255.255 -j class_3280x
> # mark the traffic matchin this class and return
> # class :32801	(section 1)
> /sbin/iptables -t mangle -A class_3280x -j CONNMARK --set-mark
> 0x8021/0xFFFF /sbin/iptables -t mangle -A class_3280x -j RETURN
>
> # create a class: 6550x
> /sbin/iptables -t mangle -N class_6550x
> /sbin/iptables -t mangle -A PREROUTING -i eth1 \
> 	-d 192.168.1.218/255.255.255.255 -j class_6550x
> # mark the traffic matching this class and return
> # class 65501 (section 2)
> /sbin/iptables -t mangle -A class_6550x -j CONNMARK --set-mark
> 0xFFDD/0xFFFF /sbin/iptables -t mangle -A class_6550x -j RETURN
>
> # iprtoute2 tc stuff to regulate the traffic
> #
> # Ingress
> /sbin/tc qdisc add dev eth1 handle ffff: ingress
>
> # class :32801 (0x8021)
> /sbin/tc filter add dev eth1 parent ffff: protocol ip prio 10 \
>         u32 match mark 0x8021 0xffff \
>         police rate 512kbit burst 512kbit mtu 1500 drop flowid :1
>
> # class :65501  (0xFFDD)
> /sbin/tc filter add dev eth1 parent ffff: protocol ip prio 10 \
>         u32 match mark 0xFFDD 0xffff \
>         police rate 256kbit burst 256kbit mtu 1500 drop flowid :1
>
>
> Well, I generate some traffic on the network of eth1 to match the above
> rules. I can see first packets (SYN if the rules are applied before the
> connections establishes) matching the iptables rules for each class and
> then the flow is matched by the first 2 rules only (which is what I
> intended to do - skip the rules if traffic already marked). Now, I can also
> see the marked connections using
>
> cat /proc/net/ip_conntrack
>
> which is fine.
>
>
> When this setup works the traffic matches the tc rules, no probs, and it is
> assigned the bandwidth I want. When it doesn't work... the traffic matches
> the iptables rules in the same way when it's working, I can still track the
> connections marks in /proc/net/ip_conntrack, but the tc rules are never
> applied (I can see the stats for tc intercepting the traffic but not
> matching the marks, it's like they are not there).
>
> Some will say that this is related with iproute2 tools, but I have came
> across with this situation: instead of CONNTRACK marking, I do normal MARK
> and save the marks with CONNTRACK (just before RETURN), which means that in
> sections 1 & 2 identified above (for iptables rules) I rewrite the rules
> like this:
>
> /sbin/iptables -t mangle -A class_3280x -j MARK --set-mark 0x8021
> /sbin/iptables -t mangle -A class_3280x -j CONNMARK --save-mark
> /sbin/iptables -t mangle -A class_3280x -j RETURN
>
> respectively,
>
> /sbin/iptables -t mangle -A class_6550x -j MARK --set-mark 0xFFDD
> /sbin/iptables -t mangle -A class_3280x -j CONNMARK --save-mark
> /sbin/iptables -t mangle -A class_6550x -j RETURN
>
> This works always for me, I have try it dozens of time with no problem,
> whilst the --set-mark in CONNTRACK works sometime 1 out of 10 tries or
> never. It looks that setting the mark per connection is not that accurate
> and I need to remark every packet if unmarked? Am I doing something wrong?
>
> I'm using custom built kernel 2.6.11.6 and iptables 1.3.1. This rather
> strange behaviour occurs (for at least I could tell) when restarting the
> linux box and reaplying the rules or just deleting the rules and reaplying
> them again or inserting new matching rules.
>
> Any help will be much appreciated,
> Adrian
