From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: [PATCH] RPC match and conntrack modules v2.1
Date: Sat, 11 Jan 2003 09:47:01 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200301102347.h0ANl1606804@singularity.tronunltd.com>
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

> This is cool stuff.  Thanks a lot.  The kind of contribution I really
> like :)

Cool, thanks .. :-)  I think there will be a lot of embedded firewall
manufacturers that will enjoy this one ...


> Sorry, I didn't understand the part about the NAT module.  Are you
> saying that NAT support is not functional right now?
That's correct - there was no NAT built into record-rpc, not even in an
old API.  I wanted to make the module set complete by writing the 
corresponding NAT module(s) but I didn't get time.  I might be re-inspired
later in January if no one else picks it up -- the code should be almost
identical to the RSH work module that I wrote, because the connection
handling is quite similar ..... actually ... maybe it doesn't need a nat helper;
the connections are all initiated from the client to the server, and the
internal protocols aren't carrying payloads that need to be rewritten ... so
as long as the nat stuff handles "related" streams sanely, then its
probably ok ...
 
> See attached patch.  Mostly CodingStyle updates (you seem to like 8 spaces
> instead of tab), but also a minor fix:
Cool ... could you resent it as a "zip" attachment ... my mail software
decodes text attachments which will make all the tabs in your patch
spaces again ...
 
> - when unloading, only unregister up to ports_n_c ports
ok

> btw: I'd really love to see the large chunk of code in the switch
> statement of the match() function in ipt_rpc.c be split up in seperate
> functions (thus reducing indentation and improving readability).
possibly could be ... the gumby way might be to do udp and tcp
functions ... but a better way might be to pull out the rpc payload
stuff .... I can take a look at that.
 
> I don't know, but I think esp. in cases where you have lots of rpc
> activity (NFS?, I'm not an RPC expert) it might be wise to use a slab
> cache for the 'struct request_p' list items.
I have not done that before, is there  an example some place in the
existing modules?

> Please integrate my patch [and maybe consider my suggestions, that's of
> course up to you], test it and resubmit it.
hopefully be done by the end of the weekend/early next week.
 
> Thanks!
Thanks for taking a look at it, and providing feed back ...

 
> > Regards,
> > Ian Latter
> 
> -- 
> - Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
> 
===========================================================================
=
> "If this were a dictatorship, it'd be a heck of a lot easier, just so long
>  as I'm the dictator."  --  George W. Bush Dec 18, 2000


--
Ian Latter
Internet and Networking Security Officer
Macquarie University
