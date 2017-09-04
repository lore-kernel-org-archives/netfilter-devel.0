From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: Signed-off-by missing for commits in the netfilter-next
 tree
Date: Tue, 5 Sep 2017 07:59:36 +1000
Message-ID: <20170905075936.4f46280f@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

Commits

  d1c1e39de835 ("netfilter: remove unused hooknum arg from packet functions")
  44d6e2f27328 ("net: Replace NF_CT_ASSERT() with WARN_ON().")

are missing a Signed-off-by from their committer.

-- 
Cheers,
Stephen Rothwell
