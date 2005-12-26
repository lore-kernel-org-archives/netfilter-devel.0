From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: flush current NAT  mappings.
Date: Mon, 26 Dec 2005 13:52:15 +0100
Message-ID: <43AFE77F.2040809@eurodev.net>
References: <1512650062.20051226104726@vkt.lt>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jarek <hugle@vkt.lt>
In-Reply-To: <1512650062.20051226104726@vkt.lt>
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

Jarek wrote:
> I was playing with iptables and came to idea, that sometimes I need
> to flush current NAT mappings (not iptables rules).
> I think  I should clear somewhere from conntrack tables, but where?

You can flush the whole conntrack table with the conntrack-tool:

http://www.netfilter.org/projects/conntrack/index.html

-- 
Pablo
