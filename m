From: Vineet Mehta <extreme@zayanionline.com>
Subject: Reading ICMP packet data
Date: Sun, 15 Feb 2004 18:41:22 +0300 (AST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402151827300.18606-100000@sillypoint.zayanionline.com>
References: <20040215183662.SM00868@guozheng>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20040215183662.SM00868@guozheng>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am making a new TARGET for iptables which tries to read the ICMP 
ECHO/ECHO-REPLY packets data payload. Now my problem is how do i know that 
the packet contains data i.e. 

IP Header+ICMP header+Data

and not

IP header+ICMP header

coz i see some utilities which will not send data part.

my TARGET hooks on NF_IP_INPUT_IN and i m using kernel 2.4.22.

Thanks
extreme
