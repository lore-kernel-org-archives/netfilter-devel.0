From: "Muhammad R. Sami" <sami@ccse.kfupm.edu.sa>
Subject: using traffic shaper and queuing together
Date: Fri, 9 Jul 2004 18:04:29 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200407091502.i69F2JMX010344@madinah.ccse.kfupm.edu.sa>
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

I want to use traffic shaper to limit the bandwidth of my outgoing
interface. Along with that I also want to use tc and qdisc for queuing
traffic. My question is that if I use traffic shaper I have to assign a
pseudo interface to my physical interface, but for queuing do I have to use
the pseudo interface or I have to run the tc commands with reference to the
physical interface (eth0).

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

 
