From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Fixed some memoryleaks in ip(6)tables.c
Date: Tue, 18 May 2004 21:47:03 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405182143100.10300-100000@filer.marasystems.com>
References: <1084904635.969.10.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1084904635.969.10.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 18 May 2004, Martin Josefsson wrote:

> I converted an application from direct libiptc fiddling to use
> do_command() from iptables.c instead (why use the horrible lowlevel
> interface of libiptc when you don't have to?) and found some
> memoryleaks. These changes has been running in a small testprogram under
> valgrind and seems to work fine.

Then there is more good news for you. You can now easily complete the
migration to not at all link the application directly to iptables by using
a iptables-restore session. iptables-restore is essentially the same
interface as do_command with only some nice syntactical sugar added.

> People with large iptables-restore "sessions" might notice a decrease in
> memory-usage.

Thanks!

Regards
Henrik
