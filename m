From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: (D)NAT with IPv6 (was "nf_conntrack & NAT")
Date: Mon, 12 Dec 2005 21:42:33 +0100
Message-ID: <1134420153.4093.12.camel@bzorp.balabit>
References: <200511231225.jANCPmYd015427@toshiba.co.jp>
	<20051123132044.GZ3249@eychenne.org>
	<20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<Pine.LNX.4.58.0512071201460.17863@blackhole.kfki.hu>
	<20051207145438.GA5617@eychenne.org>
	<Pine.LNX.4.58.0512071603190.17863@blackhole.kfki.hu>
	<20051208114120.GF5617@eychenne.org>
	<20051208115632.GB13067@oknodo.bof.de>
	<20051209045759.GD4244@rama.exocore.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051209045759.GD4244@rama.exocore.com>
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

[ trimmed Cc line ]

On Fri, 2005-12-09 at 10:27 +0530, Harald Welte wrote:
> On Thu, Dec 08, 2005 at 12:56:32PM +0100, Patrick Schaaf wrote:
> > > So each time you add a service on a host, you should assign a new IP to it
> > > (and create the respective DNS name for this IP/service couple!), just in
> > > case you may have to redirect its traffic one day? (even if temporary)
> > 
> > This has proven to be a very valuable strategy, at work, even for normal
> > IPv4 operation. Saves headaches every time we want to migrate something.
> > I can warmly recommend this practise.
> 
> oh btw, this also solves the usual ssl certificate problem, where you
> for example tell people to use smtp/tls or imap/tls or whatever to
> "smtp.foo.org" which might be a cname, and thus the certificate name
> doesn't always match the 'dn' of the cert.

Even though this is usually a question of paying for several
certificates and not being unable to put different certificates to
different ports.

-- 
Bazsi
