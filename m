From: wanghtb@legend.com.cn
Subject: find_appropriate_src() BUG  also exist in 2.4.24
Date: Thu, 4 Mar 2004 16:32:33 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <OFEFA89E24.FB9C3E65-ON48256E4D.002E762C@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: hidden@balabit.hu
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

Hi, all

Still consider  a simple SNAT, without CONFIG_IP_NF_NAT_LOCAL selected 

[ Client A ] -----> [ Box B ] ----> [ Server C ]
iptalbes -A POSTROUTING -t nat -p udp  -j SNAT --to-source B:2000-3000

when two udp connection built:
ct1: ORIG A.1---> C.1   REPLY  C.1 ---> B.2000
ct2: ORIG B.2000 ---> C.2 REPLY C.2 ---> B.2000

then the third will hang on the system

B.2000 ---> C.1


So, I think ip_nat_local_fn() should be called in any situation:-)
