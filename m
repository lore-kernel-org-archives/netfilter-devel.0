From: Arvanitis Kostas <arvanit@ellemedia.com>
Subject: Buffer of by one in iptables.c in iptables v1.2.7a
Date: Fri, 21 Feb 2003 16:24:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200302211624.05704.arvanit@ellemedia.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-7"
Content-Transfer-Encoding: 7bit
Cc: arvanit@ellemedia.com
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

The line in find_target() that reads:

char path[sizeof(IPT_LIB_DIR) + sizeof("/libipt_.so") + strlen(name)]

is used as the target buffer for a sprintf() statement. However sprintf will 
also append a '\0' after the string, so the corrected line should be:

char path[sizeof(IPT_LIB_DIR) + sizeof("/libipt_.so") + strlen(name)+1]

This does not seem to affect the program, since path[] is allocated on the 
stack and there is nothing following it. However, for the shake of 
completeness, I think it should be corrected.

PS: Keep up the good work.
PS2: Is there a thought for iptables to take src/dst addresses as ranges in 
the form of ip_low - ip_high? (so as to be more compatible with the NAT-MIB)
-- 
A: No. See http://www.netmeister.org/news/learn2quote.html
Q: Should I include quotations after my reply ?
