From: don-nf@isis.cs3-inc.com (Don Cohen)
Subject: Re: performance issues (nat / conntrack)
Date: Sun, 23 Jun 2002 23:54:20 -0700
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <15638.49692.902811.4513@isis.cs3-inc.com>
References: <20020623132739.12D52455E@lists.samba.org>
	<15638.42021.31206.821255@isis.cs3-inc.com>
	<20020624080618.Q5183@oknodo.bof.de>
	<15638.48245.84830.480715@isis.cs3-inc.com>
	<20020624084836.R5183@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.samba.org
Return-path: <netfilter-devel-admin@lists.samba.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20020624084836.R5183@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:
 > Don,
 > 
 > (hope you don't mind me replying on-list)
No, I just hope the rest of the list doesn't mind.

 > The relative slowness of conntrack vs. nonconntrack doesn't matter in the
 > real world. I can reproduce it in artificial tests, but in reality, the
 > arrival rates for new connections are lower. The reason, at least for me,
 > is that I parallelize on multiple boxes long before conntrack reaches its
 > breaking point, and I do that for different reasons (resilience and the
 > other workload the boxes tend to have, like user level proxying.)
It seems to me like a real problem when you're under attack.
It means that a syn flood at a relatively low rate is effective.
But I don't think that the hash function is the problem in that case.
In fact, there is no hash function that solves that problem, since the
attacker can always feed you data that ruins the hash function, unless
of course you want the function to differ from one machine to the next
and in effect be another secret.
I suggest instead that the hash lookup be limited to a small number of
probes.  If not found in, say, 10 probes, act like it's not there and
the table is full.  The attacker can still attack some particular
bucket(s) (which doesn't do a lot of good - he's denying service to
some small number of customers but has no control over which ones),
but not the whole machine. 

 > >  > As for theories, the last time, we almost agreed that the hash function
 > >  > is very bad. Nobody did confirm that feeling, though.
 > > What's wrong with the hash function?
 > 
 > It's suspected to be bad. Chains are suspected to become long. Bucket
 > occupation is suspected to have high variance. Nobody checked, or at
 > least nobody reported the results of such checking.
To me something like the sum of IP's and ports all mod something
that is not a multiple of 2 seems ideal.  I suppose it's something
like that.
