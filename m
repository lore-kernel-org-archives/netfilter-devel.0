From: zhi wang <pangy2004@yahoo.com>
Subject: LIST_DELETE bug tracked
Date: Wed, 31 Mar 2004 06:58:33 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040331145833.8569.qmail@web41704.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In a post by KOVACS Krisztian,
http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014584.html,
he declared that the LIST_DELETE bug can be reliably
reproduced, which is first reported by Jonathan
Cooper. The bug is really  responsive :). I reproduced
it by executing the following commands at my host
10.0.0.2:
1. iptables -t nat -A PREROUTING -s 10.0.0.0/24 -p tcp
--dport 80 -j REDIRECT --to-port 8080
2. nc -l -p 8080
3. nc -n 10.0.0.2 80

To make my life a litter easier, I unpluged all the
Ethernet cables to reduce the noise.

The result is really interesting. Let me introduce
some notation first.

Notation: let [1] represents the PREROUTING hook of
netfilter; [2], the LOCAL IN hook; [3], the FORWARD
hook; [4], the POSTROUTING hook; and [5] the LOCAL OUT
hook.

When "nc -n 10.0.0.2 80" is executed, client nc will
send the packet 10.0.0.2:32768 --> 10.0.0.2:80. It
first travles through [5], then [4]. A conntrack, call
it CT1, is created and CONFIRMED for the packet. The
tuples of CT1 are {Orignal 10.0.0.2:32768
-->10.0.0.2:80  REPLY 10.0.0.2:80-->10.0.0.2:32768}.
CT1 is hashed to the buckets determined by these two
tuples. 

Then, the packet loops back through the loopback
interface. This time, the packet goes through [1] and
[2] hooks. The conntrack code is smart enough to know
that it is related to CT1. No conntrack lookup is
necessary. Then the redirect rule goes into effect.
When redirected to localhost, redirect target will
create a range (ip_nat_multi_range) of from 127.0.0.1
to 127.0.0.1. The redirect target changes CT1's reply
tuple to 127.0.0.1:8080-->10.0.0.2:32768. Because CT1
is already confirmed, no confirmation takes place.
Unfortunately, when CT1's reply tuple is changed by
ip_conntrack_alter_reply, it's still linked into the
bucket determined by its old tuples,{Orignal
10.0.0.2:32768 -->10.0.0.2:80  REPLY
10.0.0.2:80-->10.0.0.2:32768}. So, there is no way to
find CT1 through 127.0.0.1:8080-->10.0.0.2:32768.

Then the packet arrives at the kernel and is delieved
to listening nc which replies with the packet
127.0.0.1:8080 --> 10.0.0.2:32768. This packet also
hits [5], and [4] first. Because we can't find CT1
through 127.0.0.1:8080-->10.0.0.2:32768, a new
conntrack is created and confirmed, call it CT2. CT2
has two tuples of {Orignal
127.0.0.1:8080-->10.0.0.2:32768 -->10.0.0.2:80  REPLY
10.0.0.2:32768-->127.0.0.1:8080}.  The packet then
goes through [1] and [2], no redirection occurs. At
last it is sent to client nc. 

Client nc replies with a RST packet which is
successfully delieved to listening nc, and tcp_packet
will destory CT2. 

This is why the client nc sticks in SYN_SENT state,
CT1 sticks in UNREPLIED state, and there are transit
conntracks going up and down. When CT1 times out
finally, the LIST_DELETE bug shows up.

Mar 31 17:37:53 ip2 kernel: clean_from_lists(ce149060)
Mar 31 17:37:53 ip2 kernel: LIST_DELETE:
ip_conntrack_core.c:302
`&ct->tuplehash[IP_CT_DIR_REPLY]'(ce149084) not in
&ip_conntrack_hash[hr].

It should not be of too much difficult to fix it now.
I am too tired to do it now, maybe some one can do it
for us :). 

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
