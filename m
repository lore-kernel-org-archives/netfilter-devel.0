From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re:Interesting failure with RPC state tracker
Date: Thu, 22 May 2003 09:24:06 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200305212324.h4LNO6710132@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hello Brian and Dev ppls,

  I have been thinking about this recently ... after being informed of a
pointer error on the module name I've taken to doing a bit of research
on the whole kernel module thing.

  I'll post a link on it later, but I found a site that discussed the RPC
module within Firewall-1 in greater detail than I had seen previously.

  One of the things that Firewall-1's RPC code did, that I didn't like, was
that if you choose to "match" an RPC, then the matching module will
automatically allow RPC portmapper requests through the firewall.  I
don't like the idea of "hidden rules", and hence in the Netfilter version,
you need to permit the RPC portmapper requests explicitly.  So what
you've seen is correct ... and this sort of ruleset;

  Usage:

    The intended usage of these modules would be with a ruleset like;

      # New session from client to server (portmapper get)
      -A PREROUTING -t nat -i eth0 -p udp -m rpc --rpcs 100002
             -s ${client} --sport 0:1023 -d ${server} --dport 111
             -j ACCEPT

      # Continued session from client to server (portmapper answer)
      -A PREROUTING -t nat -i eth1 -m state -p udp
             -s ${server} --sport 111 -d ${client} --dport 0:1023
             --state ESTABLISHED -j ACCEPT


... should work ... (was this what you found?) .. except for the "DUMP"
request.  I'll need to read up on this one (I remember reading it through
when I rejigged the module, but I ended up discarding it).


  There are two other features in the Firewall-1 RPC code that I want
to add to the Netfilter RPC module;

  1)  Cached portmapper resolution -- establishing a slab cache the
          dynamically stores the port vs the procedure number in memory
          such that future RPC portmapper requests are redundant

  2)  A kernel socket call to the RPC portmapper -- in case the RPC
          module or rule is only activated after the client has already 
          performed a portmapper resolution request, currently the RPC
          module would fail to permit the valid RPC request.  If, however,
          the RPC port range was treated as a possible set of RPC "targets",
          but for which a valid (matched) IP address had failed to resolve a
          port for a given procedure; then the RPC module would make its 
          own request to the portmapper to resolve the port and validate the
          match.  The resolution could then be added to the local slab cache
          to accelerate future matches.


  While it *sounds* like  I'm a great guy ready to do big things, the truth is
that I haven't fixed my pointer module name problem in three weeks, so 
these mods might be a little way off ;-)

  I am very appreciative of feedback on the use of this module and your
successes/failures.  Of particular interest is performance ... let me know
how you go with thrashing this thing under NFS ... because that is one
of the big unanswered questions here ..

  Thanks for the feedback ... I'll check out that DUMP command and see
what I can do ... which kernel version are you using?

(Cool database software, btw, I implemented it for an ISP in AU who
had heard of it and used it before).



----- Original Message -----
>From: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
>To: <netfilter-devel@lists.netfilter.org>
>Subject:  Interesting failure with RPC state tracker
>Date: Wed, 21 May 2003 17:58:55 -0400
>
> I have been trying to get NFS to work through Netfilter with the rpc
> mdoule in p-o-m/extra.
> 
> I have finally gotten it to work successfully, but the struggle I had
> getting it to work had an interesting outcome.
> 
> The reason my initial attempts failed is because the RPC tracking module
> depends on intercepting GETPORT calls and opening expectations on the
> assumption that if a client asks for the port for a given service on a
> given server, it will want to connect to it.
> 
> The problem that this causes with Linux's "mount" command is that the
> mount command (in util-linux) does a RPC portmap "DUMP" (tcp:111 on the
> server) just like "rpcinfo -p" does.  It then extracts the port number
> from there.
> 
> If you put a rule in the filter to block access to the portmapper's TCP
> port on the server, the above process fails and then normal RPC
> processing continues, with a GETPORT call to determine the port number.
> 
> Thots?
> 
> b.
> 
> -- 
> Brian J. Murrell <netfilter@interlinx.bc.ca>
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
