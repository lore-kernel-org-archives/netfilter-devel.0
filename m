From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: iptables userspace build patch (CLASSIFY & NETMAP extensions)
Date: Mon, 15 Sep 2003 15:02:09 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.52.0309151501190.31443@tux.rsn.bth.se>
References: <20030912212651.GG4398@obroa-skai.de.gnumonks.org>
 <Pine.LNX.4.44.0309130938520.25469-100000@filer.marasystems.com>
 <20030915095521.GE777@obroa-skai.de.gnumonks.org>
 <1063623248.2123.12.camel@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <1063623248.2123.12.camel@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 15 Sep 2003, Henrik Nordstrom wrote:

> m=E5n 2003-09-15 klockan 11.55 skrev Harald Welte:
> > On Sat, Sep 13, 2003 at 09:39:30AM +0200, Henrik Nordstrom wrote:
> >
> > > In such case the test for NETMAP should be deleted from the CVS.
> >
> > which is what I did.  Thanks anyway for making me aware of the problem.
>
> It is still there in the current pserver CVS tree which is what I see..
>
>   CVSROOT :pserver:cvs@pserver.netfilter.org:/cvspublic
>   Path:   netfilter/userspace/extensions/.NETMAP-test

The sync between the private and the public cvs trees is currently broken,
I mentioned it to Harald in a mail but I'm not sure he saw it.
Harald?

/Martin
