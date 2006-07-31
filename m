From: KOVACS Krisztian <hidden@balabit.hu>
Subject: [PATCH 0/6] pkg-config patches for libnetfilter_* userspace
	libraries and their users
Date: Mon, 31 Jul 2006 10:22:46 +0200
Message-ID: <200607311022.46466@nienna>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

  As there were no objections raised on the mailing list, here come the 
pkg-config patches again.

  These patches modify autoconf scripts so that they use pkg-config to 
detect the presence of libnfnetlink and other dependencies and use the 
correct include and library names and paths.

-- 
 Regards,
  Krisztian Kovacs
