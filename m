From: Scott MacKay <scottmackay@yahoo.com>
Subject: Packet mangle issues with retransmissions
Date: Wed, 16 Feb 2005 14:04:27 -0800 (PST)
Message-ID: <20050216220427.80297.qmail@web30202.mail.mud.yahoo.com>
References: <420BDAC8.3080300@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
In-Reply-To: <420BDAC8.3080300@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hiyas,
   Working under 2.4.x (at least 2.4.20 from RH9) I
think I have an issue that I am starting to unravel
with regards to TCP and packet mangling.  I am not
sure if this is something fixed or more of a 'don't do
that'...
In mangling a TCP packet (POSTROUTING), I adjust the
size of the packet, reducing the overall length as I
mangle the contents.
This normally works all happy skipper like.  A big
issue comes in, though, on retransmission.  If the
system decided it needs to resend the packet, I get
something nasty happening.
   Looking at the packet contents on resent via
ethereal, I see the initial portion of the packet
containing my changes, but then the system seems to
fill the contents back up to the full MTU!  That would
be fine, except it retains my packet alteration.

I would think the problem I am seeing is 1 of 2
things.
First, maybe skbuff dataspace comes from the tcp
buffer's allocation.  this would mean any mangling
performed on a packet affects the actual real buffer,
not some memory copy.
Secondly, if it is a private space, then it would seem
that the resend mechanism tries to insure the packet
is full, so adds on to fill to MTU, not memcpying over
anything it *thinks* is already sent.
Either way, it seems bad becase a POSTROUING packet
mangling will see it's mangled data on a tcp retrasmit
which I am not sure is intended.
So I guess my questions, for those who are
enlightened...
1.  is skbuff data private or can it point into some
tcp structure's allocated space?
2.  Could this be something fixed already (and no, I
canot go to 2.6 just yet)
3.  Is there a way to tell skbuff that the data is
'dirty', namely that it should try and reackage the
whole thing on retransmit?
Thanks for any info!!

Scott

__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
