From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH pom-ng] port TARPIT to linux 2.6.12
Date: Tue, 17 May 2005 21:59:28 +0200
Message-ID: <428A4D20.2050000@trash.net>
References: <20050512182024.GA23331@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Max Kellermann <max@duempel.org>
In-Reply-To: <20050512182024.GA23331@roonstrasse.net>
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

Max Kellermann wrote:
> Hi,
> 
> the following two mini patches port the TARPIT target to linux
> 2.6.12.
> 
> tarpit-01-fix_indent.patch
> - fix the indentation in the source file (tabs)
> 
> tarpit-02-linux_2_6_12_api.patch
> - call dst_mtu() instead of dst_pmtu() on 2.6.12 (conditional)

Both applied, thanks.
