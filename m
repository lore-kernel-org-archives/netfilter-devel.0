From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 08/10] nf_nat: Kills global 'destroy' operation
Date: Tue, 26 Jun 2007 11:53:50 +0900 (JST)
Message-ID: <200706260253.l5Q2rpLd028953@toshiba.co.jp>
References: <200706251722.l5PHMPun023690@toshiba.co.jp>
	<46800850.2020708@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46800850.2020708@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 25 Jun 2007 20:24:16 +0200

> > +/* Noone using conntrack by the time this called. */
> > +static void nf_nat_cleanup_conntrack(struct nf_conn *ct)
> > +{
> > +	struct nf_conn_nat *nat = nf_ct_ext_find(ct, NF_CT_EXT_NAT);
> > +
> > +	if (nat == NULL || nat->info.ct == NULL)
> > +		return;
> 
> 
> These conditions would actually be BUG()s, right?

They can be NULL if the conntrack has not been confirmed yet.

-- Yasuyuki Kozakai
