From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: [PATCH] RPC match and conntrack modules v2.1
Date: Sun, 12 Jan 2003 21:33:07 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301121133.h0CBX9K10094@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Harald Welte" <laforge@gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Harald,

  I didn't get your gz attachment, but I reassembled your patch from
the mailling list archive.

  I have done all bar the cache implementation.  You may be  right
about its usage (and hence its performance) but I'm not sure -- if
NFS only does one RPC lookup per procedure then the ls data will
be a packet per file in the expectation, not the decision making 
process, which will put it out of my hands ... I don't have the gear
to test that particular scenario on hand.
  I would like to apply the cache stuff, but it looked a little challenging
for the time I had available.  I am also interested in combining the 
tcp and udp modules into a single module.
  I have done a fair bit of work on its cleanliness since you last
saw it.

  The file is on the ftp server -- it applies cleanly to 2.4.20.  I think
you'll be much happier with that implementation (v2.2).

  11572 Jan 12 21:08 pom-rpc-030112-01.tgz
  afd50da3f913ba860b69c74030b0a056  pom-rpc-030112-01.tgz


Let me know how you find it ...



----- Original Message -----
>From: "Harald Welte" <laforge@gnumonks.org>
>To: "Ian Latter" <Ian.Latter@mq.edu.au>
>Subject:  Re: [PATCH] RPC match and conntrack modules v2.1
>Date: Sat, 11 Jan 2003 01:05:55 +0100
>
> On Sat, Jan 11, 2003 at 09:47:01AM +1100, Ian Latter wrote:
> 
> > Cool, thanks .. :-)  I think there will be a lot of embedded firewall
> > manufacturers that will enjoy this one ...
> 
> agreed :)
> 
> > That's correct - there was no NAT built into record-rpc, not even in an
> > old API.  I wanted to make the module set complete by writing the 
> > corresponding NAT module(s) but I didn't get time.  I might be re-inspired
> > later in January if no one else picks it up -- the code should be almost
> > identical to the RSH work module that I wrote, because the connection
> > handling is quite similar ..... actually ... maybe it doesn't need a
> > nat helper; the connections are all initiated from the client to the
> > server, and the internal protocols aren't carrying payloads that need
> > to be rewritten ... so as long as the nat stuff handles "related"
> > streams sanely, then its probably ok ...
> 
> no problem, let's just ignore NAT for now.
> 
> > > See attached patch.  Mostly CodingStyle updates (you seem to like 8 spaces
> > > instead of tab), but also a minor fix:
> > Cool ... could you resent it as a "zip" attachment ... my mail software
> > decodes text attachments which will make all the tabs in your patch
> > spaces again ...
> 
> well, here it is as .gz again.  Strange mailclient you must be using...
> 
> > > btw: I'd really love to see the large chunk of code in the switch
> > > statement of the match() function in ipt_rpc.c be split up in seperate
> > > functions (thus reducing indentation and improving readability).
> > possibly could be ... the gumby way might be to do udp and tcp
> > functions ... but a better way might be to pull out the rpc payload
> > stuff .... I can take a look at that.
> 
> thanks.
> 
> > > I don't know, but I think esp. in cases where you have lots of rpc
> > > activity (NFS?, I'm not an RPC expert) it might be wise to use a slab
> > > cache for the 'struct request_p' list items.
> > I have not done that before, is there  an example some place in the
> > existing modules?
> 
> yes, it's done in ip_conntrack_core. see kmem_cache_create /
> kmem_cache_alloc / and related functions.   The idea is for the memory
> management to keep a pool of memory chunks of the requested size around,
> in case they are heavily allocated / deallocated.  We do this with
> struct sk_buff, struct ip_conntrack.
> 
> I'm not sure whether it's worth the effort in the rpc case... But if I'm
> not mistaken in NFSv2, every single file in an 'ls' is a seperate RPC
> request/reply, isn't it?
> 
> > > Please integrate my patch [and maybe consider my suggestions, that's of
> > > course up to you], test it and resubmit it.
> > hopefully be done by the end of the weekend/early next week.
> 
> no problem, I'll be off over the wekend anyway.
> 
> > > Thanks!
> > Thanks for taking a look at it, and providing feed back ...
> 
> You're welcome.
> > --
> > Ian Latter
> 
> -- 
> - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
> 
===========================================================================
=
> "If this were a dictatorship, it'd be a heck of a lot easier, just so long
>  as I'm the dictator."  --  George W. Bush Dec 18, 2000
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
