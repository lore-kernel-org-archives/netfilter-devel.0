From: Philip Ho <cbho@ie.cuhk.edu.hk>
Subject: 3 target treatment
Date: Wed, 05 Mar 2003 16:29:36 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E65B570.5DA3802D@ie.cuhk.edu.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Philip <cbho@ie.cuhk.edu.hk>
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

Dear all

Can I possibly force some matched packet passing through three targets
in a row, namely

1. update fragmentation field in IP header
2. update DSCP field
3. mark it (must be in mangle table)

Regards,
philip
