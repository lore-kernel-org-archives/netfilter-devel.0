From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: iptables-filter patch
Date: Thu, 20 May 2004 10:03:52 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <072d01c43dfd$efa08070$2601010a@bluereef.local>
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

There was a patch that someone had once submitted to allow filtering
(iptable_filter.c replacement) from both the PRE and POST routing hooks in
much the same way as the mangle table currently works. Does someone still
have access to this patch for me (for 2.6 kernel), and as a secondary issue
will adding such a patch be compatible with the new IPsec NAT functionality
that Patrick has recently written?

Thanks,

Andrew.
