From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: Classifying packets with the CLASSIFY Target
Date: Mon, 5 Jul 2004 11:56:45 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407050854.i658sZMX029019@madinah.ccse.kfupm.edu.sa>
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

I am new to the concept of traffic shaping in Linux. I was going through
some examples of the CLASSIFY target in the mangle table. One of these
examples is given below:

iptables -t mangle -A POSTROUTING -p tcp --tcp-flags ALL ACK -m state
--state ESTABLISHED -m length --length 40:100 -J CLASSIFY --set-class 1:10

Now as the author states that the above command "Classifies packets of an
established session between 40 and 100 bytes", I would like to ask what does
1:10 exactly mean. Is it some sort of priority or what? Moreover what is not
clear is that if I want to classify packets in this fashion will I require
doing something in addition like creating handles for qdiscs and classes and
tc filtering etc. or this will be enough.

Regards,
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
