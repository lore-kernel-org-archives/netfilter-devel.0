From: Christian Riechmann <riechmann@fgan.de>
Subject: Can a TCP-PDU being tunneled within a UDP-packet be accepted ?
Date: Tue, 6 Apr 2004 15:56:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040406135608.GA1625@rie.rie.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bussmann@fgan.de
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

Here is what I want to do:
I would like to encapsulate a TCP-PDU within a new PDU, which shall be
transmitted as a UDP-PDU to the recipient. On the recipients site the
TCP-PDU shall be decapsulated out of the UDP-PDU and with the verdict
ACCEPTED shall begiven back to the kernel for further processing.

The software I am using:
I am using IPv6 with ip6tables 1.2.9 and Linux kernel 2.6.4.

What I can see:
On the sending host ipq_read shows the TCP-PDU, this TCP-PDU is encapsulated
and sent out as UDP-PDU (tcpdump shows the UDP-PDU).
On the receiving host the transmitted UDP-PDU is received, the encapsulated
TCP-PDU is decapsulated and this TCP-PDU is given to ipq_set_verdict with
the action-parameter set to ACCEPT.
Now the PROBLEM: This accepted TCP-PDU does not arrive at the application!

I should mention, that this problem does not occur when instead of
TCP-PDUs ICMP- or UDP-PDUs are encapsulated, transmitted and decapsulated.

Hoping somebody can give me a hint to solve this problem.

Thanks in advance

Christian
-- 
Christian Riechmann    E-Mail: riechmann@fgan.de
c/o FGAN/FKIE          Tel: (+49) 228/9435 345,378
Neuenahrer Strasse 20  Fax: (+49) 228/9435 685
D-53343 Wachtberg, Germany
