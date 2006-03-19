From: KOVACS Krisztian <hidden@sch.bme.hu>
Subject: Re: Made ct_sync running with 2.6.15.4...
Date: Sun, 19 Mar 2006 22:58:25 +0100
Message-ID: <200603192258.27950@krak>
References: <20060311033122.GA23805@galois.math.uni-paderborn.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Maximilian Wilhelm <max@rfc2324.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20060311033122.GA23805@galois.math.uni-paderborn.de>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Saturday 11 March 2006 04:31, Maximilian Wilhelm wrote:
> I saw that the patches and the module code were written for kernel
> version 2.6.10 and experienced rather big trouble patching kernel
> version 2.6.15.4 :-/

  Sure, the linux-2.6 branch in Subversion is pretty old and largely 
unmaintained. The whole ct_sync project is pretty much dead.

> The only thing I'm worrying about were many ct entries I produced by
> nmap -sP <net behing the firewall>
> which did not vanish after 10++ hours. I had to reboot to get rid of
> the connections.

  This is a known problem, at least back when I was doing some testing 
with ct_sync I experienced the same. Unfortunately I did not manage to 
find the cause of this bug...

> What I did:

  A few generic comments about the attached patches: don't send per-file 
patches. Divide your changes into logically structured patches. If it's 
not possible or not very meaningful (just as in this case) then send a 
single diff appliable using 'patch -p1'.

  Another thing is that you've pretty much garbled the quilt patchset. For 
example ct_notifier_pkt.patch is not necessary anymore for 2.6.14 and up, 
so you should have removed that patch completely from the tree instead of 
just removing basically everything from that patch. pf_packet.patch is 
also similar, although it is still a bit different as it's not included 
in mainline kernel and thus a forward-port would be necessary to provide 
the same functionality.

> I would like someone who knows this code better than me (Harald?) to
> have a look at my changes and comment on it.
> As an absolutly newbie in C and netfilter code I'm hoping I did not
> too much bad things :)

  No, not at all, after all it _seems_ to be working for you :)

  However, merging these changes to SVN would still need some more work. 
As the number of people working on ct_sync is very close to zero at the 
moment, I think that all effort should be concentrated on a single branch 
of the code. Because Harald has already put significant effort into 
providing support for active-active setups I think that we should try and 
get the linux-2.6-multigroup branch working first. Holger Eitzenberger 
was also doing some tests using that version and provided multiple fixes 
for problems he had found.

  So I don't think we should put significant amount of work into updating 
the old 2.6.10 branch. Instead, please give the -multigroup branch a try 
and provide feedback. Of course if you think you have the time to prepare 
an easily-committable patch for the linux-2.6 branch of ct_sync I'll be 
more than happy to update the SVN repository. I'm just unwilling to spend 
a significant amount of time updating that old branch.

-- 
 KOVACS Krisztian
