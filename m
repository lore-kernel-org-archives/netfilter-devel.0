From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] account match seq_file update [RESEND of RESEND]
Date: Mon, 27 Sep 2004 15:38:23 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415817CF.3010007@trash.net>
References: <20040926100202.GA8843@barbara.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-15?Q?Piotr_Gasid=B3o?=
	<quaker@pandora.barbara.ds.polsl.gliwice.pl>
In-Reply-To: <20040926100202.GA8843@barbara.eu.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Piotr Gasid³o wrote:

>Hello,
>
>This is fourth try to send this patch. Last three mails were not
>noticed on group :/
>  
>

Just CC me on patches.

>Changes (0.1.16 to 0.1.17):
>- use of seq_file API in /proc/net/ipt_account/*
>- code cleanup
>
>Patch includes updates for both 2.4 and 2.6.
>
>Please apply.
>  
>

Applied. iptables-based accounting is deprecated, so I expect
we will remove the account/ACCOUNT match from pom-ng at some
point.

Regards
Patrick
