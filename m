From: "Sumit Pandya" <sumit@elitecore.com>
Subject: Re: Difference between match and target
Date: Wed, 25 Jun 2003 11:59:06 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <005301c33ae3$141da460$010f430a@elitecore7>
References: <20030624170402.8564.54425.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <laforge@netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald and All,
    Then do Netfilter core team or Netfilter individual module authors will
think of reconsidering this policy? Like ipt_foo and ipt_FOO can be combined
in one kernel module and that module will call both ipt_register_match and
ipt_register_target in MODULE_INIT. In my point of view if we are inserting
2 modules then it is definitely consuming extra (some) memory of kernel.
-- Sumit

> Date: Tue, 24 Jun 2003 18:08:24 +0200
> From: Harald Welte <laforge@netfilter.org>
>
> On Fri, Jun 20, 2003 at 06:33:58PM +0530, Sumit Pandya wrote:
> >     What is difference between writing match and target extension for
> > netfilter? Is there something in match which I cannot achieve in target
a=
> nd
> > vice-versa?
>
> From a technical point of view, there is not much differrence.
> There are no technical restrictions, it's a mere policy:
> Matches match against packet data
> Targets connect some action with previously matched packets.
