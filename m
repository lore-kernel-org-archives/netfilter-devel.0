From: Max Kellermann <max@duempel.org>
Subject: null bytes in nfsim match?
Date: Tue, 8 Feb 2005 01:36:34 +0100
Message-ID: <20050208003634.GA26067@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I'm currently writing a test suite for the H.323 conntrack module. It
is a binary protocol, and I want to match null bytes.

It looks like the matching code in nfsim (core/expect.c) handles
patterns as null-terminated string. That makes matching null bytes
impossible. Is that correct?

I could develop a patch to fix that, anyone interested?

Max
