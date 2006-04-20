From: Patrick McHardy <kaber@trash.net>
Subject: Re: Packet Delay using Netfilter
Date: Thu, 20 Apr 2006 20:52:43 +0200
Message-ID: <4447D87B.5010406@trash.net>
References: <ba7fdfc10604200945v417f2689wef8709d59b67a1c2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Srinivas Krishnan <shrin_krishnan@yahoo.com>
In-Reply-To: <ba7fdfc10604200945v417f2689wef8709d59b67a1c2@mail.gmail.com>
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

Srinivas Krishnan wrote:
> I am trying to create a module that adds delay to certain egress
> packets. I am using the NF_IP_POST_ROUTING hook.

Why are you not doing this on the qdisc layer?
