From: Patrick Schaaf <bof@bof.de>
Subject: Re: performance issues (nat / conntrack)
Date: Mon, 24 Jun 2002 08:48:37 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020624084836.R5183@oknodo.bof.de>
References: <20020623132739.12D52455E@lists.samba.org> <15638.42021.31206.821255@isis.cs3-inc.com> <20020624080618.Q5183@oknodo.bof.de> <15638.48245.84830.480715@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick Schaaf <bof@bof.de>, netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Don Cohen <don-nf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15638.48245.84830.480715@isis.cs3-inc.com>; from don-nf@isis.cs3-inc.com on Sun, Jun 23, 2002 at 11:30:13PM -0700
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Don,

(hope you don't mind me replying on-list)

On Sun, Jun 23, 2002 at 11:30:13PM -0700, Don Cohen wrote:
> Patrick Schaaf writes:
>  > Nevertheless, it does point out a valid optimization chance. We discussed
>  > that months ago, and it's still there.
> What's that?

Looking at the quality of the hash function used, and improving it.

> 
>  > In the real world, nobody seems to care. I know I don't, and I really
>  > looked. It doesn't matter.
> I'm really lost here.  What doesn't matter?

The relative slowness of conntrack vs. nonconntrack doesn't matter in the
real world. I can reproduce it in artificial tests, but in reality, the
arrival rates for new connections are lower. The reason, at least for me,
is that I parallelize on multiple boxes long before conntrack reaches its
breaking point, and I do that for different reasons (resilience and the
other workload the boxes tend to have, like user level proxying.)

>  > As for theories, the last time, we almost agreed that the hash function
>  > is very bad. Nobody did confirm that feeling, though.
> What's wrong with the hash function?

It's suspected to be bad. Chains are suspected to become long. Bucket
occupation is suspected to have high variance. Nobody checked, or at
least nobody reported the results of such checking.

best regards
  Patrick
