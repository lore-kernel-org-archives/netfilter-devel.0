From: James Morris <jmorris@intercode.com.au>
Subject: Re: Making ip_queue l3 independent
Date: Sun, 24 Aug 2003 17:51:27 +1000 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Mutt.LNX.4.44.0308241738460.20308-100000@excalibur.intercode.com.au>
References: <20030823210022.GA6750@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: coreteam@netfilter.org,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030823210022.GA6750@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 23 Aug 2003, Harald Welte wrote:

> James, what is your take on this?  What do you think?  If you agree, do
> you have the time to do the change, or would you be fine if I'd work out
> a patch?

Yes it's a good idea.  Most of the code is indeed protocol independent,
and things like the mangle function could be registerable as part of e.g.  
nf_queue_handler_ops.

It is unlikely that I would have time to work on this before 2.6.0, due to 
other projects and the fact that I'm moving to the US in a few weeks.  

Please feel free to hack on the code.  Another potentially useful
improvement would be to allow for multiple packet messages and verdicts,
which I don't think would be difficult to implement (using the same or
similar technique in your ulogd code).

It would be nice to maintain binary compatibility with current libipq, if 
possible.


- James
-- 
James Morris
<jmorris@intercode.com.au>
