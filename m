From: allen <aef@prismnet.com>
Subject: Re: [NEW EXTENSION] Condition Match
Date: Fri, 1 Nov 2002 18:41:37 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200211011841.37869.aef@prismnet.com>
References: <3DC1DE3F.7040404@videotron.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Stephane Ouellette <ouellettes@videotron.ca>,
	netfilter-devel@lists.netfilter.org
In-Reply-To: <3DC1DE3F.7040404@videotron.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


On Thursday 31 October 2002 07:51 pm, Stephane Ouellette wrote:
> --- Harald Welte <laforge@gnumonks.org> wrote:
( snip )
> >> Where is the problem in having a couple of different rulesets (e.g.
> >> created with iptables-save) which are then loaded using an
> >> iptables-restore commandline or a script at the shell of the firewall?
>
> Harald,
>
>    I have already tried the solution you propose on a production
> environment and it proved difficult to deal with.  Using the condition
> match, it is far faster to enable/disable rule sets than it is with a
> set of scripts.  It is also less error-prone on a management point of
> view as the firewall rules never change.
>
> I would suggest that the condition match makes it to P-O-M, and let the
> users try it.

Yeah.

After thinking more about it, yeah.  It IS cool.

Note:

1.  Already many things are adjusted via /proc mechanism
    that are similar in that they are related to networking
    parameters that need to be modified on the fly.

2.  Making a modification to netfilter rules by dumping
    and loading new rules is not cool and is prone 
    to error "during the switch".

    This method is only straightforward, but actually
    more complex in operation.  ( The administrator
    has to think more )

3.  The other thing would be a libipq thing, and there
     can be only one.  And it is in userspace and
     it can die.

I think the /proc concept in this case is better than
the load/modify/delete/add kind of concept.

I'm having a hard time thinking of a better "thing" 
than /proc.

It seems like the next best alternative is yet again
some "new thing" that doesn't exist yet.

What new thing would be better than /proc ?

Who would "buy" something new ?  so to speak...

For what it is worth, I second the motion here.

-AEF
