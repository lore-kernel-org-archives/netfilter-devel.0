From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: Problems in classifying packets into Prio qdisc bands
Date: Thu, 22 Jul 2004 20:13:37 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407221712.i6MHCBMX000577@madinah.ccse.kfupm.edu.sa>
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

I am marking packets at userspace using the modified libipq library that
adds nf mark along with the verdict. I am also using PRIO qdisc to
prioritize traffic into three default bands. I use tc filter to classify
traffic.but it seems that there is something wrong cause all the traffic
flows through band 2, nothing goes to bands 1 and 3. Can anyone help me on
this one?

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

 
