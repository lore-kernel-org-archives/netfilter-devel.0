From: Giacomo <jacum@libero.it>
Subject: execution context in netfilter hooks.
Date: Sun, 11 Dec 2005 21:39:16 +0100
Message-ID: <439C8E74.9070206@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Good morning, i would like to know exactly the context of execution
of code registered with netfilter hooks.
 As far as  I understood, the context is that of a softirq, inside a
bottom half. Correct me if i'm wrong..

But is it concerned with tasklets?

Is execution serialized? In other words, if packet A fr instance is
received from the net, and then packet
B immediately, is packet A processed entirely before packet B? Or code
can be executed in parallel
for packet A and B?

Moreover: interrupts are enabled in such context, aren't they? And that
means that also a
software timer can interrupt a routine being executed in bottom half.

But software timers run with sw interrupts disabled, so a timeout
handler for instance cannot
be interrupted by a routine managing reception of a packet arrived on
the wire.

It is not clear to me the concurrency to which structures are subject,
also in an uniprocessor system:
in_irq(), in_softirq(), in_interrupt() functions return different values
also if positioned at the same place in the code... is there a mean
(function) to know if sofware/hw interrupts are enabled in a portion of
code?

Thanks a lot for any suggestion or any indication to understand how
things are really.

Giacomo.
