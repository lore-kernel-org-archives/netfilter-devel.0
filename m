From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: stable fixes for nf_conncount 4.19.x
Date: Fri, 18 Jan 2019 02:24:14 +0100
Message-ID: <20190118012413.o6daeeruqqtaqp7y@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: stable@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Greg,

Could you cherry-pick the follow list of patches into -stable 4.19.x, please?

a007232066f6 netfilter: nf_conncount: fix argument order to find_next_bit
c80f10bc973a netfilter: nf_conncount: speculative garbage collection on empty lists
2f971a8f4255 netfilter: nf_conncount: move all list iterations under spinlock
df4a90250976 netfilter: nf_conncount: merge lookup and add functions
e8cfb372b38a netfilter: nf_conncount: restart search when nodes have been erased
f7fcc98dfc2d netfilter: nf_conncount: split gc in two phases
4cd273bb91b3 netfilter: nf_conncount: don't skip eviction when age is negative
c78e7818f16f netfilter: nf_conncount: replace CONNCOUNT_LOCK_SLOTS with CONNCOUNT_SLOTS

conncount infrastructure is not in good shape, for more details see:

https://bugzilla.kernel.org/show_bug.cgi?id=202013

Thanks.
