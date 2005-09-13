From: "CK Wang" <ck@ezpacket.com>
Subject: latest ctnetlink for Linux 2.4.XX?
Date: Wed, 14 Sep 2005 00:53:56 +0800
Message-ID: <200509131654.j8DGs07L008682@server.ezpacket.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hello all,

- I found nfnetlink-conntrack-0.13 is deprecated in pom-ng. But, it's a
starting point for me to work on my Linux 2.4.30 kernel.

- However, after done with the patch intergration with Linux 2.4.30. I
couldn't find a compatible libnfnetlink and libctnetlink to work with
nfnetlink-conntrack-0.13. Current libnfnetlink and libctnetlink(or
libnfnetlink-conntrack) are rewritten for Linux 2.6. 

- Is there any kernel patch back ported from 2.6 to 2.4? or any required
libraries can work with the deprecated patches?

 

Cheers,

CK
