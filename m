From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: helper and handling IPv6 fragments
Date: Mon, 21 Feb 2005 13:16:55 +0900 (JST)
Message-ID: <200502210416.j1L4Gt6e026758@toshiba.co.jp>
References: <200502161132.19312.michal@rokos.info>
	<200502171520.j1HFKH6U029405@toshiba.co.jp>
	<20050219185028.GN29256@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: laforge@netfilter.org
In-Reply-To: <20050219185028.GN29256@sunbeam.de.gnumonks.org>
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


Hi, Harald,

From: Harald Welte <laforge@netfilter.org>
Date: Sat, 19 Feb 2005 19:50:28 +0100

> > But how ipv6_confirm() can figure out whether helper has already tracked
> > the reassembled skb or not ?
> > 
> > I think nfcache flag may help. If helper return NF_ACCEPT, ipv6_confirm()
> > set NFC_ALTERD to nfcache of it. And when other fragments reach ipv6_confirm(),
> > it can return without call helper. Of cause, we need to define the other flags
> > for STOLEN/REPEAT...
> 
> I'm not sure if I understand this proposal correctly. Do you suggest to
> set the nfcache bit of the reassembled clone as soon as the first
> fragment has passed the helper (and returned NF_ACCEPT) ?

Yes, that's right. In the current code, no one touches the nfcache bit
of reassembled clone. So we can utilize it for nf_conntrack.

Regards,

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
