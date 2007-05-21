From: Darren.Reed@Sun.COM
Subject: Developing a user space library for filtering
Date: Mon, 21 May 2007 15:27:05 -0700
Message-ID: <46521CB9.2040309@Sun.COM>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi,

One of the core problems I see as people want to more and
more with firewall/NAT technology is integrate using it into
their application (whatever that may be.)  As time goes by,
this problem is becoming more and more acute and perhaps
is doing us (those who develop said technologies) a disservice
by making the "barrier to entry" too high.

Currently, to interact with filtering software inside the kernel
requires developers to build their application against whatever
specific version of the filtering software runs in the kernel.  For
application developers, this is a PITA.  What they want to see is
the equivalent of a libc for firewalls with functions that have a
similar stability to the likes of "fopen", "printf", etc.

And therein lies the problem.  Nothing currently exists, so if you
engage in developing for any one particular firewall/NAT product
then you wed yourself to using that product.  Not a great place
to be if you're the 3rd party.

This problem/situation is one that I believe needs to be improved.

Is anyone in the Linux netfilter community currently engaged
on working on anything to address this problem?

If there isn't, can I ask if anyone would be interested in being
involved in designing and implementing a new library where
the primary focus or target is going to be 3rd party developers
that want to build applications on top of netfilter, etc?  It is
important to understand that my focus isn't just on netfilter or
iptables, but also includes ipf/ipfw/pf and potentially others too
if people become interested.

The end goal isn't to build something that userland tools would
be rewritten to use (although ostensible they could), just to
provide what those on the outside need in order to build apps
that are both portable and functional.

Darren
