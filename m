From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack performance/DoS formula
Date: Fri, 5 Jul 2002 00:08:37 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15653.17909.240706.246795@isis.cs3-inc.com>
References: <20020628082339.I2890@oknodo.bof.de>
	<200207011007.25108.hno@marasystems.com>
	<15652.38084.704660.234319@isis.cs3-inc.com>
	<200207042353.56244@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: 
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200207042353.56244@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom writes:
 > On Thursday 04 July 2002 20.32, Don Cohen wrote:
 > > [off list, but feel free to put it there if you think appropriate]
 > 
 > It has been discussed to death on the list. Try reading the archives 
 > some weeks back (always a healthy exercise). You are welcome to 
 > forward this response to the netfilter-users mailinglist where it 
 > really belongs. But here we go again..

I did read that, and it lead me to my mistaken conclusion.

 > ESTABLISHED is the TCP tracking state, not the conntrack state. 

I believe that now that I see the code:
ip_conntrack_standalone.c
static unsigned int
print_conntrack(char *buffer, const struct ip_conntrack *conntrack)
{
  ... proto name, proto number, timeout,
        len += print_tuple(buffer + len,
                           &conntrack->tuplehash[IP_CT_DIR_ORIGINAL].tuple,
                           proto);

   The 
 > TCP tracking state ESTABLISHED is derived from the last packet seen 
 > on the connection (ACK). This is not to be confused with the 
 > conntrack "state" ESTABLISHED as used in the state match which is a 
 > actually packet state describing how THIS packet relates to the 
 > connection, not a connection state as such.

This is what I was missing.  I had seen and understood that conntrack
states and tcp states were different.  I had also understood, but
evidently *incorrectly* that TCP states were the states as described 
in rfc793.  The term "established" there means something different
from what you describe above, more like what you call assured below.

 > What you have in conntrack for a TCP session is
 > 
 > a) A set of conntrack state bits, describing the state of the 
 > connection:
 > 
 >    - SEEN_REPLY
 >    - ASSURED
 >    - EXPECTED
 > 
 > b) A TCP tracking state, SYN_RECV, SYN_SENT, ESTABLISHED, TIME_WAIT 
 > and many more. Also keeps track of TCP window information and other 
 > crucial information for tracking a TCP session properly.

And these are the same names (or very similar) that show up in rfc793,
which is why I thought they meant the same thing.  If they don't mean
the same thing it would be nice to know what they do mean.  Especially
since they are displayed from /proc.

 > The TCP tracking state mainly controls the timeouts, but also has some 
 > influence on what kind of packets conntrack expects to see on the 
 > connection. The TCP tracking state is not visible in your rulesets.
 > 
 > The conntrack state bit SEEN_REPLY is pretty obvious what is 
 > represents.
 > 
 > ASSURED is a little trickier. What it represents is that conntrack are 
 > sure this connection is for real. For TCP this requires that 
 > conntrack has seen the whole SYN->SYNACK->ACK handshake.

This is what I thought the tcp state ESTABLISHED meant !

 > EXPECTED is simply that this connection was expected by a conntrack 
 > protocol helper, for example FTP data channels expected due to 
 > commands on their FTP control channel.
 > 
 > 
 > Now, if we take a look at the "state" match, it indicates four 
 > different packet states
 > 
 >    - INVALID
 >    - NEW
 >    - ESTABLISHED
 >    - RELATED
 > 
 > These states has nothing to do with TCP, only packet flows. If 
 > conntrack cannot identify a session key for the packet or otherwise 
 > fails to establish connection tracking (i.e. OOM) then the paket 
 > state is INVALID.
 > 
 > If the packet is the first packet conntrack has seen for a connection 
 > then it is a NEW (or RELATED where applicable). Note that this may 
 > well be an ACK or even a FIN, conntrack does not care, it only cares 
 > that it did not know about the connection before seeing the packet.
 > 
 > If there has been any reply packets (including the first reply packet) 
 > then the packet state is ESTABLISHED.
 > 
 > 
 > The ASSURED bit deserves a little more attention. As you may see from 
 > the above description of the four "state" types this bit is not used 
 > in any rulesets. The ASSURED bit is used by conntrack to defeat 
 > almost all DoS attempts. When conntrack runs out of entries it will 
 > throw away not ASSURED connections to make room for new connections. 
 > This very effectively stops almost all DoS attempts in filling the 
 > connection table.
 > 
 > 
 > This is the last time I will answer this question. If anyone feels 
 > like using any of this in a FAQ then you are welcome. If I see much 
 > more chatter about these fundamental aspects of netfilter connection 
 > tracking that really SHOULD be common knowledge to all users (note: I 
 > am not talking about developers here.. developers looking at 
 > conntrack MUST understand these aspects) then I don't know what I 
 > will do, but I suspect I will stop following the netfilter-devel 
 > traffic. I am damn tired that so few people seem to understand what 
 > "iptables -m state --state NEW" or "--state ESTABLISED" means.

Clearly this stuff should be in the manual.  That's what I read when I
was trying to understand it.  Perhaps in
http://netfilter.samba.org/documentation/HOWTO//packet-filtering-HOWTO-7.html#ss7.3
?

So, returning to the original question:
tcp 6 341427 ESTABLISHED src=165.130.74.240 dst=194.243.69.137 sport=1255 dport=80 [UNREPLIED] src=9.163.211.64 dst=165.130.74.240 sport=3128 dport=1255 use=1

This evidently means that only one packet in this connection has been
seen, but it had the TCP ACK bit on.  Hence "established".  And it was
also NATed, since the reply tuple is not just the reverse of the
original. 
