From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] psd option parsing
Date: Sat, 18 Sep 2004 19:46:16 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <414C7468.2090000@trash.net>
References: <20040917234902.GA1131@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20040917234902.GA1131@linuxace.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Phil Oester wrote:

>psd match is too greedy with options, and doesn't play well with
>other matches.  For example:
>
>	# iptables -A INPUT -m psd -m recent --set -j DROP
>	iptables v1.2.11: missing optarg
>	Try `iptables -h' or 'iptables --help' for more information.
>
>Below patch makes it less greedy.
>
>This fixes bugzilla #18
>  
>
Applied, thanks.

>Phil
>
