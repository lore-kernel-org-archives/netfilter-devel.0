From: Wang Jian <lark@linux.net.cn>
Subject: Re[2]: bidirectional CONNMARK?
Date: Wed, 09 Mar 2005 17:54:51 +0800
Message-ID: <20050309174657.A56E.LARK@linux.net.cn>
References: <20050309124806.A55C.LARK@linux.net.cn>
	<Pine.LNX.4.61.0503091019020.6780@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0503091019020.6780@filer.marasystems.com>
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

Hi Henrik Nordstrom,

Below is a test script, which uses mark/mask to do bi-directional
control. I just craft it and haven't test it yet. (Need to compile a new
iptables in the test bed, later)

Jesse <jesse@deansoft.com.tw> tells me off-list that he has a CTDIRMARK
target based on CONNMARK. Looking forward to his code for easier use.


--snip--
#!/bin/sh

CLEAR="iptables -F PREROUTING -t mangle"
IPT="iptables -A PREROUTING -t mangle"
IPTIN="iptables -A INBOUND -t mangle"
IPTOUT="iptables -A OUTBOUND -t mangle"

$CLEAR

iptables -N INBOUND -t mangle
iptables -N OUTBOUND -t mangle

# Start
$IPT -i eth1 -m connmark --mark 0x80000000/0x80000000 \
        -j CONNMARK --restore-mark --mask 0x7FFF0000
$IPT -i eth1 -m connmark --mark 0x80000000/0x80000000 -j RETURN

$IPT -i eth0 -m connmark --mark 0x00008000/0x00008000 \
        -j CONNMARK --restore-mark --mark 0x00007FFF
$IPT -i eth0 -m connmark --mark 0x00008000/0x00008000 -j RETURN

# End with default to prevent rule traversal
$IPT -i eth1 -j INBOUND
$IPT -i eth1 -m connmark --mark ! 0x80000000/0x80000000 \
        -j CONNMARK --set-mark  0x80000000/0x8FFF0000
$IPT -i eth1 -j RETURN

$IPT -i eth0 -j OUTBOUND
$IPT -i eth0 -m connmark --mark ! 0x00008000/0x00008000 \
        -j CONNMARK --set-mark  0x00008000/0x00008FFF
$IPT -i eth0 -j RETURN

# Classes
$IPTOUT -p tcp --sport 80 -j CONNMARK --set-mark 0x80030000/0xFFFF0000
$IPTOUT -p tcp --sport 80 -j RETURN



On Wed, 9 Mar 2005 10:24:50 +0100 (CET), Henrik Nordstrom <hno@marasystems.com> wrote:

> On Wed, 9 Mar 2005, Wang Jian wrote:
> 
> > What is the CONNMARK's purpose?
> 
> To act as a decision memory on the connection. What you use this memory 
> for is up to you.
> 
> > I think it is to reduce rule traversal,
> 
> This is one of many applications.
> 
> The --save-mark/--restore-mark options to CONNMARK should be seen as a 
> bonus. It is not the main purpose of CONNMARK. The main purpose of 
> CONNMARK is to act as a connection oriented state memory, allowing you to 
> remember an earlier decision about something on later packets in the same 
> session.
> 
> > But an issue occurs, when we want to set 2 different marks for a single
> > session in two directions.
> 
> Then you need to structure the use of CONNMARK differently, and depending 
> on the direction set different marks.
> 
> > When doing QoS control as an router between two or more interfaces,
> > bi-directional control is neccessary. Since nfmark is the most
> > convenient way to classify packet, should we extend CONNMARK to support
> > two marks?
> 
> If it helps you in reducing your ruleset, why not? Adjusting the tools to 
> your needs is one of the cornerstones of using Open Source software.
> 
> But I don't think it is generally suitable for CONNMARK.
> 
> Regards
> Henrik



-- 
  lark
