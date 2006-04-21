From: Patrick McHardy <kaber@trash.net>
Subject: Re: pom extra/ipsec-0[1-4]-*
Date: Fri, 21 Apr 2006 18:45:04 +0200
Message-ID: <44490C10.1020300@trash.net>
References: <444908C9.1070004@sumnerfamily.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ryan Sumner <ryan@sumnerfamily.com>
In-Reply-To: <444908C9.1070004@sumnerfamily.com>
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

Ryan Sumner wrote:
> Hello, all...my first post to netfilter-devel.
> 
> Went in this morning and checked-out iptables and patch-o-matic-ng.  My
> intent was to add ipsec-01-output-hooks, ipsec-01-input-hooks,
> ipsec-03-policy-lookup, ipsec-04-policy-checks so I can establish ipsec
> on my gateway and have all machines that are masqueraded have the option
> of following routes into the tunnel.  From my readings, these seem to
> the be patches I'm going to need.
> 
> I'm currently running a stock Fedora Core 2 kernel 2.6.10-1.771_FC2.
> 
> I looked at the following page to find the patches that I thought I
> would need and figured that when I ran "runme extra", I would see the
> above referenced patches in there:
> 
> http://netfilter.org/projects/patch-o-matic/pom-extra.html
> 
> Have these patches been moved out of POM?  How can I easily get them
> applied so my iptables, kernel source and functioning?  All your
> assistance is appreciated.  If this post should belong in
> netfilter-user, please excuse me.

The patches have been merged in 2.6.16 and were removed from
patch-o-match because they were quite outdated.
