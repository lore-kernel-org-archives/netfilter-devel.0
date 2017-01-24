From: Jiri Kosina <jikos@kernel.org>
Subject: [RFC PATCH 0/2] restore original default of nf_conntrack_helper
 sysctl
Date: Tue, 24 Jan 2017 01:06:18 +0100 (CET)
Message-ID: <alpine.LSU.2.20.1701240038080.25515@cbobk.fhfr.pm>
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

After I've upgraded backbone router of rather large-ish network to 4.9, 
users started complaining about their GRE / PPTP tunnels not working any 
more.

Long time of staring into code revealed that 4.9 kernel has

	static bool nf_ct_auto_assign_helper __read_mostly = false;

which causes automatic matching of conntrack helpers not to work any more. 
Turns out the default was flipped in 3bb398d925 ("netfilter: nf_ct_helper: 
disable automatic helper assignment") (*) in 4.7.

Digging further back into history, it turns out that the kernel started to 
print a warning message about automatic helper assignment being deprecated 
in 3.5+; given the fact that this message is ususally burried somewhere 
deep in the boot sequence (and therefore hardly noticed by each and every 
router admin on the planet), and given the fact that this has proven 
itself to severely break at least mine router config (which has been 
working for years), I propose to revert the patches flipping the default. 
Anyone is still of course free to set up an explicit CT-based matching for 
better reliability, but the automatic assignment should stay.

Considering this being really close to the "userspace breakage" 
borderline, I'm CCing Linus as well.

(*) the changelog of that commit is odd by itself as well, as it 
references SHA-1 72110dfaa907, but that doesn't exist in my tree at least.

Jiri Kosina (2):
      Revert "netfilter: nf_ct_helper: disable automatic helper assignment"
      Revert "netfilter: fix nf_conntrack_helper documentation"

 Documentation/networking/nf_conntrack-sysctl.txt | 7 ++-----
 net/netfilter/nf_conntrack_helper.c              | 4 ++--
 2 files changed, 4 insertions(+), 7 deletions(-)

-- 
Jiri Kosina
SUSE Labs
