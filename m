From: "jesse" <jesse@deansoft.com.tw>
Subject: Re: New draft document on nat / traversal / hole punching (with
	DanKegel)
Date: Fri, 19 Nov 2004 15:37:57 +0800
Message-ID: <00b601c4ce0a$b0f186b0$0f01a8c0@jesse049trr65w>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org><200411161538.48528.baford@mit.edu><Pine.LNX.4.61.0411171646370.17188@filer.marasystems.com>
	<200411171147.52308.baford@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: srisures@yahoo.com,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@netfilter.org>,
	Rusty Russell <rusty@rustcorp.com.au>, dank@kegel.com,
	Netfilter Core Team <coreteam@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Bryan Ford" <baford@mit.edu>, "Henrik Nordstrom" <hno@marasystems.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


----- Original Message -----
From: "Bryan Ford" <baford@mit.edu>
To: "Henrik Nordstrom" <hno@marasystems.com>
Cc: <srisures@yahoo.com>; "Netfilter development mailing list"
<netfilter-devel@lists.netfilter.org>; "Harald Welte"
<laforge@netfilter.org>; "Rusty Russell" <rusty@rustcorp.com.au>;
<dank@kegel.com>; "Netfilter Core Team" <coreteam@netfilter.org>
Sent: Thursday, November 18, 2004 12:47 AM
Subject: Re: New draft document on nat / traversal / hole punching (with
DanKegel)


> On Wednesday 17 November 2004 11:04, Henrik Nordstrom wrote:
> > I think most of the Netfilter developers understands the problems and
> > approaches quite well by now.

Yes,I think most of us have bet our life too much on those good features
Rusty designed,and really can't afford the last "remove do_extra_mangle"
like 5 patchs who proposed.
>
> Excellent - in that case perhaps the long message I sent just before
receiving
> your message wasn't necessary after all; you made all my points much more
> succinctly and eloquently. :)
>
> > The question is how much of the quite nice
> > properties we have today should/need to be sacrified in order to become
> > more P2P friendly.

According to the 3 years knowledge in netfilter field,I don't think it is
necessary that any existing nice properties be sacrified in order to match
P2P need.
>
> As I pointed out in the previous message, in practice I don't think these
nice
> properties need to be sacrificed - the NAT could keep the traditional
> symmetric NAT behavior for existing, well-known protocols such as HTTP
that
> don't need the cone NAT property, while providing exclusive port
allocation,
> and thus more predictable, P2P-friendly cone NAT behavior for new or
unknown
> protocols.  Since it's only the standard, well-known protocols that are
ever
> likely to push the port allocation limitations of cone NAT, it seems to me
> that this strategy should work quite well in practice even on a large
> industrial NAT that might handle millions of connections at once.
>
> Thanks,
> Bryan

Yes,but opposite is leaving P2P need be specifically treated.The following
is the high layer design in netfilter context that for Bryan can keep giving
advice:

1.Like Rusty's previous suggestion,Build a hash for modified source
endpoint(source ip and port after NAT),in netfilter context,that is hash for
reply tuple's dst like what we already have as source hash for original
tuple's src.
2.Adding a flag called HOLEPUNCH somewhere on conntrack cache(session table)
indicating if this session is for P2P.
3.Have a iptables target something like "P2PSNAT" as alternative to the
existing SNAT.That's for specific P2P rule policy based on iptables:
iptables -t nat -A POSTROUTING -s 10.0.1.1/32 -d 0.0.0.0/0 -j P2PSNAT --to
155.99.25.11
4.Any connection modified by P2PSNAT will be flaged on  HOLEPUNCH.
5.When a new connection request come,in addition to existing source NAT
machenism's ip and port allocation method,the hash for modifid source should
be looked up to see if  there exist the same mapping as the candidate NAT
source ip and port,if there does exist one,then following is the conditions:
    a.This new connection's  HOLEPUNCH flag is off,representing this is a so
called "standard protocol",then check the existing mapping's connection's
HOLEPUNCH flag.If it is on,representing some P2P connection occupy this
mapping now, then skip this candidate and find a new one.If it is
off,representing this mapping is free for share,then adopt this candidate.
    b.This new connection's HOLEPUNCH flag is on,representing this is a P2P
connection request and can't share mapping,then skip this candidate and find
a new one.
If there does'nt exist one,then adopt this candidate.

For Hairpin,then life is easy now.While NAT A 10.0.1.1:4500 connects to NAT
B at NAT C 155.99.25.11:62005,in addition to existing destination NAT
machenism,the hash for modified source should also be looked up to see if
there exist any connection using 155.99.25.11:62005 as its modified source
to outbound connect with HOLEPUNCH flag on.If there does exist,then
destination NAT this connection's destination end point to the existing
mapping one's original source end point.If there doesn't,then like before if
TCP reset it.While source NAT,follow the same machenism as the above 5
phases.

Hope this design suggestion can help reserve what we have in netfilter.And
if it is needed,we are willing to do what we can do.

Thanks
Your sincerely
Jesse Peng
