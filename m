From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the vfs tree with the netfilter tree
Date: Thu, 7 Dec 2017 11:10:35 +1100
Message-ID: <20171207111035.7c22d7c0@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jann Horn <jannh@google.com>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        NetFilter <netfilter-devel@vger.kernel.org>
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Al,

Today's linux-next merge of the vfs tree got a conflict in:

  net/netfilter/xt_bpf.c

between commit:

  6ab405114b0b ("netfilter: xt_bpf: add overflow checks")

from the netfilter tree and commit:

  af58d2496b49 ("fix "netfilter: xt_bpf: Fix XT_BPF_MODE_FD_PINNED mode of 'xt_bpf_info_v1'"")

from the vfs tree.

I can't tell if the strlen test from the former is still needed, so I
just used the vfs tree version for now.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

Al, can I convince you to submit fixes to the appropriate maintainers
(or have you done so and it just hasn't been picked up yet)?

-- 
Cheers,
Stephen Rothwell
