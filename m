From: "Huang Wei" <robin2046@163.com>
Subject: How to change IP_QUEUE's queue_maxlen without recompiling?
Date: Fri, 27 Apr 2007 15:45:12 +0800
Message-ID: <000001c7889f$fd423260$ac84403b@bupthuangwei>
References: <4630E2CE.395E10.18445@m5-118.163.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4630E2CE.395E10.18445@m5-118.163.com>
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

Hi, everybody.

When I "modprobe ip_queue", the file "/proc/sys/net/ipv4/ip_queue_maxlen"
can not be written. If I "rmmod ip_queue", the file is gone! And I can not
create a file named that! Why?
How can I change IP_QUEUE's queue_maxlen without recompiling?

Thanks!

Robin
