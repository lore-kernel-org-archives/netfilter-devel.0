From: Mike-Ro-Chanel <mikerochanel@yahoo.it>
Subject: Jitter phenomenon in the netfilter infrastructure
Date: Thu, 16 Oct 2003 09:42:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F8E4BFD.1050103@yahoo.it>
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

Hi All,
Inspired by ipt_limit module I've written a token bucket module as a 
iptables module extension.

I've observed a strange behaviour:
In the linux kernel 2.4.21 input ethernet frames are sent to the IPv4 
layer by "process_backlog()" function, this one pass to ip_rcv() 
hundreds of SKB elements in a single burst, its execution is limited (in 
time) by 1 jiffy.
As result a regular IPv4 input traffic is looked by PREROUTING hook as 
an irregular flow of packets.

Looking this phenomenon I think: an ingress bandwidth filter as 
netfilter module is unfeasible.

Is my opinion wrong?

Any suggestions?

Thanks

	Mike-Ro-Chanel
