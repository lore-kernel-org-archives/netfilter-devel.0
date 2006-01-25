From: "KdF" <dkiba@yandex.ru>
Subject: NFQUEUE: packet accumulation in queue, queue overflows
Date: Wed, 25 Jan 2006 13:27:41 +0300 (MSK)
Message-ID: <43D7529D.000004.17272@ariel.yandex.ru>
Reply-To: dkiba@yandex.ru
Mime-Version: 1.0
Content-Type: text/plain;
  charset="US-ASCII"
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

Hi all

After switching to NFQUEUE from ip_queue mechanism in our billing system we've got strange trouble: all works fine, but some packets seem not to leave queue, and after some time queue overflows, and packets get dropped. I increased maximum queue length in kernel during setup, and built new kernel, but even with 16384 entries instead 1024 it doesn't flush, but grows with time.

cat /proc/net/netfilter/nfnetlink_queue

3   1296  1697 2    64     0     0   123739  1

I have an idea that only packets for which verdict NF_DROP is set in our program don't leave queue? Or it is a userspace program perfomance issue? But on tests with simultaneous `ping -f` from four stations all worked fine, and only 64 bytes is copied to userspace to get ip headers.

NETFILTER and all extensions are built as a part of kernel, not as a module, maybe I should build it as a module? But it seems not to be documented anywhere.

Interfaces from which packets are queued are PPP interfaces, with PPPOE clients attached, is there any issues with it?

We tried kernels from 2.6.14.0 to 2.6.16-rc1, in 2.6.15 - 2.6.16-rc1 packet loss is less, but still persists, and REDIRECT target doesn't work (??????) (see my another post).

If problem in userspace application perfomance, does NETFILTER have a mechanism to flush old packets from queue, if they were not processed by userspace application?
