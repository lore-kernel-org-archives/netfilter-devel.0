From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Changing the content of tcp timeouts in ip_conntrack_proto_tcp.c
Date: Wed, 14 Jan 2004 12:34:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40051B18.40004@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel@lists.netfilter.org"
 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi!

In the target module I'm writing, I need to customize the values 
ip_ct_tcp_timeout_/somthing/ in the ip_conntrack_proto_tcp.c file. I 
tried to write an extern function on the model of ip_ct_refresh, but I 
always got the same problem with depmod:

depmod: *** Unresolved symbols in 
/lib/modules/2.4.23/kernel/net/ipv4/netfilter/ipt_MY_TARGET.o
depmod:     ip_ct_proto_tcp_set_timeouts

Does someone have a good advice on how to proceed correctly?

                 Emmanuel
