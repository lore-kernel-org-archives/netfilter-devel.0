From: Philip Ho <cbho@ie.cuhk.edu.hk>
Subject: Re: 3 target treatment
Date: Fri, 07 Mar 2003 09:42:43 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E67F913.929D861@ie.cuhk.edu.hk>
References: <3E65B570.5DA3802D@ie.cuhk.edu.hk> <200303052308.55624.fabrice@netfilter.org> <20030305181405.GD4880@sunbeam.de.gnumonks.org> <3E66DDFA.6759F728@ie.cuhk.edu.hk> <20030306111952.GB25556@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Thank you Harald. I think I should read these materials first.

Regards,
philip

Harald Welte wrote:

> On Thu, Mar 06, 2003 at 01:34:50PM +0800, Philip Ho wrote:
> > Hi Fabrice and Harald
> >
> > After I tried DSCP target, I have a bit of idea. I guess to update the frag.
> > field, I have to add source code like libipt_DSCP.c and libipt_dscp_helper.c
> >
> > But I cannot find in the sources explicit reference of the position of DSCP
> > field relative to IP header. Can you tell me the reason, please?
>
> pleaes read the netfilter hacking HOWTO and my netfilter programming
> tutorial (www.gnumonks.org/presentations/netfilter-programming-*)
>
> and to answer the question: less /usr/src/linux/net/ipv4/netfilter/ipt_DSCP.c
>
> > Regards,
> > philip
>
> --
> - Harald Welte <laforge@gnumonks.org>               http://www.gnumonks.org/
> ============================================================================
> Programming is like sex: One mistake and you have to support it your lifetime
>
>   ------------------------------------------------------------------------
>    Part 1.2Type: application/pgp-signature
