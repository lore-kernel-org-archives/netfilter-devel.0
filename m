From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: string match
Date: Sat, 17 Dec 2005 02:07:22 +0100
Message-ID: <43A364CA.6090200@eurodev.net>
References: <43A2CAD0.29490.646F653@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Don Hughes <dhughes@microtechniques.com>
In-Reply-To: <43A2CAD0.29490.646F653@localhost>
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

Don Hughes wrote:
> Trying to compile iptables 1.3.4 against a 2.6.8 kernel 
> and am getting error on the ipt-string.c code:
> 
> extensions/libipt_dscp_helper.c:69: warning: 
> `dscp_to_name' defined but not used
> extensions/libipt_CLUSTERIP.c: In function 
> `final_check':
> extensions/libipt_CLUSTERIP.c:173: warning: suggest 
> parentheses around comparison in operand of &
> extensions/libipt_string.c: In function `init':
> extensions/libipt_string.c:61: error: structure has no 
> member named `to_offset'

The string match is available since kernel 2.6.14. Another reason can be
that you're using an old patch that used to be available in pom-ng, in
that case, such patch is obsolete.

-- 
Pablo
