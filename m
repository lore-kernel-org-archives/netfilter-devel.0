From: Stephen Hemminger <shemminger@osdl.org>
Subject: ip_conntrack build warning
Date: Wed, 15 Mar 2006 11:23:15 -0800
Message-ID: <20060315112315.6158ad7c@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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

Recent kernels in -mm warn about init section usage in ip_conntrack.
The problem is the init_or_cleanup() style makes it impossible to compile
time checking hard.

WARNING: net/ipv4/netfilter/ip_conntrack.o - Section mismatch:
reference to .init.text:ip_conntrack_init from .text.init_or_cleanup
after 'init_or_cleanup' (at offset 0x12)
