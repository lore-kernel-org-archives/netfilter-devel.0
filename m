From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: more nf_conntrack/ip_conntrack questions
Date: Mon, 12 Sep 2005 20:29:07 +0900 (JST)
Message-ID: <200509121129.j8CBT83a022872@toshiba.co.jp>
References: <4321A585.5050205@trash.net> <43255737.3040109@ufomechanic.net>
	<43255BAB.9040508@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, azez@ufomechanic.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43255BAB.9040508@trash.net>
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


Hi,

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 12 Sep 2005 12:42:51 +0200

> Amin Azez wrote:
> > 2 questions, part style, relating to nf_conntrack and ip_conntrack
> > 
> > In nf_conntrack_tuple.h in
> > 
> > #define NF_CT_TUPLE_U_BLANK(tuple) \
> > do { \
> > (tuple)->src.u.all = 0; \
> > (tuple)->dst.u.all = 0; \
> > memset((tuple)->src.u3.all, 0, \
> > sizeof(u_int32_t)*NF_CT_TUPLE_L3SIZE); \
> > memset((tuple)->dst.u3.all, 0, \
> > sizeof(u_int32_t)*NF_CT_TUPLE_L3SIZE); \
> > } while (0)
> > 
> > why do we have:
> > sizeof(u_int32_t)*NF_CT_TUPLE_L3SIZE
> > 
> > as the size, instead of just:
> > sizeof((tuple)->dst.u3)
> > 
> > it seems to presume that:
> > 1) .all will always be the biggest member
> > 2) .all is always an array of NF_CT_TUPLE_L3SIZE of u_int32_t

Yes,

> > I wonder why we need to duplicate this knowledge when a small definition
> > appears to suffice.
> 
> I have no idea, but I agree that it looks confusing. You should ask
> Yasuyuki, he wrote this code.

This is for nf_ct_tuple_mask_cmp(), which compares 2 tuples with mask.
I didn't want to use 'switch - case' for each layer 3 protocol, then I
tried to generalize it like ip_ct_tuple_mask_cmp() like layer 4 protocol
part. Then I introduced the member 'all'.

 And for efficiency, it applies mask to tuple per 32bits instead of 8bits.
NF_CT_TUPLE_L3SIZE is used for checking loop limitation. I think it's easier
to read than sizeof(tuple->dst.u3)/sizeof(u_int32_t). And explicit definition
of array 'all' assures that sizeof(tuple->dst.u3) is divisible with
sizeof(u_int32_t) independent on contents of 'u3'.

Of cause, smarter idea than this way is welcome.

-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
