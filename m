From: Kiran Kumar <immidi_kiran@yahoo.com>
Subject: TCP conntrack queries
Date: Sun, 21 Mar 2004 21:04:38 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040322050438.56577.qmail@web14009.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

Hi,
  As I went through ip_conntrack_proto_tcp.c, I had
these couple of queries.

- Why is there a distinction b/w states NONE and
CLOSED?

- The array of timeouts has been replaced (as I get
from the diff b/w my RH9 kernel sources and 2.6
sources) by an array of pointers to variables. Why was
this done?

=====
Regards,
Kiran Kumar Immidi

__________________________________
Do you Yahoo!?
Yahoo! Finance Tax Center - File online. File on time.
http://taxes.yahoo.com/filing.html
