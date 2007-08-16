From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Locking issue
Date: Thu, 16 Aug 2007 20:53:50 +0200
Message-ID: <1187290430.3005.11.camel@localhost.localdomain>
References: <652318.55542.qm@web7912.mail.in.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Abhinav Srivastava <abhinavs_iitkgp@yahoo.co.in>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <652318.55542.qm@web7912.mail.in.yahoo.com>
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

Op do, 16-08-2007 te 19:27 +0100, schreef Abhinav Srivastava:
> As far as I know about ulog, it just sends the packet
> to userspace logging deamon and do not wait for its
> reply. Does ulog provide waiting/blocking feature also
> that i can use in my code?
> 
> In my case, my requirement is to pass some packet
> header information to userspace tool and wait for its
> reply. During this process kernel code should block
> and wait for user response. Once it receives user
> response, it can go ahead. Like ulog, I am also using
> netlink socket for communication between kernel and
> userspace.
> 
> Is there anyway I can wait inside that code and let me
> userspace tool run so that i could receive response
> from it?

The kernel code has to process the packets as fast as possible. Ebtables
is executed in a softirq and waiting for userspace isn't something you
should do then (and you can't, as you've noticed). As I already
mentioned, a scheme like iptables' QUEUE target should be what you need.
It queues the packets to userspace and userspace is then responsible for
injecting them back into the stack.
What you currently should be able to do with ebtables is use ulog to
send the packets to userspace and then let userspace send the packets to
the right interface (drop the packet in the ebtables rule).

cheers,
Bart
