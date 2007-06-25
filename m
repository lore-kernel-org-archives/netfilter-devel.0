From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [RFC][PATCH 0/10]: ct_extend
Date: Mon, 25 Jun 2007 12:14:02 +0900 (JST)
Message-ID: <200706250314.l5P3E2M4008231@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, kaber@trash.net, pablo@netfilter.org,
	kadlec@blackhole.kfki.hu
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


Hi,

This patch set is a snapshot of the ct_extend, which shrinks memory
usage where extensions such as NAT and helper are not used.

I've applied all suggestions from Patrick. If nat module is loaded,
ct_extend pre-allocates extended area of NAT when it initially allocates
extended area of helper. I've also renamed functions to nf_ct_ext_* and
merged the members in 'struct nf_nat_info' into 'struct nf_conn_nat'.

-- Yasuyuki Kozakai
