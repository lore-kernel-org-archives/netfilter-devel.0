From: Constantine Sapuntzakis <csapuntz@gmail.com>
Subject: Preliminary NetBIOS datagram NAT filter
Date: Wed, 23 Feb 2005 20:38:43 -0800
Message-ID: <ea59786f050223203860806aa2@mail.gmail.com>
Reply-To: Constantine Sapuntzakis <csapuntz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

http://suif.stanford.edu/~csapuntz/ip_nat_netbios.c

Using this, I was able to join a Windows NT domain and login into the
domain from behind a NAT.

I had a hard time understanding all the parameters to the various
methods, so I probably got it wrong for anything except for source NAT
(which I tested). I'd appreciate any help from more experienced
developers.

Here's the problem with NetBIOS. NetBIOS datagrams contain the source
IP address and
source port as bytes 4-9 of the UDP payload. These need to be
rewritten while traversing a NAT.

Here are some questions:

- the HOWTO seems to indicate you want to override
hlpr->tuple.dst.u.udp.port but all the examples override
hlpr->tuple.src.u.udp.port  to filter all traffic to a port. Which is
right?

- will this NAT helper work with two computers with different IP
addresses behind a NAT? i.e. if both computers send packets with
source port 138 and destination port 138, will it correctly move the
source port number of one of the packets. Or do I have to call some
extra functions.

- will this code work for other things that rewrite the source
address? What do I need to do to make it work?

Thanks,
-Costa
