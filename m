From: Art Haas <ahaas@airmail.net>
Subject: Recent C99 patches to net/ipv4/netfilter
Date: Tue, 11 Mar 2003 14:27:50 -0600
Sender: linux-net-owner@vger.kernel.org
Message-ID: <20030311202750.GC4808@debian>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-net-owner@vger.kernel.org>
To: linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Id: netfilter-devel.vger.kernel.org

Hi.

I'd recently sent a set of patches for converting some structures to use
C99 named initializers, and it looks like they've been sent to Linus,
but somehow got applied incorrectly. The changes for the ipv6 netfilter
code are present, but the ones for ipv4 netfilter aren't, yet the BK
SCCS files indicate that the changes were applied. My copy of Linus's
tree has changeset 1.1085 to be the ipv4 netfilter changes that contain
the patches in question.

Should I send the patches again, or is this something that can be
resolved by Linus repulling the changeset?

Art Haas

-- 
They that can give up essential liberty to obtain a little temporary safety
deserve neither liberty nor safety.
 -- Benjamin Franklin, Historical Review of Pennsylvania, 1759
