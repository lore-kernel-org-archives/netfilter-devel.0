From: "Martijn Lievaart" <m@rtij.nl>
Subject: Re: REJECT target / need-fragment ?
Date: Mon, 14 Mar 2005 15:49:43 +0100 (CET)
Message-ID: <48320.213.236.112.75.1110811783.squirrel@213.236.112.75>
References: <20050314125747.GA18233@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
In-Reply-To: <20050314125747.GA18233@paradigm.rfc822.org>
To: netfilter-devel@lists.netfilter.org
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

Florian Lohoff said:
>
> Hi,
> i'd like to reject packets based on their size and send back and
> icmp-must-fragment with a configurable size. As i can see no such
> possibility is there currently. The REJECT target itself does not
> offer this.
>
> Should i add this functionality to REJECT or rather write another
> module.
>
> BTW: The ip stack has function like this:
>
> 	icmp_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
> 				  htonl(dst_pmtu(&rt->u.dst)));
>

Search this list, or the netfilter-users list. I once posted a module that
does just that.

M4
