From: Amin Azez <azez@ufomechanic.net>
Subject: Re: iptables http problems
Date: Fri, 28 Apr 2006 07:05:51 +0100
Message-ID: <4451B0BF.4030800@ufomechanic.net>
References: <op.s8nue2ddextast@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <op.s8nue2ddextast@localhost.localdomain>
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

Paolo Cerrito wrote:
> Hi, i'm writing a userspace application, using nfnetlink_queue. Can i
> write a rule for iptables that send on a queue http packets? the problem
> is that i have to distinguish the packets for apllication layer
> protocols. Is there a way for that?

You could look at: http://l7-filter.sourceforge.net/
Which is an iptables module that recognizes application layer protocols.

Be aware that it is hard to do reliable patterns for some applications,
and also that in order to recognize a layer 7 application iptables must
be monitoring the connection when it starts.

Any connections already active before the rule is active might not be
recognized.

Further realize, that it takes a few packets sometimes to gather enough
data to recognize the application layer protocol, especially if someone
is trying to hide their traffic by using very very small packets, and so
you may not recognize the application layer on the first packet, so you
may not be able to use this for totally blocking data based on
application layer as some packets may get through before classification
is complete.

Sam
