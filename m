From: Samuele Giovanni Tonon <samu@mclink.it>
Subject: Re: a question about ipv4 multicast and NAT
Date: Mon, 25 Aug 2003 11:36:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030825093606.GA24322@linuxasylum.net>
References: <20030825082134.GB23526@linuxasylum.net> <20030825083213.GA423@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030825083213.GA423@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

sorry i sent only to Patrick rather than to the list . 

On Mon, Aug 25, 2003 at 10:32:13AM +0200, Patrick Schaaf wrote:
> On Mon, Aug 25, 2003 at 10:21:34AM +0200, Samuele Giovanni Tonon wrote:
> > after some research on iptables and how to make work igmp through 
> > nat i came to the conclusion that there isn't still an implementation
> > of how to NAT multicast connection from private networks to multicast
> > sessions.
> Did you find earlier discussion on this topic?
well i find a lot of mail on netfilter-users  asking how to handle the problem 
to allow igmp between multiple interface while having NAT but none ever
replyed .
However with "ya old ipchains" i was able to do that without problem

> > I would like to know if you are planning to do add this feature , 
> > because i think that many people could be happy to have this.
> Can you please outline what such an implementation would entail?
> Please be very specific.

i'll try to be as clear as possible however tell me if there's 
something you don't understand my english is not so fluent:

Linux GW (act as NAT box for a Private IP Network, say 192.168.0/24 )
People in 192.168.0/24 can set up internal "Multicast service", for example
a streaming video server (with an application called vic); this service
is only on the lan (multicast ttl=1) so it's like a broadcast .

Suppose now that these people are connected to a "Multicast Capable" ISP,
that is an ISP that sends video stream to all his customers.
Now these people would like to join that video stream: they just know 
the multicast ip and port to connect to (with vlc you can do that) , 
or they just want to browse all the available multicast service 
( with sdr or any session director you can do that) .
However they are inside a LAaN, so their request have to be "natted"
from the linux gw to the outside (because the outside doesn't want to
know anything about traffic coming from 192.168.0.0/16 ) .
e.g.


 src 192.168.0.1  ---> dst 224.22.3.2 (igmp IP_ADD_MEMBERSHIP)

should be natted by the linux GW as follow

 src CUSTOMER_ISP_IP ---> dst 224.22.3.2 (igmp IP_ADD_MEMBERSHIP)

After the request is accepted the linux box should know that all
the incoming traffic "from 224.22.3.2 to CUSTOMER_ISP_IP" should
be allowed to enter the LAN; to continue the example :


 src VIDEO_STREAM_SENDER ---> 224.22.3.2  

has to be allowed to enter the LAN 

the same thing should be possible if people from 192.168/24 wants to send
their video stream to the outside, but in this case things could be a bit more
complicated because you have to "nat" the outgoing stream and announce.

In this manner, with an isp that is multicast capable people can use multicast
for conferencing or just for fun .

Please tell me if something is not clear, or if i haven't answered correctly
to your question.

Regards
Samuele 


-- 
While various networks have become deeply rooted, and thoughts have been sent
out as light and electrons in a singular direction, this era has yet to 
digitize/computerize to the degree necessary for individuals to become 
a singular complex entity.
  KOUKAKU KIDOUTAI Stand Alone Complex
