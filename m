From: Peter Lenci <peterlenci@yahoo.ca>
Subject: Re: Iptables Match on Direction (IP_CT_IS_REPLY)
Date: Fri, 4 Mar 2005 04:35:42 -0500 (EST)
Message-ID: <20050304093542.23600.qmail@web90010.mail.scd.yahoo.com>
References: <9151ac2a05022712376c099fb4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Filip Sneppe <filip.sneppe@gmail.com>
In-Reply-To: <9151ac2a05022712376c099fb4@mail.gmail.com>
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

Hi Filip

 --- Filip Sneppe <filip.sneppe@gmail.com> wrote: 
> On Sat, 26 Feb 2005 07:43:03 -0500 (EST), Peter Lenci
> <peterlenci@yahoo.ca> wrote:
> > Is there a possibility to access flag IP_CT_IS_REPLY from an iptables
> > command?
> > 
> > I have only spotted the "--direction original|reply|both" option from
> > the connbytes patch
> > (http://www.netfilter.org/patch-o-matic/pom-extra.html#pom-extra-connbytes)
> > but then I would prefer not to waste memory by counting bytes.
> > 
> 
> The "conntrack" match should do what you are looking for. From the help
> option:

I studied conntrack but didn't find a way to read the direction
of the packet. In fact I was thinking about writing a patch for that
module to add an option "--direction original|reply|both".

How exactly would you determine the direction with conntrack?

Regards
Peter

______________________________________________________________________ 
Post your free ad now! http://personals.yahoo.ca
