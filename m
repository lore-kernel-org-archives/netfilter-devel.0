From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Thu, 23 Feb 2006 10:43:32 +0100
Message-ID: <43FD83C4.6030106@trash.net>
References: <43F44794.1080203@trash.net>	<20060216100504.GI15587@sunbeam.de.gnumonks.org>	<43F4DC55.8030405@trash.net>
	<200602211216.k1LCG18I024522@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200602211216.k1LCG18I024522@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Thu, 16 Feb 2006 21:11:01 +0100
> 
>>Yes, but until then it looks totally redundant. Since the bandwidth
>>of netlink is limited, I think we shouldn't add new attributes without
>>really needing them.
> 
> 
> 'l3num' field in expectation mask may be 0xff. Then the new field is
> necessary so that kernel can pass the "exact value" in it to userspace.
> 
> But, I don't know whether userspace really wants to know the exact value
> in it or not. I assumed, yes, but if it is not ture, I'll agree to Patrick.

My point was that a mask is pretty meaningless without the thing it
masks, which is the tuple (except maybe a mask of all-zeros). The tuple
itself already contains the correct protocol number.
