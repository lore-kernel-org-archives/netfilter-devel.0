From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 3/3][CONNTRACK] Fix race condition in early drop
Date: Wed, 23 Aug 2006 11:28:11 +0900 (JST)
Message-ID: <200608230228.k7N2SDHM000520@toshiba.co.jp>
References: <200608220435.k7M4ZSLf001686@toshiba.co.jp>
	<44EB0ACA.8080109@netfilter.org> <44EB171B.9080505@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@netfilter.org
In-Reply-To: <44EB171B.9080505@netfilter.org> <44EB0ACA.8080109@netfilter.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 22 Aug 2006 16:39:23 +0200

> Pablo Neira Ayuso wrote:
> >> How about incrementing {ip,nf}_conntrack_count at first ?
> >>
> >>     1. atomic_add()
> >>     2. if {ip,nf}_conntrack_count > {ip,nf}_conntrack_max (not '>=' )
> >>        then early_drop()
> >>     3. if early_drop() failed, atomic_dec()
> > 
> > 
> > I thought about this possibility but then we can't guarantee the fixed 
> > maximum number of conntracks in the system.
> 
> Hm, actually this is wrong, we can guarantee the maximum number but 
> aren't we somehow fooling the counter? I mean, the counter can reach 
> values higher than conntrack_max during a short period.

good point. I don't mind fooling the counter in this short period,
indeed someone might mind that. Then,

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 22 Aug 2006 15:46:50 +0200

> > And there is no assurance that CPU A can exits this loop in short time.
> 
> You are right, this seems important. Instead of looping we can just give 
> up if we lose race.

Now I think this is better.

-- Yasuyuki Kozakai
