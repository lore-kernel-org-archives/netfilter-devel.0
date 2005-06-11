From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: [1/3] OSF: code beautification.
Date: Sat, 11 Jun 2005 21:54:52 +0400
Message-ID: <20050611215452.478b6bc2@zanzibar.2ka.mipt.ru>
References: <20050530002000.4c63b34b@zanzibar.2ka.mipt.ru>
	<42AB11B1.6010605@trash.net>
	<20050611204419.67e0ef47@zanzibar.2ka.mipt.ru>
	<42AB17D7.4060007@trash.net>
Reply-To: johnpol@2ka.mipt.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42AB17D7.4060007@trash.net>
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

On Sat, 11 Jun 2005 18:56:55 +0200
Patrick McHardy <kaber@trash.net> wrote:

> Evgeniy Polyakov wrote:
> > please try apply "[0/3] OSF: resurect skb fragmentation patch." first,
> > it must fix above[skipped] issue.
> 
> Thanks, I've applied all patches. There still was on reject in
> include/linux/netfilter_ipv4/ipt_osf.h, but I fixed it up manually.

Thank you.
I will try to set svn up and will report if anything goes wrong.

	Evgeniy Polyakov

Only failure makes us experts. -- Theo de Raadt
