From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ipt_connlimit / speed-up.
Date: Sun, 24 Apr 2005 18:26:12 +0200
Message-ID: <426BC8A4.9010402@trash.net>
References: <200504210510.01886.pluto@pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pawel Sikora <pluto@pld-linux.org>
In-Reply-To: <200504210510.01886.pluto@pld-linux.org>
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

Pawel Sikora wrote:
> Hi All,
> 
> I've attached a small patch reduces register usage and redundant &0xff.
>
> -static int ipt_iphash(u_int32_t addr)
> +static inline unsigned __attribute__((regparm(1), const))

Why do you need attribute(regparm) for an inline function?

Regards
Patrick
