From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: Problems using libipq/QUEUE
Date: Wed, 30 Jun 2004 18:43:02 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200406301543.i5UFhhMX024255@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter List" <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am having problems running libipq/ QUEUE. My libipq program successfully
compiles. I add the following rule to the iptables:

 

iptables -A OUTPUT -p icmp -j QUEUE

 

Now this should queue all originating ping packets and then depending on the
NF mark action will be taken. But it seems that regardless of the NF mark,
all icmp traffic is blocked. As I remove the above rule from the iptables,
things work fine. Furthermore, when I run the modprobe commands to check for
ipatble_filter and ip_queue, I get a fatal message stating "module not
found". Could you please tell me where I am wrong. I am using the libipq
example program provided in the manpage.

Regards,

 
