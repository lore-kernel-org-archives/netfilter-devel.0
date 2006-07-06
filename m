From: "Martijn Lievaart" <m@rtij.nl>
Subject: Re: early_drop() not working correctly?
Date: Thu, 6 Jul 2006 16:41:46 +0200 (CEST)
Message-ID: <33118.4010756717$1152197074@news.gmane.org>
References: <44AD1D10.6000208@netboxblue.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44AD1D10.6000208@netboxblue.com>
To: "Menno Smits" <menno@netboxblue.com>
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

<citaat van="Menno Smits">
>
> ps. We have worked around the issue at the client's site by using the
> NOTRACK target for the asymmetrically routed traffic. Turning off TCP
> connection pickup also works around the problem.

IMHO that's not the workaround, that's how it should be setup. That does
not mean the bug is not real.

HTH,
M4
