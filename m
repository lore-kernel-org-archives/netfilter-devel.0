From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/11] Rename struct nf_conntrack_protocol
Date: Fri, 03 Nov 2006 14:53:27 +0100
Message-ID: <454B49D7.3080303@trash.net>
References: <20061101210845.337590368@wlug.westbo.se>	<20061101210913.910411244@wlug.westbo.se>
	<200611031251.kA3Cpao9010791@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, gandalf@wlug.westbo.se
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611031251.kA3Cpao9010791@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> After applied this patch, NF_CT_ASSERT(proto); in ct_seq_show() of
> nf_conntrack_standalone.c should be NF_CT_ASSERT(l4proto);

All fixed and folded into the original patches, thanks.
