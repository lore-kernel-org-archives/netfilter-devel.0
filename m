From: "Andrew.hall" <temp02@bluereef.com.au>
Subject: Preroute selection order
Date: Mon, 10 Feb 2003 14:24:53 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <003901c2d0b3$f9fce8a0$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

When writing (for example) a new table, can someone please tell me how
netfilter orders the tables that register to listen on a particular hook
such as PREROUTE? I assume that there is a defined pecking order to which
tables get accessed first?

Thanks,

Andrew.
