From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: Problems in classifying packets into Prio qdisc bands
Date: Fri, 23 Jul 2004 01:04:34 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407222203.i6MM39MX002921@madinah.ccse.kfupm.edu.sa>
References: <200407221712.i6MHCBMX000577@madinah.ccse.kfupm.edu.sa>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Netfilter List" <netfilter-devel@lists.netfilter.org>
In-Reply-To: <200407221712.i6MHCBMX000577@madinah.ccse.kfupm.edu.sa>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

I am marking packets at userspace using the modified libipq library that
adds nf mark along with the verdict. I am also using PRIO qdisc to
prioritize traffic into three default bands. I use tc filter to classify
traffic. Here are my configuration commands.

------------------------- for PRIO qdisc-----------------------------

tc qdisc add dev eth0 root handle 1: prio
tc qdisc add dev eth0 parent 1:1 handle 10: sfq
tc qdisc add dev eth0 parent 1:2 handle 20: sfq 
tc qdisc add dev eth0 parent 1:3 handle 30: sfq

-----------------------for tc
filter-------------------------------------------------

tc filter add dev eth0 parent 1:0 prio 0 protocol ip handle 1 fw flowid 1:10
tc filter add dev eth0 parent 1:0 prio 1 protocol ip handle 2 fw flowid 1:20
tc filter add dev eth0 parent 1:0 prio 2 protocol ip handle 3 fw flowid 1:30

----------------------------------------------------------------------------
-------

Now these nfmarks 1, 2 and 3 are being marked at the libipq program (or at
least I am assuming that) but it seems that there is something wrong cause
all the traffic flows through band 2, nothing goes to bands 1 and 3. Can
anyone help me on this one? This is very urgent.
Regards

 

Muhammad R. Sami 
Research Assistant, 
Computer Engineering Department 
P.O.Box 354 
King Fahd University of Petroleum & Minerals 
Dhahran 31261 
Saudi Arabia. 
Tel: +96638601423 
Cell: +96657982951 
www.ccse.kfupm.edu.sa/sami

 
