From: Peteris Krumins <newsgroups@lf.lv>
Subject: fork()-ing & exec()-ing iptables
Date: Tue, 16 Sep 2003 02:59:57 +0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15896902228.20030916025957@lf.lv>
Reply-To: Peteris Krumins <newsgroups@lf.lv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

  I have a threaded application which would lock a mutex,
  fork, then exec iptables then unlock a mutex, so no two
  iptable programs ran at the same time.
  
  After a period of time the same process would happen again
  but w/ the rule reversed (if it was -D then now it's -A and vice
  versa).

  I have noticed a problem while deleting the rules - the rule
  is added but if there are loads of work (adding rules and removing
  rules), then iptables program would fail to remove the rule with
  misleading error:
   iptables: Bad rule (does a matching rule exist in that chain?)

  I verified twice - the rule is there and the command line
  which should remove the rule is correct.

  What could cause such behaviour?

  And it's iptables 1.2.8 & same happens w/ 1.2.7a, linux 2.4.20
  and 2.4.21-pre6


P.Krumins
