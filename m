From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] Add bridged IPv6 packet filtering
Date: Tue, 7 Sep 2004 20:41:27 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <200409072041.27774.bdschuym@pandora.be>
References: <200409012234.26310.bdschuym@pandora.be>
	<200409021523.i82FNdsY015603@toshiba.co.jp>
	<200409022346.13288.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: davem@redhat.com, netfilter-devel@lists.netfilter.org,
	usagi-core@linux-ipv6.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
	hno@marasystems.com
In-Reply-To: <200409022346.13288.bdschuym@pandora.be>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thursday 02 September 2004 23:46, Bart De Schuymer wrote:
> > > On Thu, 2 Sep 2004, Yasuyuki Kozakai wrote:
> > > > You forgot to find "Jumbo Payload Option" in Hop-by-Hop Options
> > > > header. Other options may exist in this header.
> > > >
> > > > And please truncate packet if actual packet length is greater than
> > > > Jumbo Payload Length + IPv6 header length.
>
> The incremental patch below introduces this.
<snip>
> Dave, unless someone complains, please apply.

Hi Dave,

I was wondering what your plans are on applying the patch I sent last 
Thursday. Noone has complained about it.

> --- linux-2.6.8.1/net/bridge/br_netfilter.c.older	2004-09-02
<snip>
