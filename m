From: Jiri Kosina <jikos@kernel.org>
Subject: [PATCH 2/2] Revert "netfilter: fix nf_conntrack_helper
 documentation"
Date: Tue, 24 Jan 2017 01:06:27 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701240058540.25515@cbobk.fhfr.pm>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, info@jablonka.cz,
        Linus Torvalds <torvalds@linux-foundation.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

This reverts commit 486dcf43da7815baa615822f3e46883ccca5400f. The commit 
that flipped the default has been reverted as well.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

---
 Documentation/networking/nf_conntrack-sysctl.txt | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/Documentation/networking/nf_conntrack-sysctl.txt b/Documentation/networking/nf_conntrack-sysctl.txt
index 497d668288f9..cdeb9d6a44c7 100644
--- a/Documentation/networking/nf_conntrack-sysctl.txt
+++ b/Documentation/networking/nf_conntrack-sysctl.txt
@@ -62,13 +62,10 @@ nf_conntrack_generic_timeout - INTEGER (seconds)
 	protocols.
 
 nf_conntrack_helper - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	0 - disabled
+	not 0 - enabled (default)
 
 	Enable automatic conntrack helper assignment.
-	If disabled it is required to set up iptables rules to assign
-	helpers to connections.  See the CT target description in the
-	iptables-extensions(8) man page for further information.
 
 nf_conntrack_icmp_timeout - INTEGER (seconds)
 	default 30
-- 
2.11.0
