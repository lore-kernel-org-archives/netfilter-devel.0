From: Brad Chapman <kakadu_croc@yahoo.com>
Subject: Re: [PATCH}: Make MARK target terminate (resend)
Date: Sat, 29 Jun 2002 05:53:21 -0700 (PDT)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020629125321.2456.qmail@web10906.mail.yahoo.com>
References: <200206291236.36997@henrik.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <200206291236.36997@henrik.marasystems.com>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Mr. Nordstrom,

--- Henrik Nordstrom <hno@marasystems.com> wrote:
> On Saturday 29 June 2002 11.46, Patrick McHardy wrote:
> 
> > A CONNMARK patch will follow but currently CONNMARK doesn't apply
> > clean against 2.4.18/2.4.19-pre10 ..
> 
> Note: There is two versions of the CONNMARK patch. The one in extra 
> applies if you are using the new_nat patch, the one on old_nat if 
> not.
> 
> Your last posting did stir up some discussion on how to deal with 
> this. Adding a "terminate" option to each and every of these 
> psuedo-targets is clearly not the way to go, and only cover a very 
> small subset of what is needed.
> 
> I proposed adding a new class of iptables things between matches and 
> targets, being neither a match for filtering or a target that 
> determines the ultimate fate of the packet. The names proposed for 
> these in the discussion was modifiers or actions.

        I think modifier is a better term. "Action" sounds more like "target"
and may confuse new users of iptables.

> 
> The implementation of these can be done without needing to change the 
> kernel iptables API by simply piggying back on the match list in the 
> table structure. The modifiers/actions need to register themselves as 
> a match, and for compability with old rulesets and/or userspace tools 
> as a target as well..
> 
> The userspace tools need to have a new option for calling a 
> modifier/action. These should clearly be separated from matches.

        Has the option letter been decided on yet?

> 
> So the question to the Netfilter core team is if it would be OK to add 
> a new option and "module class" to the userspace tools, and have the 
> existing IPT_CONTINUE targets dual-register as both a target and a 
> match. I can try to whip something together if this is seen as 
> something acceptable. Should be fully backwards/forward compatible 
> with existing rulesets with only a minimal amount of code 
> duplication. The only compability issue is that if you make use the 
> new feature then you cannot go back to a older userspace or kernel.

        I would like to see a feature like this because it makes the iptables 
syntax cleaner and easier to understand. The only difficulty I see is backward
compatibility with older kernels and older iptables installations. You mentioned
using a piggyback mechanism for the ipt_match/ipt_target structs to prevent
API changes. Will a new API eventually emerge (ipt_modifier)? And if a new API
does emerge, what kernel version would it be aimed for (2.4.xx? 2.5.xx?)

        Also, BTW: will this facility appear in iptables2 as well?

> 
> Regards
> Henrik
>

Brad 


=====
Brad Chapman

Permanent e-mail: kakadu_croc@yahoo.com

__________________________________________________
Do You Yahoo!?
Yahoo! - Official partner of 2002 FIFA World Cup
http://fifaworldcup.yahoo.com
