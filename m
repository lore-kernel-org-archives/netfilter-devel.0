From: "McGuffin, Tim" <UCS_TIM@exchange.shsu.edu>
Subject: Quota / SMP / IRQBalance
Date: Wed, 17 Dec 2003 15:16:25 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <0E051BDF2E73C847B9220964CBD1B8F32BC3@EXCHANGE.SHSU.EDU>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I currently have a Dual P3/800 and a Dual Xeon 2GHz experiencing the
same behavior with multiple kernels and thought I would mention it to
the list.  The -devel list seemed a little more appropriate than the
standard netfilter list.

On the Dual 800 running Redhat 9 or Fedora Core 1, the quota match is
completely broken by enabling the irqbalance service.  With irqbalance
enabled, the box is able to transfer roughly twice the amount of data
before the quota is exhausted (11437662 bytes out of a 5000000 byte
quota).

On the Dual Xeon 2G with Hyperthreading enabled, they're able to
transfer roughly 4 times the traffic, and the quota counter doesn't
decrement like it should.

When IRQBalance is not loaded from boot, the quota functions work as
they should.  After its started they're hosed until the box is rebooted
again.

It seems the quota patch is tied to a single processor handling IRQs and
the load balancing of IRQBalance throws everything off.

I have plenty of trial and error attempts if anyone would like more
information. :)

Thanks,
-Tim McGuffin
