From: Christian Riechmann <riechmann@fgan.de>
Subject: "No buffer space available" upon ipq_read
Date: Thu, 29 Jul 2004 12:44:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040729104449.GA2202@rie.rie.priv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I am sure some one can give me a short answer to the following problem:

Sometimes - for the moment I would say "randomly" - during a relative
long run upon an ipq_read request I get the error
	"Failed to receive netlink message: No buffer space available"

My questions are:
	Which buffer is meant ? 
and
	Which are some reasons for this error situation ?

I use iptables- 1.2.9 and I am pretty sure, that all packets read into
user space are verdicted. The user space program does not expand its used
memory the more it runs.

Thanks in advance for some pointers.

Christian

-- 
Christian Riechmann    E-Mail: riechmann@fgan.de
c/o FGAN/FKIE          Tel: (+49) 228/9435 345,378
Neuenahrer Strasse 20  Fax: (+49) 228/9435 685
D-53343 Wachtberg, Germany
