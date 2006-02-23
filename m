From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] Fix expectaction mask dumping, take #3
Date: Thu, 23 Feb 2006 12:13:35 +0100
Message-ID: <43FD98DF.4070606@trash.net>
References: <43FBD887.9040409@netfilter.org>	<200602221301.k1MD1lIb015798@toshiba.co.jp>	<43FD8509.9070203@trash.net>
	<200602231110.k1NBA71v013563@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200602231110.k1NBA71v013563@toshiba.co.jp>
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
> Date: Thu, 23 Feb 2006 10:48:57 +0100
> 
> 
>>Harald and me were actually talking about simplifying the helper lookup
>>by making the dst part of an expectation fixed (for ip_conntrack). With
> 
> 
> I got time to read deeply the patch from him yesterday midnight.
> (but that was for nf_conntrack). Simplifying the helper lookup is fine to
> me.

Oops, I actually meant the expectation lookup. But the idea is pretty
similar I think.
