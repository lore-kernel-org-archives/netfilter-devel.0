From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] ct-event API port to 2.6.11
Date: Fri, 08 Apr 2005 14:50:07 +0100
Message-ID: <42568C0F.6050002@ufomechanic.net>
References: <424747D5.8060500@eurodev.net>	<42502B1B.7090309@trash.net>	<42540839.8020405@ufomechanic.net>	<4254265F.6080607@eurodev.net>	<42554200.3020405@ufomechanic.net>	<42555F99.8010201@ufomechanic.net>	<42564BA6.3040702@ufomechanic.net>	<42564FAA.2050302@eurodev.net>	<425658A8.6050200@ufomechanic.net>	<42565AB4.5000803@eurodev.net>	<42567910.4090601@ufomechanic.net>
	<42567D15.8090102@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <42567D15.8090102@eurodev.net>
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


For the record I forgot to say:
add Pablos patches from the post I was replying to (see 
http://lists.netfilter.org/pipermail/netfilter-devel/2005-April/019182.html
)
to the unpacked libctnetlink and libnfnetlink before you compile them.

What is ctnltest supposed to do?

Running ctnltest I only ever get one packet where the subsys id is 
NFNL_SUBSYS_CTNETLINK_EXP

I can bring connections up and down all day and ctnltest doesn't receive 
any more packets.

I'm so close now to completing this path through the jungle, when I'm 
done I shall walk up and down it to make the path wider and explore the 
side roads.

I was hoping that ctnltest would start spitting out reports when 
connections came up and down.

I'm currently investigating how libctnetlink goes through libnfnetlink 
and touches ct-event to see if it even should do what I think, but any 
tips anyone has will be appreciated.

Sam



Pablo Neira wrote:
> Amin Azez wrote:
> 
>> Thanks for the patches Pablo, they seemed to do the trick.
>> ctnl_del_conntrack has been expanded to 3 args, should I be using 
>> CTA_UNSPEC or CTA_ORIG or CTA_STATUS as the 3rd arg on line 118 of 
>> ctnltest.c?
> 
> 
> +int ctnl_del_conntrack(struct ctnl_handle *cth,
> +                      struct ip_conntrack_tuple *tuple,
> +                      enum ctattr_type_t t)
> 
> The 3rd arguments says if you're referring to CTA_ORIG or CTA_RPLY. So 
> you can kill conntracks based on the direction.

Hmmm... in the context of ctnltest.c its hard to say what is required.
I'm not even sure why ctnltest is calling ctnl_del_conntrack for packets 
where (NFNL_SUBSYS_ID(nlh->nlmsg_type) == 
           NFNL_SUBSYS_CTNETLINK)

> fix ctnl_del_conntrack, CTA_UNSPEC isn't ok as 3rd param.

will do: really dumb question, why is ctnltest even calling 
ctnl_del_contrack?

Amin
