From: "Ian Latter" <Ian.Latter@mq.edu.au>
Subject: Re: How to create a "persistent" expectation with newnat?
Date: Thu, 27 Feb 2003 09:53:45 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200302262353.h1QNrjC22019@singularity.tronunltd.com>
Reply-To: "Ian Latter" <Ian.Latter@mq.edu.au>
Content-Type: text/plain; charset="us-ascii"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter@interlinx.bc.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Howdy pardner.  :-)
ahhh .. Brian ;-)  Didn't see your sig b4 ...
 
> >   Wouldn't most of your problems go away if you set the expectation
> > on the outbound connection?
> 
> I do that.  And it works while there are outbound connections.  But as
> I described in my last message, there might be some time (quite a bit
> of time in fact) between outgoing connections.  Indeed, once you have
> been on the network long enough and your address gets known to enough
> other peers on the network, you will start to see enough incoming
> connections that you no longer make outgoing connections to keep the
> "minimum connections" count up.
Instead of relying on outgoing connections to maintain the live session,
leave that out for the time being, and set up an untimed inbound expectation.


> Since there potentially can be no outgoing connections after the first
> few, it is these incoming connections that need to keep the "flywheel"
> (of inbound expectations) going.
s'cool ... let one out set it off ... and the ins can look after themselves ...


> > Ie.  If I was to alter my rsh module to
> > do gnutella, on what you've said below, I would look for the one 
> > outbound connection (client to server --- or client to universe in p2p),
> > setup an expectation on the inbound connections (universe to client)
> > for either an unlimited or numbered count of each type, then handle
> > these connections.
> 
> But the expectation will go away when either of a) it times out, or b)
> the master connection goes away.  It is for both of these reasons that
> the expectation needs to continually be renewed (even when your only
> connections are inbound).  It needs to be attached to an ESTABLISHED
> connection and not be timed out.
Whenever your "end condition" occurs for the client ... then unload all
of the open expectations ....   so ... a or b rings true, then trash the open
expects ..


> >   In this way you will also avoid hassles later with NAT ....
> 
> For inbound connections, I don't know that there are NAT issues yet.
> I don't think anything in the payload needs to be altered.  I have not
> looked that deeply yet.
Even if there's nothing in the payload ... if the NAT has been a masq or
some other non ip-to-ip mapping, then the helper will need to rewrite the
ip headers ... this had to be done in rsh .. which works like ftp ... one
out with a port in the proto for where a new one should come back ..
this then hits the firewall (tables) as a local port, which then needs to
be re-written.  Not that my rsh nat code ever got published ... I've been
meaning to ask Harald about that actually ...


> > So, generally, my feeling from netfilter is that you track the
> > outbound and expect the inbound ...
> 
> Generally, I agree with you -- for protocols where this is in fact the
> case.
I don't see your proto as being tremendously different from ftp ... 'cept
that the data sessions can be many+ and they can come from
the universe and not the master destination ...  should be pretty straight
forward ...


> b.
> 
> -- 
> Brian J. Murrell
> 

--
Ian Latter
Internet and Networking Security Officer
Macquarie University
