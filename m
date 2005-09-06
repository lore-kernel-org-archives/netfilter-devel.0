From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 0/8]: Netfilter update
Date: Tue, 06 Sep 2005 19:55:15 +0200
Message-ID: <431DD803.7070801@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Hi Dave,

following are a couple of patches which include a new conntrack helper
for netbios, two small cleanup patches and a couple of fixes. Please
apply.


[NETFILTER 1/8]: Add support for permanent expectations
[NETFILTER 2/8]: Add NetBIOS name service helper
[NETFILTER 3/8]: Fix CONNMARK Kconfig dependency
[NETFILTER 4/8]: Handle NAT module load race
[NETFILTER 5/8]: Fix HW checksum handling in nfnetlink_queue
[NETFILTER 6/8]: Don't increase master refcount on expectations
[NETFILTER 7/8]: kill __ip_ct_expect_unlink_destroy
[NETFILTER 8/8]: Missing unlock in TCP connection tracking error path
