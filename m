From: Patrick McHardy <kaber@trash.net>
Subject: Re: REJECT target / need-fragment ?
Date: Tue, 15 Mar 2005 20:20:24 +0100
Message-ID: <42373578.8060806@trash.net>
References: <20050314125747.GA18233@paradigm.rfc822.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
To: Florian Lohoff <flo@rfc822.org>
In-Reply-To: <20050314125747.GA18233@paradigm.rfc822.org>
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

Florian Lohoff wrote:
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
> May i use this from iptables target modules ?

Yes, but adding yet another target that does something already done
elsewhere is not a good idea. You could try to extend ipt_REJECT
in a way similar to Rusty's patch "Add bitops to ipt_MARK without
breaking compatbility".

Regards
Patrick
