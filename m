From: Tom Eastep <teastep@shorewall.net>
Subject: Re: Future of CONNMARK (was Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Sat, 17 Jan 2004 10:46:02 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401171046.02062.teastep@shorewall.net>
References: <Pine.LNX.4.58.0401111517550.1161@u.domain.uli> <Pine.LNX.4.44.0401112203250.24615-100000@filer.marasystems.com> <20040117110952.GI18505@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Julian Anastasov <ja@ssi.bg>, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <20040117110952.GI18505@obroa-skai.de.gnumonks.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Saturday 17 January 2004 03:09 am, Harald Welte wrote:

>
> We had that idea for a very long time, and didn't ever change it for the
> skb->nfmark field for the sake of compatibility.
>
> But now, when introducing a new mark field (the conntrack->mark field),
> I'd rather prefer implement matching/setting individual bitmasks from
> the beginning.  What do you think?  Would you be willing to add that
> feature, or alternatively don't mind if I'd add the respective changes
> myself?

Harald,

I am very much in favor of the change you propose. The ability to set 
individual bits would allow Netfilter configuration tools like Shorewall to 
make internal use of packet marking by reserving part of the mark field for 
use by the tool and the remainder of the field for use by the user.

Given that the current MARK target lacks this capability, I am not able to 
make effective use of that target in Shorewall.

Thanks,
-Tom
-- 
Tom Eastep    \ Nothing is foolproof to a sufficiently talented fool
Shoreline,     \ http://shorewall.net
Washington USA  \ teastep@shorewall.net
