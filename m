From: "Peter Olsson" <aa@tbh.se>
Subject: Re: Kernel Oops with kernel 2.4.25 and iptables 1.2.9 in __unexpect_related
Date: Tue, 15 Jun 2004 19:44:52 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <004d01c45300$768a0a40$7c01a8c0@std.visionutv.se>
References: <002401c452ac$06523580$7c01a8c0@std.visionutv.se> <40CEB3DA.5070401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Patrick McHardy" <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

I meant kernel 2.4.17, not 2.4.27 :)

About other patches... I've applied a couple of other patch-o-matic patches,
but pptp_conntrack_nat
is the only one that seem to call anything related to the __unexpect_related
function. I've only applied
patches that were tested ok, not the experimental ones. The
"__unexpect_related" has the following
code in my version of ip_conntrack_core.c.

Thanks for your answer, I'd really appreciate any help I can get on this.

Best regards,
Peter Olsson

----

/* remove one specific expectation from all lists and drop refcount,
 * does _NOT_ delete the timer. */
static void __unexpect_related(struct ip_conntrack_expect *expect)
{
        DEBUGP("unexpect_related(%p)\n", expect);
        MUST_BE_WRITE_LOCKED(&ip_conntrack_lock);

        /* we're not allowed to unexpect a confirmed expectation! */
        IP_NF_ASSERT(!expect->sibling);

        /* delete from global and local lists */
        list_del(&expect->list);
        list_del(&expect->expected_list);

        /* decrement expect-count of master conntrack */
        if (expect->expectant)
                expect->expectant->expecting--;

        ip_conntrack_expect_put(expect);
}



----- Original Message ----- 
From: "Patrick McHardy" <kaber@trash.net>
To: "Peter Olsson" <aa@tbh.se>
Cc: <netfilter-devel@lists.netfilter.org>
Sent: Tuesday, June 15, 2004 10:31 AM
Subject: Re: Kernel Oops with kernel 2.4.25 and iptables 1.2.9 in
__unexpect_related


> Peter Olsson wrote:
> > After running my firewall without any problems for about 90 days, I
> > suddenly got a Kernel Oops.
> > When running it through ksymoops I received the result below.
> >
> > I've read a few comments about a bug in the newnat code in
> > unexpect_related, but what I can see
> > this should be fixed a long time ago, and if I compare the
> > unexpect_related calls in the ip_conntrack_core.c
> > from version 2.4.25 til 2.4.26 they work in exactly the same way. Could
> > there be something else causing
> > this problem? I don't think it's hardware related, I've been using the
> > same hardware, but with kernel 2.4.27
> > for about a year before this happened, and it's been working really
good.
>
> We are at 2.4.27-pre5 now ..
>
> It looks like the list is uninitialized in list_del. Have you applied
> any other patches besides pptp_conntrack_nat ?
>
> Regards
> Patrick
>
