From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 06/11] Rename struct nf_conntrack_protocol
Date: Fri, 03 Nov 2006 21:51:35 +0900 (JST)
Message-ID: <200611031251.kA3Cpa0l026705@toshiba.co.jp>
References: <20061101210845.337590368@wlug.westbo.se>
	<20061101210913.910411244@wlug.westbo.se>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: gandalf@wlug.westbo.se
In-Reply-To: <20061101210913.910411244@wlug.westbo.se>
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

From: Martin Josefsson <gandalf@wlug.westbo.se>
Date: Wed, 01 Nov 2006 22:08:51 +0100

> Rename 'struct nf_conntrack_protocol' to 'struct nf_conntrack_l4proto' in order
> to help distinguish it from 'struct nf_conntrack_l3proto'. It gets rather
> confusing with 'nf_conntrack_protocol'.
> 
> Signed-off-by: Martin Josefsson <gandalf@wlug.westbo.se>

After applied this patch, NF_CT_ASSERT(proto); in ct_seq_show() of
nf_conntrack_standalone.c should be NF_CT_ASSERT(l4proto);

-- Yasuyuki Kozakai
