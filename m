From: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
Subject: Re: NAT question
Date: Wed, 30 Jun 2004 19:32:37 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1088604156.27771.9.camel@vijay>
References: <20040630132829.9B5144C0DC@spy10.spymac.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: immidi@spymac.com
In-Reply-To: <20040630132829.9B5144C0DC@spy10.spymac.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I have just grepped for icmp in /proc/net/ip_conntrack while pinging the
same box from two systems

icmp     1 29 src=192.168.1.80 dst=172.16.0.102 type=8 code=0 id=62829
src=172.16.0.102 dst=172.16.0.100 type=0 code=0 id=62829 use=1 
icmp     1 29 src=192.168.1.180 dst=172.16.0.102 type=8 code=0 id=38527
src=172.16.0.102 dst=172.16.0.100 type=0 code=0 id=38527 use=1

The 'identifier' of the ICMP msg seems to be the key that is being used
for guessing the actual source while handling the response.
No idea as to what would happen if both the systems decide to use the
same identifier though.

The ICMP RFC says
      The identifier and sequence number may be used by the echo sender
      to aid in matching the replies with the echo requests.  For
      example, the identifier might be used like a port in TCP or UDP to
      identify a session, and the sequence number might be incremented
      on each echo request sent.  The echoer returns these same values
      in the echo reply.


I guess conntrack would change the id just like it does with the tcp/udp
ports in case of a clash to identify the correct destination while
handling the response.

Regards,
Vijay.

On Wed, 2004-06-30 at 18:58, Kiran Kumar Immidi wrote:
> 
> Regards, 
> Kiran Kumar Immidi 
> 
> On Wed, 30 Jun 2004 17:56 , Vijaya Chandra Vupputuri
> <vijay@tachyontech.net> sent:
> 
> >If A and B send packets to a server, say google.com:80 using the
> local
> >port 10000, when the pkts get SNATed on C, the source ports would be
> >different from 10000 (21000 and 32000 for example) and when
> google.com
> >sends back the packets to those new port numbers, conntrack would
> change
> >the dst-port numbers to 10000 along with the dst-ip address.
> 
>   Oh yes, this answers my question. But how about ICMP which does not
> have a concept of port? 
> I have asked this in another mail.
> 
> 
> ______________________________________________________________________
> Cool Things Happen When Mac Users Meet! Join the community in Boston
> this July: www.macworldexpo.com
