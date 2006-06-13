From: "Vasantha Kumar Puttappa" <vasanthakumar@iitb.ac.in>
Subject: PREROUTING:To update Source and destination IP field (plz reply)
Date: Tue, 13 Jun 2006 22:53:09 +0530 (IST)
Message-ID: <3067.10.12.25.5.1150219389.squirrel@gpo.iitb.ac.in>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
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

Dear friends,
  I am new to iptables and libipq. Please somebody reply to this query

  Is it possible to change both source and destination field in an IP
header in PREROUTING. If not, plz somebody suggest me a way to do that.

 Let me explain in detail

 Suppose there are 3 machines A B C. When a packet comes from machine A to
machine B. I would like to capture these packets AT MACHINE B BEFORE it
goes through routing decision. I would like change the source and the
destinatio IP address(modified SOURCE IP = MACHINE B IP, modified
DESTINATION IP= MACHINE C IP)  including the payload, and then pass it to
the routing decision unit.

 Is it possible to implement this using iptables ? if yes,plz let me know.
If not, then plz suggest some ways to do this.


 Thanx in advance
