From: Roberto Nibali <ratz@tac.ch>
Subject: TCP window tracking patch status query for further design considerations
Date: Mon, 07 Oct 2002 17:56:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DA1AE9E.6030106@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello guys,

Is/Are there any news about the possibly impaired functionality of the TCP 
window tracking patch? I recall the thread about the mailinglist problems where 
Harald concluded that it was this patch that caused headaches to several people 
trying to send emails to the netfilter lists. Has the problem been investigated 
any further or is the status still unclear?

Unfortunately we depend on it because we do not use netfilter in a 'Intranet <-> 
Internet' way but in a 'multiple zones -> multiple zones' way. We do not have 
any trusted zones and without the TCP window tracking patch for example someone 
sending a RST can delete ESTABLISHED entries from the conntrack table. This is 
not an issue if you come from a trusted network like your Intranet for example, 
but it sure takes all the fun away if you have different customers on each NIC.

You can test things very efficiently with sendip (example to flush entries):
./sendip <dst> -p tcp -is <src> -ts <sport> -td <dport> -tfr 1

Without this patch, netfilter is completely useless to us. Could someone please 
give me a status report of this patch? What about a possible inclusion into 
mainstream kernel (this question is important to our management to create 
appropriate SLAs)?

TIA and best regards,
Roberto Nibali, ratz

PS.: FYI, I'm running and testing the stuff with the latest iptables, kernel 
2.4.20-pre8 and latest pom. I've not applied other patches yet.
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq' | dc
