From: Juha Heljoranta <juha.heljoranta@evtek.fi>
Subject: arbitary length matchinfo
Date: Fri, 15 Apr 2005 14:32:08 +0300
Message-ID: <425FA638.5010601@evtek.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

Is it possible to create arbitary length matchinfo? I couldn't find any
info on this.

What I want is an path:

	struct ipt_foo_info {
		char *path;
	}

maximum path length in Linux is 4096 and doing

	struct ipt_foo_info {
		char path[4096];
	}

is bit crazy.

Regards,
Juha Heljoranta
