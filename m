From: Phil Howard <phil-netfilter-devel@ipal.net>
Subject: routing by netfilter
Date: Sat, 5 Oct 2002 00:24:13 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20021005002413.A16288@hamal.ipal.net>
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

Has anyone implemented a new target that could be used to force
specific routing on the basis of tests done in netfilter, when
done in the right place, such as table filter chain forward to
verride the previous routign decision.  For example I would like
to route everything destined to a specific port number via a
different gateway.

-- 
-----------------------------------------------------------------
| Phil Howard - KA9WGN |   Dallas   | http://linuxhomepage.com/ |
| phil-nospam@ipal.net | Texas, USA | http://ka9wgn.ham.org/    |
-----------------------------------------------------------------
