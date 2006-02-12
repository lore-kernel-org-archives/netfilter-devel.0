From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: [LIBNFNETLINK] Fixes and API changes
Date: Sun, 12 Feb 2006 22:38:51 +0100
Message-ID: <43EFAAEB.2010807@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

Hi,

Here comes a set of three patches for libnfnetlink, two bugfixes and one
proposition of changes for the API:

[LIBNFNETLINK 1/3] Add NLMSG_OK checking to nfnl_get_msg_next
[LIBNFNETLINK 2/3] Fix wrong nfnetlink header size
[RFC][LIBNFNETLINK 3/3] API changes

cheers,

-- 
Pablo
