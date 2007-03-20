From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH RESEND]: conntrack: kill destroy() in nf_conntrack for
 diet
Date: Tue, 20 Mar 2007 02:08:14 +0100
Message-ID: <45FF33FE.3000802@trash.net>
References: <200703200057.l2K0vX8a001308@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200703200057.l2K0vX8a001308@toshiba.co.jp>
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
> The destructor per conntrack is unnecessary, then this replaces it with
> system wide destructor.
> 
> +extern void (*nf_ct_destroy)(struct nf_conntrack*);

BTW, please add whitespace between nf_conntrack and * (also in some
other spots).
