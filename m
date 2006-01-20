From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/3] cleanups for matches
Date: Fri, 20 Jan 2006 20:50:19 +0900 (JST)
Message-ID: <200601201150.k0KBoKuH016706@toshiba.co.jp>
References: <20060120081151.GV4603@sunbeam.de.gnumonks.org>
	<200601200955.k0K9tSnM001413@toshiba.co.jp>
	<20060120112126.GB4603@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20060120112126.GB4603@sunbeam.de.gnumonks.org>
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


From: Harald Welte <laforge@netfilter.org>
Date: Fri, 20 Jan 2006 12:21:26 +0100

> Anyway, I still think that we can ignore that issue.  Please patch the
> manpage with a corresponding notice, one that explicitly states which
> kernel version behaves how.

OK,

> I wish we had started a list of 'netfilter/iptables semantic changes' in
> 2000 which we would always keep up to date.  Now there are a number of
> subtle differences (like this) which almost nobody recalls :(

Ah, I forgot that. I can check IPv6 related words this weekend, but please
don't expect good English. ;)

> btw: is it feasible to do the same kind of merge for AH ?

Well, I don't want to do it. Only ESP header is special because it cannot be
skipped. On the other hand, AH is normal IPv6 extension header and can be
skipped like others. Then 'ip6tables -p tcp -m ah ...' makes sense,
for example.

-- Yasuyuki Kozakai
