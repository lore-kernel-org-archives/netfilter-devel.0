From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack hash function comparison
Date: Fri, 31 Jan 2003 23:58:37 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15931.32301.797460.620368@isis.cs3-inc.com>
References: <15916.59019.853598.788888@isis.cs3-inc.com>
	<Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu>
	<15917.31840.767508.76359@isis.cs3-inc.com>
	<20030131114145.GS9073@naboo.cybercafe42>
	<15931.6072.971476.262073@isis.cs3-inc.com>
	<20030201065701.GC23640@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@gnumonks.org>,
   Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20030201065701.GC23640@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Patrick Schaaf writes:
 > On Fri, Jan 31, 2003 at 04:41:28PM -0800, Don Cohen wrote:
 > > Harald Welte writes:
 > >  > not that I totally disagree with rehashing being a good idea... but in
 > >  > the case you add this 'small piece of code', you also introduce a new
 > >  > vulnerability: If somebody can provoke the firewall to rehash all the
 > >  > time ;(
 > > The counter argument is that if they can do that then they have a way
 > > of causing lots of connections to go into the same bucket, and allowing
 > > that to happen is (at least in the extreme case) much worse than
 > > rehashing.  Obviously it's also bad to rehash too eagerly.
 > > I think the only question is where to put the threshold.
 > 
 > I imagine that instead of, or in addition to, a threshold on list
 > lengths, I would like to have a "minimum time between rehashings" knob,
 > set to e.g. one hour. That way, the cost is guaranteed independant of
 > packet arrival rate. And, to practically disable rehashing, that knob
 > can be set to an immensely large value.

I don't understand the utility of such a control.
Why should you rehash if the table is doing ok?
Conversely, if it's not, why should you suffer for an hour?

 > 1) metrics in /proc, including a "max list length during the last hour"
 >    statistic.
not very practical if you think about it
More reasonable: longest bucket length since last rehash
If you really want to take the time to look at such things, I'd suggest
a list of lengths of all buckets.

 > 2) one read/writable /proc entry, containing an integer: the number of
 >    hash buckets. This is missing right now, anyway (have to grep the
 >    boot messages). Make it writable, and rehash exactly when a write
 >    changes the hash bucket count.
It's currently a module parameter?  Not that it would be so hard to
change it at run time, but is that really so useful?
You could unload the module and reload it with a different parameter.  
If the complaint is that you then lose the data, I suggest using the
proc file to save and restore (copy the /proc data to a real file, then
copy it back after unload/reload).  That would even let you save and 
restore over a reboot.


 > This way, the policy (when to rehash) is safely in user space, the
 > kernel gives mechanism, only - just like it should.
/proc control over the rehash threshold (max bucket size) seems like
an appropriate "control over policy".  
Whereas a user space program doing something to cause a rehash seems
to me to be a bad choice.  (For one thing, when the kernel gets into 
trouble the user space program might never have a chance to run.)
