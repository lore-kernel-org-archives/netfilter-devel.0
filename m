From: "Pavel A. Nekrasov" <pnekrasov@gmail.com>
Subject: Re: [1/1] OSF: pom-ng - linux-2.6.
Date: Wed, 8 Dec 2004 14:32:33 +0100
Message-ID: <fa78a99804120805326fed423b@mail.gmail.com>
References: <1102503533.3363.48.camel@uganda>
Reply-To: "Pavel A. Nekrasov" <pnekrasov@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <1102503533.3363.48.camel@uganda>
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

i got you doing the same.

Evgeniy Polyakov wrote:

>+      nts = netlink_kernel_create(NETLINK_NFLOG, NULL);

drivers/w1/w1_int.c:    dev->nls = netlink_kernel_create(NETLINK_NFLOG, NULL);

NETLINK_NFLOG is used by ipt_ULOG, you can't use that socket because
you are breaking compatibility. You have to use different sockets,
call davem and request new ones.

kind regards,
Pavel
