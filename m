From: Yuan ChunYang <cyyuanml@sonata.iscas.ac.cn>
Subject: priority in netfilter
Date: 09 Jul 2003 11:40:10 +0800
Sender: linux-net-owner@vger.kernel.org
Message-ID: <1057722010.1302.21.camel@sonata>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <linux-net-owner@vger.kernel.org>
To: ml_linux-net <linux-net@vger.kernel.org>
List-Id: netfilter-devel.vger.kernel.org

Can somebody explain priority in netfilter hooks?
We know netfilter defined 
 enum nf_ip_hook_priorities {
         NF_IP_PRI_FIRST = INT_MIN,
         NF_IP_PRI_CONNTRACK = -200,
          NF_IP_PRI_MANGLE = -150,
          NF_IP_PRI_NAT_DST = -100,
          NF_IP_PRI_FILTER = 0,
          NF_IP_PRI_NAT_SRC = 100,
          NF_IP_PRI_LAST = INT_MAX,
 };
They are ordered by ascend. But i do not know when to use which priority?

