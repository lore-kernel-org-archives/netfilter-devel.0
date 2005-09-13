From: Amin Azez <azez@ufomechanic.net>
Subject: ip_conntrack mixed with nf_conntrack and nf_conntrack_ipv6
Date: Tue, 13 Sep 2005 13:07:55 +0100
Message-ID: <4326C11B.6060607@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I'm just checking, I believe it is safe to mix ip_conntrack with
nf_conntrack and nf_conntrack_ipv6 as long as I don't load
nf_conntrack_ipv4 at the same time as ip_conntrack?

Sam
