From: Samuele Giovanni Tonon <samu@mclink.it>
Subject: Re: a question about ipv4 multicast and NAT
Date: Mon, 25 Aug 2003 16:50:09 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030825145008.GA27075@linuxasylum.net>
References: <20030825110055.GD423@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030825110055.GD423@oknodo.bof.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Aug 25, 2003 at 01:00:56PM +0200, Patrick Schaaf wrote:
> (my reply to the last message from Samuele)
> 
> Hello Samuele,
> 
> > i'll try to be as clear as possible however tell me if there's 
> > something you don't understand my english is not so fluent:
> 
> Most of the readers/writers here, are afflicted with that problem.
> We'll understand you.
we should switch to italian it could be easier for me :-)

> > However they are inside a LAaN, so their request have to be "natted"
> > from the linux gw to the outside
> 
> Really? Note that I'm not awfully proficient in things multicast,
> but it was my impression that the first router in front of MC
> clients, would speak IGMP with the clients, and talk to the
> network accordingly; thus, I would expect that a proper multicast
> router setup on the linux gw, would provide everything you need,
> no NAT needed at all.
yes, that's right but only if you have public ip, if you try to send 
multicast packets from private ip, obviously they will go out 
with src setted to that ip (e.g. 192.168/24) but these packets on
the internet should be dropped by "big" routers (if i remember correctly).

> Did you try going that mroute?
did you mean mrouted ? yes, in tunnel mode (i tried to set up
an "mbone link" from university to home, and in normal mode to see
multicast session inside the MAN of one of my isp (just allowing to forward
multicast traffic because my two isp are multicast enable ) but it didn't
worked. 
 
> > the same thing should be possible if people from 192.168/24 wants to send
> > their video stream to the outside, but in this case things could be a bit
> > more complicated because you have to "nat" the outgoing stream and announce.
> 
> I imagine this is a _completely_ different scenario. I'd even question
> the sanity of an ISP _permitting_ you to do that.
:-)
well, for example one of my two isp is selling T1 natted lines :
you have 10Mbps but you can't accept incoming connection from "the internet"
'cause you're nat.
However you can see all the other customer of the isp (we have private ip
of 10.0/4 class ) so it's a MAN.
The isp sends us mpeg2 video streams over RTP/multicast (of course you'd 
have to pay to see them however they seem not aware that vlc let see them
without paying :-))  ) .
I also were able to make video conferencing session with a friend of mine 
which is in the same isp (we both were running linux without netfilter nat module) . 
Of course i can't make a videoconferencing with my university (they drop
multicast outside their backbone) but i'd like just to see the one in the MAN.

> 
> > In this manner, with an isp that is multicast capable people can use multicast
> > for conferencing or just for fun .
> > 
> > Please tell me if something is not clear, or if i haven't answered correctly
> > to your question.
> 
> I fear that I'm too naive about multicast to be of more help. 
well, developing a multicast capable application it's a piece
of cake, the problems come with routing and nat .

Some times ago i found on the internet some very interesting papers
on multicast under ipv4 and some possible implementation of correct 
NAT router/firewall for it, obviously i cannot find them again 
(Murphy's law) but i'll search for them.

regards
Samuele 

-- 
While various networks have become deeply rooted, and thoughts have been sent
out as light and electrons in a singular direction, this era has yet to 
digitize/computerize to the degree necessary for individuals to become 
a singular complex entity.
  KOUKAKU KIDOUTAI Stand Alone Complex
