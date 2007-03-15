From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFCT_Q_DUMP problem
Date: Thu, 15 Mar 2007 01:45:24 +0100
Message-ID: <45F89724.1080608@trash.net>
References: <45F4B34F.3020007@ipom.com>
	<45F527F2.40404@netfilter.org>	<45F6558A.2070601@ipom.com>
	<45F671CA.6010401@netfilter.org> <45F7A20A.5050302@ipom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@netfilter.org
To: Phil Dibowitz <phil@ipom.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F7A20A.5050302@ipom.com>
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

Phil Dibowitz wrote:
> So I sat down to write some test code today on the new API, and I found all
> the nice getter functions, which are awesome... but I can't seem to make the
> new API work with NFCT_Q_DUMP. I shrunk down my test the bare minimum and
> nfct_query *always* returns errno for "Address family not supported by
> protocol" :(
> 
> new_api_test.c doesn't test the NFCT_Q_DUMP query, so I'm wondering if it's
> perhaps a problem in the NFCT_Q_DUMP query type.
> 
> Here's some sample code:
> 
> [phil@rider nftest]$ cat minitest.c
> [...]
>
> When I run this I get:
>   [phil@rider nftest]$ sudo ./minitest
>   dump failed(-1): Address family not supported by protocol


Works fine for me with latest libnfnetlink/libnetfilter_conntrack.
