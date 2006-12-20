From: "xlz" <xlz@netarchlab.tsinghua.edu.cn>
Subject: A problem of netfilter HOOK point
Date: Wed, 20 Dec 2006 17:13:56 +0800
Message-ID: <200612201713511406550@netarchlab.tsinghua.edu.cn>
References: <200612201622446099344@netarchlab.tsinghua.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
	"netfilter-devel" <netfilter-devel@lists.netfilter.org>
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
    I have a problem of the netfilter HOOK point. I load my handle function in HOOK point NF_IP6_LOCAL_OUT. But, its behavior is likely to be in the HOOK point NF_IP6_POST_ROUTING. The detail is shown as follows:

I configrue a 6to4 tunnel between two linux hosts (2.6 kernel) by adding a interface "6to4tun". The route table in one of the host is:
2002:c0a8:101::/48   dev 6to4tun
default              via   3ffe:250:cccc::1  dev eth0
The 6to4 tunnel works well before I load my own handle function in the hook point NF_IP6_LOCAL_OUT.

In the hook point NF_IP6_LOCAL_OUT, my handle funtion changes the destination address of the packet from global ipv6 address (ex. 3ffe:250:cccd::2) to 6to4 address (ex. 2002:c0a8:101::1). In my expection, after changing the destination address in hook point NF_IP6_LOCAL_OUT, the host will look up the route table according the destination address, which is a 6to4 address. And then the host will send the packet from the interface "6to4tun". However, the experiment result is: the packets are sent from the interface eth0. It seems that the host looks up the route table according the global address. That means my own function seems to work in the hook point  NF_IP6_POST_ROUTING.
What is the problem?
Thank you in advance for any help!

Lizhong Xie
2006-12-20
