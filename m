From: "zhengchuanbo" <zhengcb@netpower.com.cn>
Subject: the performance of big packets on Giga system
Date: Mon, 22 Dec 2003 13:21:6 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200312221309281.SM00864@zhengcb>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


I'm curious on the performance of big packets forwarding on Giga system.
Our system could forward 580kpps for 64byte packets. As the line rate of 
1518byte packets is similar to 80kpps,I supposed we could get line rate
forwarding for 1518byte packets.
	
But the result was not as that good. Our linux system could only forwarded
70kpps. with the help of debug I found that all the packets were received
without loss, bug the system failed to forward all the packets. Some of 
them were missed. I can't understand why we lost so many packets. And why
the number of packets that can be forwared is so much different between
64byte and 1518byte packets?
	
Thanks in advance. Please CC.
	
regards,
	
Jack Zheng
zhengcb@netpower.com.cn
	
