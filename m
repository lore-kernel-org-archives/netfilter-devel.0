From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: connbytes & 64bit counters
Date: Mon, 23 Jul 2007 11:27:00 +0900 (JST)
Message-ID: <200707230227.l6N2R1oO010164@toshiba.co.jp>
References: <Pine.LNX.4.64.0707202350290.4877@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707210038370.7261@bizon.gios.gov.pl>
	<46A18926.6040402@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, olenf@ans.pl,
	pablo@netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46A18926.6040402@trash.net>
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
Date: Sat, 21 Jul 2007 06:18:46 +0200

> Krzysztof Oledzki wrote:
> > Errr, incomplete patch, sorry... This one should work.
> > 
> > [NETFILTER]: Reimplementation of 64bit counters for bytes/packets
> > accounting
> 
> 
> I thought about this today, but came to no conclusion. We have ct_extend
> now, allowing to allocate the counters dynamically for new conntracks,
> and the only reasonable thing IMO (considering distributors that waste
> 16 bytes per conntrack for a feature pratically *nobody* uses, with your
> patch that actually fixes a regression 32 byte) would be to make
> accounting optional and triggered by a target in the raw table. Its so
> far used by default and the counters are visible through /proc and
> ctnetlink though. So this would break compatibility. OTOH I think its
> totally ridiculous to waste this much memory for something pratically
> nobody uses. So my current opinion is between just breaking
> compatibility (with some grace period perhaps) and trying to behave
> half-way compatible when ctnetlink is loaded. I don't think the second
> option will work though. And frankly, the current code it totally
> broken, it will send a COUNTER_OVERFLOW event *for each packet* when
> the counters exceed 2^31. So its really questionable if anyone actually
> uses this, without further patches.
> 
> Opinions are welcome.

Well, we cannot add ct_extend area to confirmed conntrack. Then connbytes
match would not be able to get counters of such conntracks if connbytes is
loaded after loading nf_conntrack.

I begin to feel that the lock issue of ct_extend limits us more strictly
than I thought.

-- Yasuyuki Kozakai
