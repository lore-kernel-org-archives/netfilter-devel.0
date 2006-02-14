From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 0/3] nf_conntrack: fixes for nf_ct_attach in IPv6 stack
Date: Wed, 15 Feb 2006 03:35:00 +0900 (JST)
Message-ID: <200602141835.k1EIZ1PW005639@toshiba.co.jp>
References: <43F204B8.5060700@trash.net>
	<200602141759.k1EHxfk0009760@toshiba.co.jp>
	<43F21DBC.70506@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	laforge@gnumonks.org, yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43F21DBC.70506@trash.net>
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
Date: Tue, 14 Feb 2006 19:13:16 +0100

> Yasuyuki KOZAKAI wrote:
> > IIRC, __{ip,nf}_conntrack_confirm is called at POSTROUTING and INPUT,
> > after all processing of packet filter. If I do
> > 
> > 	ip6tables -A FORWARD -p tcp --dport 22 -j REJECT
> > 
> > on my router, the conntrack of TCP SYN packet of ssh will never confirmed
> > and then nf_conntrack will create new conntrack for TCP RST at OUTPUT.
> 
> RSTs and ICMP errors without existing connections should be ignored
> by conntrack (and marked as INVALID). Are you sure the RSTs create
> new conntracks?

Yes.

OK, I'll stop to mind the behavior - allocating conntrack at once and destroy
it after all.

But INVALID is appropriate mark for them ?

-- Yasuyuki Kozakai
