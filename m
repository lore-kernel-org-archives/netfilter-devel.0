From: "David S. Miller" <davem@redhat.com>
Subject: Re: ip_conntrack_hash() problem
Date: Wed, 04 Sep 2002 23:32:26 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <18520.8893883557$1031208076@news.gmane.org>
References: <20020905082128.D19551@oknodo.bof.de>
	<20020904.232425.10994370.davem@redhat.com>
	<20020905083340.E19551@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, ak@suse.de, laforge@gnumonks.org,
        netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: bof@bof.de
In-Reply-To: <20020905083340.E19551@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   From: Patrick Schaaf <bof@bof.de>
   Date: Thu, 5 Sep 2002 08:33:40 +0200
   
   So, I don't see how your (abstractly true) observation is relevant, here.
   
So we waste 4 bytes in the kernel for really no reason?
A value we can compute in half a cycle?
