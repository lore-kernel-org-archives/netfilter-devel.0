From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack hash function comparison
Date: Sat, 1 Feb 2003 11:05:54 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15932.6802.868766.543518@isis.cs3-inc.com>
References: <15916.59019.853598.788888@isis.cs3-inc.com>
	<Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu>
	<15917.31840.767508.76359@isis.cs3-inc.com>
	<20030131114145.GS9073@naboo.cybercafe42>
	<15931.6072.971476.262073@isis.cs3-inc.com>
	<20030201065701.GC23640@oknodo.bof.de>
	<15931.32301.797460.620368@isis.cs3-inc.com>
	<20030201083703.GL27870@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Patrick Schaaf <bof@bof.de>, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030201083703.GL27870@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte writes:

 > > Not that it would be so hard to change [hash table size]
     at run time, but is that really so useful?
 > Especially in the case where it is not a kernel module ;)

Well, then you need a way to initialize it.  Is there a standard
solution to this problem?  Or is the inability to choose such values
just the penalty you pay for choosing Y instead of M?

 > > You could unload the module and reload it with a different parameter.  
 > > If the complaint is that you then lose the data, I suggest using the
 > > proc file to save and restore (copy the /proc data to a real file, then
 > > copy it back after unload/reload).  That would even let you save and 
 > > restore over a reboot.
 > 
 > no way. no way. no way.
 > sorry, but read the various discussions about the /proc/ip_conntrack
 > interface in general, think about all the data that is not printed (like
 > references to currently in-kernel packets, connection between
 > expectations and master connection, ...  lots of those issues are
 > relevant for conntrack failover as well.  This is only viable via
 > ctnetlink, which is not part of the stock kernel yet.

This was meant as a general suggestion, not specific to conntrack.

I don't know all the details specific to conntrack.  It seems
surprising that you couldn't save all relevant state via /proc.
Even more so if you think you could do it with netlink.
The stuff above suggests that you're worried about highly volatile
state, but the suggestion is meant only for "stable" states.  
It makes sense to remember connections across a reboot (if it doesn't 
take too long), not packets.  You'd have to effectively disable
networking (so there are no packets to save) before saving state.  

I plan to try it for my module that does conntrack-like things.

 > >  > This way, the policy (when to rehash) is safely in user space, the
 > >  > kernel gives mechanism, only - just like it should.
 > > /proc control over the rehash threshold (max bucket size) seems like
 > > an appropriate "control over policy".  
 > > Whereas a user space program doing something to cause a rehash seems
 > > to me to be a bad choice.  (For one thing, when the kernel gets into 
 > > trouble the user space program might never have a chance to run.)
 > 
 > yes, I agree.  and that's why i like the idea of a 'min rehash interval'
 > proc parameter.  If you set this to '0', kernel will rehash never.  '1'
 > means maximum of one rehash per second, ...

I think I finally understand what this is all about.
It's not to automatically rehash after time t, but rather to 
make sure you don't spend all of your time rehashing. 
This seems reasonable.
