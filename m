From: Emmanuel Fleury <fleury@cs.auc.dk>
Subject: Re: Security flaw in Stateful filtering ??????
Date: Mon, 10 Jun 2002 10:26:27 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D0462B3.80208@cs.auc.dk>
References: <Pine.LNX.4.33.0206071425210.4373-100000@blackhole.kfki.hu> <015d01c21055$82f7aed0$6501a8c0@multisofteducation.com>
Reply-To: netfilter-devel@lists.samba.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Oskar,

Oskar Andreasson wrote:
> 
> My proposal was to create a way of doing more secure, and
 > stateful, redundancy mechanism. For example, 2 or more firewalls
 > which shares their conntrack tables via some userspace daemons.
 > This would require the daemon to have read/write access to the
 > conntrack tables via netlink however, and I am not fully aware
 > of the possibilities of this.

Well I don't know if it will be more secure, but this idea is
interesting for me.

I already was thinking about something similar.

Indeed, if you consider a network which has several access points
to the Internet (let say FW1 and FW2). It is very 'dangerous' to
run stateful on these access point because a packet which is part
of a connection can go either through FW1 either trough FW2 (no static
routing is assumed).

As only one of your firewall had registered the connection (in the best
case), the other one will drop all the packets... (except if you
consider the "ACK is NEW" behaviour).

The 'solution' would be to consider what can be called a 'distributed
stateful firewall' which maintain a centralized connection table for
all your firewalls...

But, it raises a lot of problems like cache consistency over a network,
what to do if the three way handshake is distributed on the your
firewalls, and so on....

The most surprising is that this 'ACK is NEW' thing is solving
this problem also (even if I think that this is a dirty hack ;-)).

-- 
Emmanuel

You have to understand what the primary objective of an OS is:
To create a virtual environment that is simple and sane to program
against....

Have you learned nothing at all from DOS and Windows?
   -- Linus Torvalds
