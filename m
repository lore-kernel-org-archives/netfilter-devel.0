From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/3] OSF: code beautification.
Date: Sat, 11 Jun 2005 20:44:19 +0400
Message-ID: <20050611204419.67e0ef47@zanzibar.2ka.mipt.ru>
References: <20050530002000.4c63b34b@zanzibar.2ka.mipt.ru>
	<42AB11B1.6010605@trash.net>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42AB11B1.6010605@trash.net>
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

On Sat, 11 Jun 2005 18:30:41 +0200
Patrick McHardy <kaber@trash.net> wrote:

> Evgeniy Polyakov wrote:
> > { placement, copyright data change, list_for_each_entry usage.
> 
> The patch fails to apply cleanly:
> 
> patching file linux-2.6/net/ipv4/netfilter/ipt_osf.c

...
> 
> It looks like the patch is against the 2.4 version. This is one
> of the rejects:

It should be on top of "[0/3] OSF: resurect skb fragmentation patch.".
This patch was applied against 2.4 tree half of a year ago...

...

> Please fix this up and resend the entire patchset.

please try apply "[0/3] OSF: resurect skb fragmentation patch." first,
it must fix above[skipped] issue.
 
> Regards
> Patrick


	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
