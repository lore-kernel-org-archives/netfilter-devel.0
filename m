From: Robert Olsson <robban@robtex.com>
Subject: Re: IPtables performance (fwd)
Date: 27 Apr 2003 16:57:37 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1051455460.11505.143.camel@robban.port80.se>
References: <Pine.LNX.4.44.0304221149430.24242-300000@localhost>
	<20030427130229.GG990@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Chris Wilson <chris@netservers.co.uk>, netfilter-devel@lists.netfilter.org,
   John McEleney <john@netservers.co.uk>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20030427130229.GG990@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 2003-04-27 at 15:02, Harald Welte wrote:
> On Tue, Apr 22, 2003 at 12:04:26PM +0100, Chris Wilson wrote:
> > Dear Sirs,
> > 
> > We have been having a problem with the performance of iptables in loading
> > large and complex rulesets for a long time. We have tracked it down to the
> > mark_source_chains kernel function, which takes about 15 seconds to
> > execute with a fairly large and complex ruleset on decent hardware.
> 
> yup, we are aware of this problem.  However, most people tend to execute
> iptables 1000 times for inserting 1000 rules, which is obviously the
> wrong way to do it.  This way you end up doing 1000 ruleset-loads and
> 1000 loop checks.  iptables-restore takes away that burden.

I wish it was that easy, but it was equally slow to me when I tried it a
long time ago, so my analysis was that this function is called for every
single rule-insertion even for iptables-restore?

> 
> > We discovered Robert Olsson's patch which greatly improves the efficiency
> > of this function (he claims up to 1000x, we have seen around 80x with our
> > rulesets). This was last submitted to this list on 6th March 2002
> > (http://lists.netfilter.org/pipermail/netfilter-devel/2002-March/006994.html).
> 
> I didn't accept his previous patches, because it didn't cover all cases,
> i.e. there are loops that wouldn't have been detected by his patch.
> 
> However, the last patch seems to have changed, so I need to do some
> analysis whether it would still detect all loops or not.
> 
> > Please could you let me know whether you would consider including this 
> > patch in Netfilter.
> 
> I will consider any optimization as soon as anybody can guarantee me
> that it still detects all cases of loops ;)

I have tested thoroughly all kinds of loops and it detects it. I will of
course never guarantee anything :)


> 
> I'll put your patch into patch-o-matic 'extra' and add a Status:
> Experimental line.
> 
> > [P.S. Harald: Robert sends his regards =)]
> 
> thanks.
> 

I guess most people have a simple tree-like iptables, but some have
rulesets with an exponentially growing number of possible paths.
We are very thankful for you reinvestigating this issue.
Thank you!

Regards
Robert Olsson


> -- 
> - Harald Welte <laforge@netfilter.org>             http://www.netfilter.org/
> ============================================================================
>   "Fragmentation is like classful addressing -- an interesting early
>    architectural error that shows how much experimentation was going
>    on while IP was being designed."                    -- Paul Vixie
