From: Philip Ho <cbho@ie.cuhk.edu.hk>
Subject: Re: 3 target treatment
Date: Thu, 06 Mar 2003 14:50:25 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E66EFB1.57677556@ie.cuhk.edu.hk>
References: <3E65B570.5DA3802D@ie.cuhk.edu.hk> <200303052308.55624.fabrice@netfilter.org> <20030305181405.GD4880@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Fabrice MARIE <fabrice@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Dear all

Regarding my own question, I am trying to answer it. I can mangle on three
targets using the following script. But I am not sure about the performance
impact, are there anyone who has performed some kind of benchmarking test on
multiple targets?

iptables -t mangle -F
iptables -t mangle -A PREROUTING -j TTL --ttl-set 4
iptables -t mangle -A PREROUTING -j DSCP --set-dscp 46
iptables -t mangle -A PREROUTING -m dscp --dscp 46 -j MARK --set-mark 1

Regards,
philip


Harald Welte wrote:

> On Wed, Mar 05, 2003 at 11:08:55PM +0800, Fabrice MARIE wrote:
> > On Wednesday 05 March 2003 16:29, Philip Ho wrote:
> > > Dear all
> > > Can I possibly force some matched packet passing through three targets
> > > in a row, namely
> > > 1. update fragmentation field in IP header
> > > 2. update DSCP field
> > > 3. mark it (must be in mangle table)
> >
> > Hello Philip,
> >
> > Short answer: for the moment you cannot.
>
> well. I'm not sure.  Apart from the missing IPid target, I think the
> solution with a custom chain and DSCP/MARK target [both return
> IPT_CONTINUE] is fine for him.
>
> writing an IPid target is extremely easy, the only problem is how to create
> 'secure' IPid's...
>
> > Fabrice.
> > --
> > Fabrice MARIE
>
> --
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
>
>   ------------------------------------------------------------------------
>    Part 1.2Type: application/pgp-signature
