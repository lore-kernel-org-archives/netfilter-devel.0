From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/3]: xtables: error if ip_conntrack is asked to handle
 IPv6 packets
Date: Mon, 11 Dec 2006 18:41:32 +0100
Message-ID: <457D984C.60606@trash.net>
References: <200612081053.kB8ArGMM014433@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200612081053.kB8ArGMM014433@toshiba.co.jp>
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
> To do that, this makes nf_ct_l3proto_try_module_{get,put} compatible
> functions. As a result we can remove '#ifdef' surrounds and direct call of
> need_conntrack().

Also applied, thanks.
