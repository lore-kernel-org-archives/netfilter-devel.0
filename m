From: William Stearns <wstearns@pobox.com>
Subject: Re: "ip_tables: table screwed up!" on pom 20031023 - raw patch?
Date: Mon, 24 Nov 2003 10:13:00 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311241011150.21895-100000@sparrow>
References: <Pine.LNX.4.44.0311241445490.17111-100000@filer.marasystems.com>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, <kadlec@netfilter.org>,
   ML-netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0311241445490.17111-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day, Henrik,

On Mon, 24 Nov 2003, Henrik Nordstrom wrote:

> On Fri, 21 Nov 2003, Henrik Nordstrom wrote:
> 
> > Unfortunately my problem is still there.. and now the UML kernel config is 
> > very close to what we use on "real" boxes..
> 
> FYI: My problem with corrupted tables on iptables-restore have been
> isolated with 99.9% certainity as a odd UML kernel memory management
> issue.

	Many thanks for the update.
	I've moved on to a newer POM and stopped using the raw patch 
entirely, and the problem has disappeared - although I'm not sure which 
was the solution, obviously.
	/me loses 2 effective troubleshooting points. ;-)
	Cheers,
	- Bill

---------------------------------------------------------------------------
        "Quote of the day: '"
(Courtesy of Martin Mares <mj@suse.cz>)
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
Linux articles at:                         http://www.opensourcedigest.com
--------------------------------------------------------------------------
