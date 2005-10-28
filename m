From: <Jewgenij.Belopilski@alumni.TU-Berlin.DE>
Subject: How to find the rule a packet has matched?
Date: Fri, 28 Oct 2005 13:00:32 +0200 (CEST)
Message-ID: <59565.80.171.134.116.1130497232.squirrel@mailbox.TU-Berlin.DE>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Dear netfilter team,

in my diploma thesis I face the following issue:

I have to find for each accepted TCP packet going through the netfilter
the rule that this packet has matched. Or, more precisely, I'm interested
in what port/port range matched the TCP packet. (For this purpose I
extended the skbuff structure for the variable:

                  struct ipt_entry_match *my_ptr;

and hope to gain information about port/port range from this structure.)

I'm sure that the decision whether a certain port/port_range matches the
packet takes place in the function

       ip_tables.c:int do_match(.....)

namely in the call

       m->u.kernel.match->match(skb, in, out, ....);


I want to look in the function refered by this pointer,
but I cannot find it in source code! That is my problem.
(Herefor I placed a printk() in tcp_match() function
but I can see that tcp_match() is being called
not for each TCP packet...)


Grateful for every tip,
Jewgenij Belopilski

jewgenij.belopilski@alumni.tu-berlin.de
