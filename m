From: Wang Jian <lark@linux.net.cn>
Subject: Need help on 2.6.11 and pom-ng HEAD
Date: Thu, 31 Mar 2005 17:50:24 +0800
Message-ID: <20050331173635.01D4.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
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

Hi,

I am working on an enterprise project that use linux + netfilter + tc as
a QoS control device.

Beside ordinary conntrack helper, the following things are needed:

 directx8-conntrack-nat
 h323-conntrack-nat
 ipp2p
 mms-conntrack-nat
 quake3-conntrack-nat
 rtsp-conntrack
 nfnetlink-ctnetlink-0.13

Some of above thigns are brought to 2.6.x only after 2.6.11. So I
decided to use 2.6.11 or coming 2.6.12.

But I failed to patch 2.6.11 with HEAD of trunk of pom-ng without
modification. I tweak 2.6.11 source code for insertion point in
ip_conntrack.h, and the conntrack helper can be applied but can't be
compiled. And Pablo Neira's nfnetlink-ctnetlink-0.13 patches for 2.6.11
can't be compiled too.

Can someone give me a hint on this issue?



-- 
  lark
