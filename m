From: Henrik Nordstrom <henrik@marasystems.com>
Subject: Re: extensions manpage, howto etc
Date: Wed, 21 Jan 2004 01:17:42 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401210105020.29594-100000@filer.marasystems.com>
References: <20040120130122.GC8642@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040120130122.GC8642@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 20 Jan 2004, Harald Welte wrote:

> However, if somebody wants to take the full job of 
> - adding the respective information to the sourcecode
> - generating the respective manpage snippets

These two can relatively easily be done as the man page should essentially
be a superset of the terse extension help and requires very little markup,
and having them unified would help greatly in ensuring the reference
documentation is kept up to date with the extension it documents.

> - generating netfilter-extension-HOWTO snippets in docbook XML

This I do not think is wise to have derived from the extension source for
the reasons outlined before. The person writing the HOWTO class material
is most likely not the same as the extension maintainer as it requires
somewhat different skills in writing the extension and a howto on how it
is used (not only syntax), and there is also the question about
translation.

The HOWTO class material is in my opinion better maintained as a separate
document preferably maintained by a non-programmer with close user
contact, and should stay on the HOWTO level of things not dive into all
details about exact syntax etc like the reference man page.

The reference documentation (i.e. man page) should be maintained by
whomever maintains the extension implementations, and the framework should
encourage this as a natural part of the process of implementing and
maintaining extensions.

Regards
Henrik
