From: Chandrakanth Chereddi <kanth@hserus.net>
Subject: use of IPT_INV_TOS
Date: Mon, 15 Mar 2004 15:29:21 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040315095921.GA15870@hserus.net>
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

Hi,

The IPT_INV_TOS flag which is defined in the ip_tables.h file does not
seem to be used anywhere in the actual code. Can anyone please let me
know why it's been defined there.

I did a "grep -r IPT_INV_TOS *" in the top dir. of the kernel source and
it returned only one match, apparently the header file. Am I missing
something here?

TIA.
-- 
CCK./	kanth@hserus.net
"Passion and gradualness"	-- Pavlov.
