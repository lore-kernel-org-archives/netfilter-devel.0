From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: How to fill a ipt_entry structure to add a rule using
 iptc_append_entry()
Date: Tue, 22 Jun 2004 19:28:40 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406221926260.25113-100000@filer.marasystems.com>
References: <20040622154903.GK24374@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: babula allu <allubabula@yahoo.com>
In-Reply-To: <20040622154903.GK24374@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 22 Jun 2004, Harald Welte wrote:

> On Tue, Jun 22, 2004 at 04:47:55AM -0700, babula allu wrote:
> > Hi,
> > 
> > 
> > I am trying to add a simple rule to INPUT chain using
> > iptc_append_entry  but it fails.It says invalid
> > argument.
> > 
> >  I also tried sending the same ipt_entry structure
> > which was returned by the iptc_first_rule API.In this
> > case iptc_append _entry doesn't return an error but
> > iptables -L doesn't display the rule in the list also.
> > 
> > If somebody knows about the cause and solution please
> > help me.
> 
> 1) please read http://www.netfilter.org/contact.html
> 
> 2) libiptc is not a public interface, we do not encourage neither
>    support anybody using it.


Instead use the iptables / iptables-restore command interfaces.

For large modifications iptables-restore is recommended. Accepts the same 
commands as iptables, plus some more for the "transaction support" (see 
output of iptables-save)

Regards
Henrik
