From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: conntrack performance/DoS formula
Date: Fri, 5 Jul 2002 13:41:11 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <200207051341.11454@henrik.marasystems.com>
References: <20020628082339.I2890@oknodo.bof.de> <200207042353.56244@henrik.marasystems.com> <15653.17909.240706.246795@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.samba.org>
To: don-nf@isis.cs3-inc.com (Don Cohen)
In-Reply-To: <15653.17909.240706.246795@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Friday 05 July 2002 09.08, Don Cohen wrote:

>  > TCP tracking state ESTABLISHED is derived from the last packet
>  > seen on the connection (ACK). This is not to be confused with
>  > the conntrack "state" ESTABLISHED as used in the state match
>  > which is a actually packet state describing how THIS packet
>  > relates to the connection, not a connection state as such.
>
> This is what I was missing.  I had seen and understood that
> conntrack states and tcp states were different.  I had also
> understood, but evidently *incorrectly* that TCP states were the
> states as described in rfc793.  The term "established" there means
> something different from what you describe above, more like what
> you call assured below.

The TCP tracking states are approximations of RFC793. However, 
conntrack_tcp does not implement TCP, it only tries to derive the 
states of the involved TCP endpoints by looking at the transmitted 
packets.

>  > b) A TCP tracking state, SYN_RECV, SYN_SENT, ESTABLISHED,
>  > TIME_WAIT and many more. Also keeps track of TCP window
>  > information and other crucial information for tracking a TCP
>  > session properly.
>
> And these are the same names (or very similar) that show up in
> rfc793, which is why I thought they meant the same thing.  If they
> don't mean the same thing it would be nice to know what they do
> mean.  Especially since they are displayed from /proc.

They mean mostly the same thing, except for the small fact that 
conntrack is not a TCP endpoint so it has to make some assumptions 
and guesses, and a great deal of simplifications in the state 
transitions... and as it is tracking both TCP endpoints at the same 
time the states may differ slightly..

As conntrack is looking at packets it has to make state transitions is 
based on the packets it sees rather than actions taken by the 
application, and selects the state closest matching the packets it 
sees. To be on the safe side (in terms of tracking) conntrack does 
not enforce a strict TCP state diagram but just tries to gess "If I 
see this kind of packet, what can the current TCP state be".

> So, returning to the original question:
> tcp 6 341427 ESTABLISHED src=165.130.74.240 dst=194.243.69.137
> sport=1255 dport=80 [UNREPLIED] src=9.163.211.64 dst=165.130.74.240
> sport=3128 dport=1255 use=1
>
> This evidently means that only one packet in this connection has
> been seen, but it had the TCP ACK bit on.  Hence "established". 
> And it was also NATed, since the reply tuple is not just the
> reverse of the original.

Correct, except for the minor detail that it can only have been a 
normal ACK packet (ACK,!SYN,!FIN,!RST). As the connection is not 
ASSURED it will be thrown away if there is a shortage of conntrack 
entries.. but as long as there is no shortage of conntrack entries it 
will stay around for a while in case there really is a TCP 
connection.

Based on the port numbers used the NAT rule probably is a REDIRECT of 
HTTP to Squid..

Regards
Henrik
