From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH 1/1] libnetfilter_conntrack: fix dumping IPv6 connections
Date: Mon, 26 Dec 2005 04:07:21 +0100
Message-ID: <43AF5E69.9050807@eurodev.net>
References: <200512250737.jBP7b2Lg011139@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200512250737.jBP7b2Lg011139@toshiba.co.jp>
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
> [LIBNETFILTER_CONNTRACK] fix dumping IPv6 connections
> 
> This fixes the pointer in buffer to store string of destination IPv6 address.

Good catch. Applied. Thanks.

-- 
Pablo
