From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack hash function comparison
Date: Sat, 1 Feb 2003 07:57:01 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030201065701.GC23640@oknodo.bof.de>
References: <15916.59019.853598.788888@isis.cs3-inc.com> <Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu> <15917.31840.767508.76359@isis.cs3-inc.com> <20030131114145.GS9073@naboo.cybercafe42> <15931.6072.971476.262073@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Harald Welte <laforge@gnumonks.org>,
  Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
  netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netf@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <15931.6072.971476.262073@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, Jan 31, 2003 at 04:41:28PM -0800, Don Cohen wrote:
> Harald Welte writes:
>  > not that I totally disagree with rehashing being a good idea... but in
>  > the case you add this 'small piece of code', you also introduce a new
>  > vulnerability: If somebody can provoke the firewall to rehash all the
>  > time ;(
> The counter argument is that if they can do that then they have a way
> of causing lots of connections to go into the same bucket, and allowing
> that to happen is (at least in the extreme case) much worse than
> rehashing.  Obviously it's also bad to rehash too eagerly.
> I think the only question is where to put the threshold.

I imagine that instead of, or in addition to, a threshold on list
lengths, I would like to have a "minimum time between rehashings" knob,
set to e.g. one hour. That way, the cost is guaranteed independant of
packet arrival rate. And, to practically disable rehashing, that knob
can be set to an immensely large value.

Hmm. Maybe even with a printk() 10 (N) minutes in advance, telling the
admin "I think I'm going to rehash a bit, soon".

No. Forget about all that.

1) metrics in /proc, including a "max list length during the last hour"
   statistic.
2) one read/writable /proc entry, containing an integer: the number of
   hash buckets. This is missing right now, anyway (have to grep the
   boot messages). Make it writable, and rehash exactly when a write
   changes the hash bucket count.

This way, the policy (when to rehash) is safely in user space, the
kernel gives mechanism, only - just like it should.

What do you think?

best regards
  Patrick
