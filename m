From: Amit Kumar <amitkumargupta_wip@yahoo.com>
Subject: Reg Connection Tracking
Date: Thu, 16 Jan 2003 19:49:12 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030117034912.25371.qmail@web41503.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: multipart/alternative; boundary="0-2014047945-1042775352=:20706"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

--0-2014047945-1042775352=:20706
Content-Type: text/plain; charset=us-ascii


HI,

I have registered on my yahoo Id on this List as suggested by some on this list due to disclaimer issue. I am attaching my mail here.

Hi List,
I am new to this list and Getting some problem in connection tracking.
However, I have put it on Netfilter users list but it is not solved so I
am putting it here for your suggestions.
Well The setup is like this : -
I am having a RG(Residential Gateway) and inhome client. RG is using
Embedix kernel with 2.4.3 sources.
The /proc/sys is not present as CONFIG_SYSCTL is not enabled due to some
reasons. It means there is none of the ip_conntrack_max file present.
RG is having IPFILTER as firewall and having iptables rules to allow the
traffic in and outside. RG is having 2 interfaces.
One is internal to connect the RG to inhome.
And Other is external for the internet.
When I tries to ping from inhome to RG's external , I don't get reply.
The reason is : - There is a rule on RG's side
-m state -state INVALID -j DROP
The ip_conntrack contains 1016 entries and it keeps printing the message
:-
ip_conntrack: Maximum limit of 1016 entries exceeded.

Even increasing the value of ip_conntrack_max in the code doesn't help.
The ip_conntrack file consists of all unreplied packets b/w inhome and
RG with icmp request type=8 code =0 and reply(inverse tuple) =
type=0
code=0

Similarly the http b/w inhome and RG makes this file full .
I am attaching the conversation which I had it on Netfilter users list.
Please Help.

Thanks & Regards,
Amit Kr. Gupta.
------------------------------------------Conversation on netfilter users list which i had-------
Amit,
This looks like a bug, so I guess you had better take this report to
netfilter-devel with as much info as possible.
=20
Could you also cat a full ip_conntrack to a temp file
and put it somewhere online to accompany your bugreport.
=20
Reporting this to netfilter-devel doesn't guarantee that
you will get a quick solution to your problem
(your setup is quite different from most people's...),
but at least it could be put in the KNOWN-BUGS section
so someone could eventually get around to fixing this...
=20
Regards,
Filip
=20
On Tue, 2003-01-14 at 13:56, Amit Kumar Gupta wrote:
>=20
> Hi List,
>=20
> Again Posting the same question ON the list As I have tried many ways=20
> and didn't get any clues.
>=20
> As soon as I ping from inhome to the RG's internal, It just keep=20
> filling the ip_conntrack file and it goes beyond ip_conntrack_max=20
> entries. I don't know why Internal address is not replying.
>=20
> If Any clues, Please Help.
>=20
> Thanks & Regards,
> Amit
>=20
> -----Original Message-----
> From: Amit Kumar Gupta
> Sent: Saturday, January 11, 2003 10:37 AM
> To: Athan
> Cc: netfilter@lists.netfilter.org
> Subject: RE: Reg iptables Connection tracking
>=20
> Hi,
>=20
> I am using Embedix platform in which If I enable CONFIG_SYSCTL, the=20
> image doesn't come up on the H/w. So I have to disable this.( There=20
> has been some changes in the Kernel to suit this which works fine).=20
> Now in conntrack module I don't have this option so my conntrack=20
> ctl_table will not be registered woth ipv4 table. So I was hardcoding=20
> the value of ip_conntrack_max? Whether it will help?
>=20
> Another issue is I don't have enough memory on the board to have=20
> sysctl command.
>=20
> Can you suggest something which I can do?
>=20
> Regards,
> Amit
>=20
>=20
On Fri, Jan 10, 2003 at 04:04:54PM +0530, Amit Kumar Gupta wrote:
> On Friday 10 January 2003 12:37 am, you wrote:
> > Well I am able to see upto this point. I went through the code flow=20
> > also. But I don't know why it prints the message(Even if increasing=20
> > the value from 1016 to 4096 by hardcoding it in the kernel). Another

> > issue is I don't know how it is taking 1016. As There is no
/proc/sys=20
> > , and by default it shoud take 0.
=20
   I missed this before, sorry.  Is this due to specifically disabling
/proc and/or specifically not mounting it for security reasons?  If not,
just enable it and mount it already.
=20
> Not that this helps much.  The real problem is WHAT is the conntrack
> table filling with.  And I suspect it may be nothing, that you have a=20
> problem because it is trying to use /proc/net/conntrack and there IS
no=20
> /proc/net/conntrack.  The message may be triggering incorrectly,=20
> presuming that since it cannot write another entry to=20
> /proc/net/conntrack that the table is full.
=20
   Er, no.  That's not what /proc/net/ip_conntrack is.  It doesn't EXIST
as such until you try to read from it.  All of /proc is virtual.  Just
because you have no /proc and can't get at 'files' in it doesn't mean
the SOURCE of their data doesn't exist.
=20
> /proc in order to work.  If I think of something else I'll email you
> again.  Sorry.
=20
   I'd certainly recommend having /proc around as well.  There's the
sysctl() interface for querying/changing some values too.  Aha! You can
set net/ipv4/ip_conntrack_max from this too *8-):
=20
      sysctl -w net/ipv4/ip_conntrack_max=3D32768
=20
If your kernel doesn't have the sysctl support then, er, you're kind of
shooting yourself in the foot for tuning things at ALL, including things
like turning IP forwarding on and off, global TCP ECN support, SYN
cookies etc....




---------------------------------
Do you Yahoo!?
Yahoo! Mail Plus - Powerful. Affordable. Sign up now
--0-2014047945-1042775352=:20706
Content-Type: text/html; charset=us-ascii

<P>HI,</P>
<P>I have registered on my yahoo Id on this List as suggested by some on this list due to disclaimer issue. I am&nbsp;attaching my mail here.</P>
<P>Hi List,<BR>I am new to this list and Getting some problem in connection tracking.<BR>However, I have put it on Netfilter users list but it is not solved so I<BR>am putting it here for your suggestions.<BR>Well The setup is like this : -<BR>I am having a RG(Residential Gateway) and inhome client. RG is using<BR>Embedix kernel with 2.4.3 sources.<BR>The /proc/sys is not present as CONFIG_SYSCTL is not enabled due to some<BR>reasons. It means there is none of the ip_conntrack_max file present.<BR>RG is having IPFILTER as firewall and having iptables rules to allow the<BR>traffic in and outside. RG is having 2 interfaces.<BR>One is internal to connect the RG to inhome.<BR>And Other is external for the internet.<BR>When I tries to ping from inhome to RG's external , I don't get reply.<BR>The reason is : - There is a rule on RG's side<BR>-m state -state INVALID -j DROP<BR>The ip_conntrack contains 1016 entries and it keeps printing the message<BR>:-<BR>ip_conntrack: Maximum lim
 it of 1016 entries exceeded.<BR><BR>Even increasing the value of ip_conntrack_max in the code doesn't help.<BR>The ip_conntrack file consists of all unreplied packets b/w inhome and<BR>RG with icmp request type=8 code =0 and reply(inverse tuple) =<BR>type=0<BR>code=0<BR><BR>Similarly the http b/w inhome and RG makes this file full .<BR>I am attaching the conversation which I had it on Netfilter users list.<BR>Please Help.<BR><BR>Thanks &amp; Regards,<BR>Amit Kr. Gupta.<BR>------------------------------------------Conversation on netfilter users list which i had-------<BR>Amit,<BR>This looks like a bug, so I guess you had better take this report to<BR>netfilter-devel with as much info as possible.<BR>=20<BR>Could you also cat a full ip_conntrack to a temp file<BR>and put it somewhere online to accompany your bugreport.<BR>=20<BR>Reporting this to netfilter-devel doesn't guarantee that<BR>you will get a quick solution to your problem<BR>(your setup is quite different from mos
 t people's...),<BR>but at least it could be put in the KNOWN-BUGS section<BR>so someone could eventually get around to fixing this...<BR>=20<BR>Regards,<BR>Filip<BR>=20<BR>On Tue, 2003-01-14 at 13:56, Amit Kumar Gupta wrote:<BR>&gt;=20<BR>&gt; Hi List,<BR>&gt;=20<BR>&gt; Again Posting the same question ON the list As I have tried many ways=20<BR>&gt; and didn't get any clues.<BR>&gt;=20<BR>&gt; As soon as I ping from inhome to the RG's internal, It just keep=20<BR>&gt; filling the ip_conntrack file and it goes beyond ip_conntrack_max=20<BR>&gt; entries. I don't know why Internal address is not replying.<BR>&gt;=20<BR>&gt; If Any clues, Please Help.<BR>&gt;=20<BR>&gt; Thanks &amp; Regards,<BR>&gt; Amit<BR>&gt;=20<BR>&gt; -----Original Message-----<BR>&gt; From: Amit Kumar Gupta<BR>&gt; Sent: Saturday, January 11, 2003 10:37 AM<BR>&gt; To: Athan<BR>&gt; Cc: netfilter@lists.netfilter.org<BR>&gt; Subject: RE: Reg iptables Connection tracking<BR>&gt;=20<BR>&gt; Hi,<BR>&gt;=20<BR
 >&gt; I am using Embedix platform in which If I enable CONFIG_SYSCTL, the=20<BR>&gt; image doesn't come up on the H/w. So I have to disable this.( There=20<BR>&gt; has been some changes in the Kernel to suit this which works fine).=20<BR>&gt; Now in conntrack module I don't have this option so my conntrack=20<BR>&gt; ctl_table will not be registered woth ipv4 table. So I was hardcoding=20<BR>&gt; the value of ip_conntrack_max? Whether it will help?<BR>&gt;=20<BR>&gt; Another issue is I don't have enough memory on the board to have=20<BR>&gt; sysctl command.<BR>&gt;=20<BR>&gt; Can you suggest something which I can do?<BR>&gt;=20<BR>&gt; Regards,<BR>&gt; Amit<BR>&gt;=20<BR>&gt;=20<BR>On Fri, Jan 10, 2003 at 04:04:54PM +0530, Amit Kumar Gupta wrote:<BR>&gt; On Friday 10 January 2003 12:37 am, you wrote:<BR>&gt; &gt; Well I am able to see upto this point. I went through the code flow=20<BR>&gt; &gt; also. But I don't know why it prints the message(Even if increasing=20<BR>&gt; 
 &gt; the value from 1016 to 4096 by hardcoding it in the kernel). Another<BR><BR>&gt; &gt; issue is I don't know how it is taking 1016. As There is no<BR>/proc/sys=20<BR>&gt; &gt; , and by default it shoud take 0.<BR>=20<BR>&nbsp;&nbsp; I missed this before, sorry.&nbsp; Is this due to specifically disabling<BR>/proc and/or specifically not mounting it for security reasons?&nbsp; If not,<BR>just enable it and mount it already.<BR>=20<BR>&gt; Not that this helps much.&nbsp; The real problem is WHAT is the conntrack<BR>&gt; table filling with.&nbsp; And I suspect it may be nothing, that you have a=20<BR>&gt; problem because it is trying to use /proc/net/conntrack and there IS<BR>no=20<BR>&gt; /proc/net/conntrack.&nbsp; The message may be triggering incorrectly,=20<BR>&gt; presuming that since it cannot write another entry to=20<BR>&gt; /proc/net/conntrack that the table is full.<BR>=20<BR>&nbsp;&nbsp; Er, no.&nbsp; That's not what /proc/net/ip_conntrack is.&nbsp; It doesn't E
 XIST<BR>as such until you try to read from it.&nbsp; All of /proc is virtual.&nbsp; Just<BR>because you have no /proc and can't get at 'files' in it doesn't mean<BR>the SOURCE of their data doesn't exist.<BR>=20<BR>&gt; /proc in order to work.&nbsp; If I think of something else I'll email you<BR>&gt; again.&nbsp; Sorry.<BR>=20<BR>&nbsp;&nbsp; I'd certainly recommend having /proc around as well.&nbsp; There's the<BR>sysctl() interface for querying/changing some values too.&nbsp; Aha! You can<BR>set net/ipv4/ip_conntrack_max from this too *8-):<BR>=20<BR>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; sysctl -w net/ipv4/ip_conntrack_max=3D32768<BR>=20<BR>If your kernel doesn't have the sysctl support then, er, you're kind of<BR>shooting yourself in the foot for tuning things at ALL, including things<BR>like turning IP forwarding on and off, global TCP ECN support, SYN<BR>cookies etc....<BR></P><p><br><hr size=1>Do you Yahoo!?<br>
<a href="http://rd.yahoo.com/mail/mailsig/*http://mailplus.yahoo.com">Yahoo! Mail Plus</a> - Powerful. Affordable. <a href="http://rd.yahoo.com/mail/mailsig/*http://mailplus.yahoo.com">Sign up now</a>
--0-2014047945-1042775352=:20706--
