From: Peteris Krumins <peteris@lf.lv>
Subject: ip_queue, is this safe:
Date: Fri, 01 Aug 2003 13:50:50 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F2A460A.5050005@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

  I have written an application which uses ip_queue mechanism to quickly
  push (of course only some) packets from kernel space to user space.
  (The packets are queued in PREROUTING, mangle)
  The application is quite big and i bet i have made several mistakes,
  leaving unpleasent buffer overflows and something more.

  what i am interested in is if this is safe to write:

---
  [...]
  struct iphdr *ip;
  ip = (struct iphdr *)packet->payload;

  if (ip->protocol == IPPROTO_TCP) {
      struct tcphdr *tcp;

      tcp = (struct tcphdr *)(packet->payload + ip->ihl*4);
      [...]
  }
  [...]
---

  i am doubting:
  tcp = (struct tcphdr *)(packet->payload + ip->ihl*4);

  because ip->ihl could be faked, couldnt it? The packet would get queued
  and if ip->ihl is something faked, using the tcp pointer i'd get a
  segfault, wouldn't i?


P.Krumins
