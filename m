From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere
 else (was Re: Fw: Rusty's brain broke!)
Date: Sat, 17 Jan 2004 18:50:21 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0401171737300.10400-100000@filer.marasystems.com>
References: <20040117110952.GI18505@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Julian Anastasov <ja@ssi.bg>, <linux-net@vger.kernel.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20040117110952.GI18505@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 17 Jan 2004, Harald Welte wrote:

> I think we could push CONNMARK to the mainstream kernel in the next
> couple of weeks.  

Great!

> I'd like to discuss one change with you first... that is using the mark
> field as a bitmask.
> 
> We had that idea for a very long time, and didn't ever change it for the
> skb->nfmark field for the sake of compatibility.
> 
> But now, when introducing a new mark field (the conntrack->mark field),
> I'd rather prefer implement matching/setting individual bitmasks from
> the beginning.  What do you think?  Would you be willing to add that
> feature, or alternatively don't mind if I'd add the respective changes
> myself?

It is fine by me. It is a trivial thing to add as the extension is not 
yet frozen.

> Also, please add a Copyright notice including your name and a reference
> to the GPL on top of the .c files.

Will do.

> Another minor cosmetic issue: Could you please update it to use
> C99-style structure initializers in the code?

Sure.

> Last, but not least:  We'd need an etry for the iptables(8) manpage.

Already there from the beginning, but lost in p-o-m due to the lack of a
clear structure on how manpage additions should be maintained for not yet 
official extensions. (the help is copy-paste from the manpage output)

Should I also write a more module like help text for these modules?

Btw, any plans on how iptables manpage snippets for extra/not yet
submitted matches/targets should be maintained?

The requested changes has been done but is not yet tested. Testing should 
be finished tomorrow when I will submit the changes.

Regards
Henrik
