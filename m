From: Patrick Schaaf <bof@bof.de>
Subject: Re: ip_conntrack_hash() problem
Date: Thu, 5 Sep 2002 08:39:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020905083932.F19551@oknodo.bof.de>
References: <20020905082128.D19551@oknodo.bof.de> <20020904.232425.10994370.davem@redhat.com> <20020905083340.E19551@oknodo.bof.de> <20020904.233226.108195359.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: bof@bof.de, rusty@rustcorp.com.au, ak@suse.de, laforge@gnumonks.org,
  netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
Content-Disposition: inline
In-Reply-To: <20020904.233226.108195359.davem@redhat.com>; from davem@redhat.com on Wed, Sep 04, 2002 at 11:32:26PM -0700
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 04, 2002 at 11:32:26PM -0700, David S. Miller wrote:
>    
>    So, I don't see how your (abstractly true) observation is relevant, here.
>    
> So we waste 4 bytes in the kernel for really no reason?
> A value we can compute in half a cycle?

Sorry, but I was under the impression that code readability was worth
the occasional static-global additional 4 bytes. I must have been
mistaken.

best regards
  Patrick
