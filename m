From: Patrick McHardy <kaber@trash.net>
Subject: Re: Netfilter assertions
Date: Mon, 20 Sep 2004 05:34:39 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414E4FCF.4020006@trash.net>
References: <20040919192242.4c3dd9ee@laptop.delusion.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Linux Network Mailing List <linux-net@vger.kernel.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
In-Reply-To: <20040919192242.4c3dd9ee@laptop.delusion.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Udo A. Steinberg wrote:

>Hi,
>
>With 2.6.9-rc2 I'm occasionally seeing the following message:
>
>NF_IP_ASSERT: net/ipv4/netfilter/ip_conntrack_core.c:658(init_conntrack)
>
>Something worth investigating or is it harmless?
>
You can ignore it. I thought we already killed that one.
It asserts conntrack->master && conntrack->master->expectant
are set, but conntrack->master is assigned two lines below.

Regards
Patrick


>
>-Udo.
>
