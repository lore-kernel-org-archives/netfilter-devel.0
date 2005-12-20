From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: [PATCH] ipv6 support for libnetfilter_conntrack
Date: Tue, 20 Dec 2005 01:25:41 +0100
Message-ID: <43A74F85.1010203@eurodev.net>
References: <43A71EDD.3000805@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <43A71EDD.3000805@eurodev.net>
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

Pablo Neira Ayuso wrote:
> Hi Yasuyuki,
> 
> JFYI: I just added support for ipv6 to libnetfilter. I'll commit the
> changes by myself once the new version of libnetfilter_conntrack is
> released.
> 
> http://people.netfilter.org/pablo/libnetfilter-conntrack-ipv6.patch

And the conntrack-tool patch, still untested:

http://people.netfilter.org/pablo/conntrack-ipv6.patch

-- 
Pablo
