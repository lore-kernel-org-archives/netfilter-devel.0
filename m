From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/1] missing dependency definition for ip_conntrack mark
Date: Sun, 04 Sep 2005 18:03:56 +0200
Message-ID: <431B1AEC.5050207@trash.net>
References: <200509010353.j813roX3020876@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200509010353.j813roX3020876@toshiba.co.jp>
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
> [NETFILTER] missing dependency definition for ip_conntrack mark
> 
> Connection mark tracking support is one of the feature in connection tracking,
> so IP_NF_CONNTRACK_MARK depends on IP_NF_CONNTRACK.

Applied, thanks Yasuyuki.
