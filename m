From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/2] Fix compile with NAT but without modules
Date: Mon, 24 Jan 2005 01:33:47 +0100
Message-ID: <41F4426B.3040204@trash.net>
References: <1106440732.20995.48.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1106440732.20995.48.camel@tux.rsn.bth.se>
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

Hi Martin,

Martin Josefsson wrote:

>Hi Patrick
>
>Here's another patch to fix compile-errors, this time with NAT but
>without modules.
>There's a missing 'extern' in ip_conntrack_tftp.h
>
>Please submit this patch to davem for inclusion in 2.6.11
>
I'll apply your patches and push them to Dave tomorrow, bkbkits.com
is unreachable currently so I can't resync my tree.

Regards
Patrick
