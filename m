From: Philip Craig <philipc@snapgear.com>
Subject: Re: PPTP connection tracking fixes
Date: Tue, 21 Jan 2003 11:50:50 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E2CA77A.1050001@snapgear.com>
References: <200301180029.h0I0T3d29430@stilton.routefree.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, paulm@broadon.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: paulm@routefree.com
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

paulm@routefree.com wrote:
> I have taken the PPTP connection tracking patch version 1.11
> and applied it to the 2.4.20 kernel's version of netfilter. 
> I then applied Philip Craig's subsequent patch to get his
> fixes.

Note that Harald has incorporated my patch in CVS with a
couple of small changes.

> In the course of getting this to work on my target systems,
> it became clear that our situation differs from those of
> the previous developers in the following respects:
> 
> 1)  In our case, we need to support the PPTP server running
> on the firewall machine itself, as well as the pass-through
> cases.
> 
> 2)  At least one of our platforms is big-endian.

Actually both of these are true for me.

> The change required to make 1) work is pretty straightforward.
> Case 2) is a bit uglier.
> 
> The thing that prevented case 1) from working is the following
> fragment in the routine ip_nat_fn() in ip_nat_standalone.c starting
> around line 111:
> 
>         case IP_CT_NEW:
> #ifdef CONFIG_IP_NF_NAT_LOCAL
>                 /* LOCAL_IN hook doesn't have a chain and thus doesn't care
>                  * about new packets -HW */
>                 if (hooknum == NF_IP_LOCAL_IN)
>                         return NF_ACCEPT;
> #endif

My PPTP server never received the incoming packet first in my
testing.  Adding a rule to drop the outgoing packet causes the
problem you describe to occur, and removing the #ifdef fixes it.
I haven't looked into the code much to see what this is going
to break yet..

> The endianness issue is a good deal uglier.  The root cause of the
> problem is that the PPTP conntrack patch adds a 32 bit element to
> the union ip_conntrack_manip_proto and also to the corresponding
> destination portion of ip_conntrack_tuple, making them both a mix
> of 16 bit and 32 bit elements.
<snip>
> Unfortunately this idiom exists in a number of places.  I'm in
> the process of looking for more, but I have already found and fixed
> two bugs caused by this endianness issue.  Diffs are attached below.

I came across this also in the past week.  The only additional
occurences I have found are a few places in the h323 patch.

-- 
Philip Craig     Software Engineer     http://www.SnapGear.com
philipc@snapgear.com  Ph: +61 7 3435 2821  Fx: +61 7 3891 3630
SnapGear  -  Custom Embedded Solutions and Security Appliances
