From: Dmitry Mishin <dim@openvz.org>
Subject: [NET][IA64] Unaligned access in sk_run_filter
Date: Mon, 20 Feb 2006 18:28:28 +0300
Message-ID: <200602201828.29098.dim@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org,
	rusty@rustcorp.com.au, devel@openvz.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1030241AbWBTP2s@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

We have an issue on ia64 box. It is easy triggerable 'kernel unaligned access' 
in sk_run_filter:
         ptr = load_pointer(skb, k, 4, &tmp);
         if (ptr != NULL) {
                  A = ntohl(*(u32 *)ptr); << here
                  continue;
         }

due to 'k' is coming from userspace it can be easy triggered, e.g.:
[root@node1 ~]# tcpdump -i eth0 'ip[1:2]=0'

Could you advise how to fix this?

-- 
Thanks,
Dmitry.
