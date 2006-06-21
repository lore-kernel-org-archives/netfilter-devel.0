From: Alex Davis <alex14641@yahoo.com>
Subject: Re: [RFC][1/2] New netfilter match module : kernel patch
Date: Tue, 20 Jun 2006 20:44:00 -0700 (PDT)
Message-ID: <20060621034400.20413.qmail@web50207.mail.yahoo.com>
References: <449895EC.5060603@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Alex Davis <alex14641@yahoo.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>, Patrick McHardy <kaber@trash.net>
In-Reply-To: <449895EC.5060603@snapgear.com>
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

--- Philip Craig <philipc@snapgear.com> wrote:

> On 06/20/2006 01:38 AM, Patrick McHardy wrote:
> > Alex Davis wrote:
> >> This is an update the kernel netfilter patch that allows 
> >> matching the source or destination address of an IP
> >> packet to a network interface.
> > 
> > I can't see any other way to do this, but I'm not so thrilled to
> > add a whole new match just for this.
> 
> My current solution for this is to reinstall the iptables
> rules from the dhcp client script hooks, or from the ppp
> ip-up script.
> 
I had thought about that, but I think this new match is a cleaner
way to accomplish it.

> Another option that doesn't require reinstalling rules would
> be to use an ipset in the rule, and then use the scripts to
> update the address in the ipset.
Hadn't thought about that, but still.....


I code, therefore I am

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
