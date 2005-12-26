From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: fixes for ipv6 supported conntrack and libnetfilter_conntrack
Date: Mon, 26 Dec 2005 04:26:54 +0100
Message-ID: <43AF62FE.4050407@eurodev.net>
References: <200512250736.jBP7aL0B014707@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512250736.jBP7aL0B014707@toshiba.co.jp>
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

Hi Yasuyuki,

Yasuyuki KOZAKAI wrote:
> I played with your patches for IPv6 support to conntrack and
> libnetfilter_conntrack. Please consider applying following fixes
> on top of you patches.
> 
> [PATCH 1/2] conntrack: fix incomplete copying IPv6 addresses
> [PATCH 2/2] conntrack: check address family mismatch
> [PATCH 1/1] libnetfilter_conntrack: fix dumping IPv6 connections

Thanks a lot for all the patches.

I just committed the IPv6 support to SVN. Therefore, IMO we are ready
for the 1.0rc1 of the conntrack-tool, together with the new version
(0.0.30) of libnetfilter_conntrack. This could speed up the testing
process. At this point, the tool contains the features that I had in
mind for the 1.0 release. Harald?

Comments welcome.

-- 
Pablo
