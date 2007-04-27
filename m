From: "???" <kslee109@gmail.com>
Subject: RE: How to change IP_QUEUE's queue_maxlen without recompiling?
Date: Fri, 27 Apr 2007 21:11:35 +0900
Message-ID: <!&!AAAAAAAAAAAYAAAAAAAAAOw1YRArdYhAk8LmXFnnvB7CgAAAEAAAAKnET0UI0ABOiEGk7lUMFCIBAAAAAA==@gmail.com>
References: <4630E2CE.395E10.18445@m5-118.163.com>
	<000001c7889f$fd423260$ac84403b@bupthuangwei>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: "'Huang Wei'" <robin2046@163.com>,
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <000001c7889f$fd423260$ac84403b@bupthuangwei>
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

 
you use shell command like "echo 2048 > /proc/sys/net/ipv4/ip_queue_maxlen"


-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org] On Behalf Of Huang Wei
Sent: Friday, April 27, 2007 4:45 PM
To: netfilter-devel@lists.netfilter.org
Subject: How to change IP_QUEUE's queue_maxlen without recompiling?

Hi, everybody.

When I "modprobe ip_queue", the file "/proc/sys/net/ipv4/ip_queue_maxlen"
can not be written. If I "rmmod ip_queue", the file is gone! And I can not
create a file named that! Why?
How can I change IP_QUEUE's queue_maxlen without recompiling?

Thanks!

Robin
