From: Patrick Schaaf <bof@bof.de>
Subject: Re: conntrack and ICMP errors
Date: Tue, 15 Apr 2003 19:23:59 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030415172359.GA26101@oknodo.bof.de>
References: <20030411101702.14701.14873.Mailman@kashyyyk> <16028.15188.332538.355740@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, Balazs Scheidler <bazsi@balabit.hu>,
  Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Don Cohen <don-netfil@isis.cs3-inc.com>
Content-Disposition: inline
In-Reply-To: <16028.15188.332538.355740@isis.cs3-inc.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Don & list,

> For the case of TCP, however, I do have a proposal.
> If you keep the last ack# that you've sent in each direction you can
> do a weak sort of check of whether a participant still thinks the
> connection is alive by (re)sending that last ack (with no other
> payload) and hoping to get back a reset if the participant thinks the
> connection was closed.  I suggest that this technique be used either
> when you have some reason to suspect the connection is closed (such 
> as the ICMP messages in the discussion), or when you've not heard any
> packets for a long time (it's reasonably likely that one side or the
> other has rebooted in the mean while), or for that matter, when you
> find the conntrack table filling up and want to reclaim some space. 

There are basically two questions to worry about:

1) for any such probing method, what could go wrong in the real world?
   As I work for a dialup service provider, the extreme case that I have
   to consider is both sides of a tracked connection having been reassigned
   to different customers. Now your probe comes. What will happen? How many
   calls will support get about attack attemts? (not many, but also not
   none)

2) there's the question of when to probe. My crystall ball displays
   "halting problem", but it is occasionally flakey. Any kind of
   probing violates the unwritten "never send more than you receive"
   rule of intermediate protocol stacks, so one has to be careful.

Both questions turn my brain into fog mode, so I always refrained
from publicizing such heretical thoughts. But deep in my heart,
I feel that it is a worthy path to explore. Without need, though,
it's something I'll do when I'm old.

It may well be that all this has been researched to death, before.
I wouldn't know. I'm a lazy ignorant.

best regards
  Patrick
