From: Pedro Fortuna <pedro.fortuna@gmail.com>
Subject: netfilter question
Date: Fri, 11 Feb 2005 22:10:41 +0000
Message-ID: <db95d40c050211141019b71bf5@mail.gmail.com>
References: <42086F50.9090504@niksula.hut.fi>
	<53965.213.236.112.75.1107867276.squirrel@213.236.112.75>
	<420BEAFB.9070405@niksula.hut.fi>
Reply-To: Pedro Fortuna <pedro.fortuna@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <420BEAFB.9070405@niksula.hut.fi>
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

Hello guys. I'll try to make it as short an simple as I can.

I want to develop a kernel module which will be running in two linux
hosts, connected by a crossover network cable (ethernet). This kernel
module will intercept a specific type of traffic (as an example, let's
say FTP packets (encapsulated in DIX frames)), both incomming and
outgoing, and change the ethertype in the frame header.

Outgoing dix frames carrying FTP packets get their ethertype changed
to a private, non standard ethertype number, just before they leave
the host (i.e. before they are passed to the network driver). The
frame is intercepted with the NF_IP_POST_ROUTING hook.

Incoming dix frames carrying FTP packets are get their ethertype
changed (at this point, a non standard ethertype number) to the
standard IPv4 ethertype number (i.e. 0x800), just after they are
processed by the network driver. The frame is intercepted with the
NF_IP_PRE_ROUTING hook.

My doubt is:
I'm not sure if I will be able to intercept the incoming frames
because they have a non standard ethertype number. They might get
dropped before passing through the NF_IP_PRE_ROUTING hook, due to the
unrecognized ethertype number. Is this true or false?
If the frame passes the hook before trying to identify the packet
type, then I'll have no trouble, because my netfilter module changes
the frame to the original ethertype number, thus making the hole
process transparent to the TCP/IP stacks running in both hosts.

I could explain what the hell I need to this for, but then you would
have three times more text to read :P I tried to restrict this post to
a minimum-painless-size.

Regards,
-Pedro Fortuna
