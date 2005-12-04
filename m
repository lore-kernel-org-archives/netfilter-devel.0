From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] nf_conntrack: Fix missing check for ICMPv6 type
Date: Sun, 04 Dec 2005 16:03:30 +0100
Message-ID: <43930542.3060503@trash.net>
References: <200512031622.jB3GM7ms018056@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512031622.jB3GM7ms018056@toshiba.co.jp>
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
> Hi,
> 
> This makes nf_conntrack_icmpv6 check that ICMPv6 type isn't < 128
> to avoid access out of valid_new[] and invmap[].

Applied, thanks Yasuyuki. I'll push it forward tonight.
