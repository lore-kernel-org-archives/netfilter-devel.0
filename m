From: Max Kellermann <max@duempel.org>
Subject: [PATCH pom-ng 0/5] RFC: ip_nat|conntrack_h323.c on 2.6,
	first preview
Date: Wed, 19 Jan 2005 01:43:32 +0100
Message-ID: <20050119004332.GA12629@roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Robert Iakobashvili <roberti@GoNetworks.com>
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

I have worked a bit on porting the H.323 conntrack module to Linux
2.6. Here is my first preview. Both connection tracking and NAT work
well in my home network (gnomemeeting and ohphone, tunneling
disabled).

It's still the old brute force method, no real protocol evaluation is
performed. I will implement that the "right" way after the port to the
Linux 2.6 API is finished and tested. The current algorithm is not
recommended for production environments, because it is insecure,
sometimes buggy and horribly inefficient.

The patches apply to patch-o-matic-ng from svn. Due to recent API
changes, you need kernel 2.6.10-mm2 or later. I am currently using
2.6.11-rc1.

Using the module is easy: patch your kernel as usual with
patch-o-matic-ng, enable H.323 connection tracking and NAT in the
kernel configuration, boot the new kernel. Now the module should see
all incoming, outgoing and forwarded TCP connections on port 1720, and
lets the state module know about them.

I would appreciate comments and discussion about my patches and the
H.323 module.

Max
