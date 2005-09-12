From: Patrick McHardy <kaber@trash.net>
Subject: Re: more nf_conntrack/ip_conntrack questions
Date: Mon, 12 Sep 2005 12:42:51 +0200
Message-ID: <43255BAB.9040508@trash.net>
References: <dfs7qs$o54$1@sea.gmane.org> <4321A585.5050205@trash.net>
	<43255737.3040109@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Amin Azez <azez@ufomechanic.net>
In-Reply-To: <43255737.3040109@ufomechanic.net>
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

Amin Azez wrote:
> 2 questions, part style, relating to nf_conntrack and ip_conntrack
> 
> In nf_conntrack_tuple.h in
> 
> #define NF_CT_TUPLE_U_BLANK(tuple) \
> do { \
> (tuple)->src.u.all = 0; \
> (tuple)->dst.u.all = 0; \
> memset((tuple)->src.u3.all, 0, \
> sizeof(u_int32_t)*NF_CT_TUPLE_L3SIZE); \
> memset((tuple)->dst.u3.all, 0, \
> sizeof(u_int32_t)*NF_CT_TUPLE_L3SIZE); \
> } while (0)
> 
> why do we have:
> sizeof(u_int32_t)*NF_CT_TUPLE_L3SIZE
> 
> as the size, instead of just:
> sizeof((tuple)->dst.u3)
> 
> it seems to presume that:
> 1) .all will always be the biggest member
> 2) .all is always an array of NF_CT_TUPLE_L3SIZE of u_int32_t
> 
> I wonder why we need to duplicate this knowledge when a small definition
> appears to suffice.

I have no idea, but I agree that it looks confusing. You should ask
Yasuyuki, he wrote this code.

> Also; and I asked about somehting similar before, why is
> ip_conntrack_tuple.src almost exactly the same as
> ip_conntrack_tuple.dst, but .src is defined in terms of pre-declared
> structs and unions but dst is declared in terms of (nearly) identical
> structs and unions. With nf_conntrack as far as I can tell they are the
> same. The inline explanation of "manipulatable" doesn't seem to cover it.

Well, for one dst is only nearly identical. The "maniputable" part is
also used on its own for function arguments in the NAT code, the
non-manipulable part isn't, so there's no need to put it in a seperate
structure.
