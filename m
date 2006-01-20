From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: nth patch on linux >= 2.6.15-git10
Date: Fri, 20 Jan 2006 15:37:31 +0100
Message-ID: <BAY103-F214AE3E26DB2A5F8484C6AB21F0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
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

I'm getting this warning, with gcc 3.3.6, compiling pom-ng nth
patch with the latest bleeding edge kernel (those with x_tables):

CC      net/ipv4/netfilter/ipt_nth.o
net/ipv4/netfilter/ipt_nth.c:144: warning: initialization from incompatible 
pointer type
net/ipv4/netfilter/ipt_nth.c:145: warning: initialization from incompatible 
pointer type
LD      net/ipv4/netfilter/built-in.o
