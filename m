From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: buffer overflow in ip_ct_{ftp,tftp,irc}
Date: Sat, 24 Sep 2005 17:43:20 +0900 (JST)
Message-ID: <200509240843.j8O8hLPb011535@toshiba.co.jp>
References: <20050920093510.GB31236@sunbeam.de.gnumonks.org>
	<200509201248.j8KCmNi9009046@toshiba.co.jp>
	<20050920141520.GG31236@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: sbellabes@mandriva.com, yasuyuki.kozakai@toshiba.co.jp,
	netfilter-devel@lists.netfilter.org, davem@davemloft.net,
	kaber@trash.net, pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <20050920141520.GG31236@sunbeam.de.gnumonks.org>
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
Date: Tue, 20 Sep 2005 16:15:20 +0200

> On Tue, Sep 20, 2005 at 09:48:21PM +0900, Yasuyuki KOZAKAI wrote:
> 
> > Really ? At least, the current moduleparam.h in David's git tree includes
> > declarations for param_*_ushort(). And I succeeded to compile and use ftp
> > module with the attached patch.
> 
> ok "ushort" will work, but not "u_int16_t".  I'll prepare a patch for
> all helpers.

Sorry for confusing. "using u_int16_t" means just "u_int16_t ports[MAX_PORTS]".
Anyway, thanks for consideration.

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
