From: "Chris Poon" <Chris.Poon@TELUS.COM>
Subject: RE: [PATCH] big endian patch against netfilter after PPTP NAT
 pat ch
Date: Mon, 3 Feb 2003 10:56:09 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <771F217D7A4AF84494632457889470A412D77E@bcmsg011.corp.ads>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="----_=_NextPart_001_01C2CBAD.8877F1AF"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	<netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This message is in MIME format. Since your mail reader does not understand
this format, some or all of this message may not be legible.

------_=_NextPart_001_01C2CBAD.8877F1AF
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 7bit

Padding was the first way I think of how to solve it, but now that I look at it
again, the problem is actually the size assumption of the mask - almost
all helpers assumes a 16 bit mask. The PPTP patch breaks that assumption,
and because of the nature of the patches, I wouldn't have modified all the
places where the mask is filled out. Maybe the correct way is solve this is to
make the field size change permanent in ip_conntrack_manip_proto and
ip_conntrack_tuple, and change all the places that fill out the mask to use
the right sized mask instead of 0xffff, which happens to break the big-endian
machines but not the little endian machines. What do you think?

-----Original Message-----
From: Harald Welte [mailto:laforge@gnumonks.org]
Sent: Monday, February 03, 2003 7:44 AM
To: Chris Poon
Cc: 'netfilter-devel@lists.netfilter.org'
Subject: Re: [PATCH] big endian patch against netfilter after PPTP NAT patch

I don't like this patch because:

1) there are non-64bit big endian machines, that don't need the padding
2) we should be able to have those structures and the respective
   functions working in a portable way, with no #ifdef's all over the place.
   Why is this so difficult? If all empty (padding) space is initialized
   to zero, and the fields addressed only by the member names, the mask
   compare should still work. Or am I missing something?

I have now added this whole issue to the bugtracking system, see
https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=41

> Enjoy

-- 
- Harald Welte / laforge@gnumonks.org               http://www.gnumonks.org/
============================================================================
"If this were a dictatorship, it'd be a heck of a lot easier, just so long
 as I'm the dictator."  --  George W. Bush Dec 18, 2000

------_=_NextPart_001_01C2CBAD.8877F1AF
Content-Type: text/html;
 charset=us-ascii
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3Dus-ascii">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
5.5.2653.12">
<TITLE>RE: [PATCH] big endian patch against netfilter after PPTP NAT =
patch</TITLE>
</HEAD>
<BODY>

<P><FONT SIZE=3D2>Padding was the first way I think of how to solve it, =
but now that I look at it</FONT>
<BR><FONT SIZE=3D2>again, the problem is actually the size assumption =
of the mask - almost</FONT>
<BR><FONT SIZE=3D2>all helpers assumes a 16 bit mask. The PPTP patch =
breaks that assumption,</FONT>
<BR><FONT SIZE=3D2>and because of the nature of the patches, I wouldn't =
have modified all the</FONT>
<BR><FONT SIZE=3D2>places where the mask is filled out. Maybe the =
correct way is solve this is to</FONT>
<BR><FONT SIZE=3D2>make the field size change permanent in =
ip_conntrack_manip_proto and</FONT>
<BR><FONT SIZE=3D2>ip_conntrack_tuple, and change all the places that =
fill out the mask to use</FONT>
<BR><FONT SIZE=3D2>the right sized mask instead of 0xffff, which =
happens to break the big-endian</FONT>
<BR><FONT SIZE=3D2>machines but not the little endian machines. What do =
you think?</FONT>
</P>

<P><FONT SIZE=3D2>-----Original Message-----</FONT>
<BR><FONT SIZE=3D2>From: Harald Welte [<A =
HREF=3D"mailto:laforge@gnumonks.org">mailto:laforge@gnumonks.org</A>]</F=
ONT>
<BR><FONT SIZE=3D2>Sent: Monday, February 03, 2003 7:44 AM</FONT>
<BR><FONT SIZE=3D2>To: Chris Poon</FONT>
<BR><FONT SIZE=3D2>Cc: 'netfilter-devel@lists.netfilter.org'</FONT>
<BR><FONT SIZE=3D2>Subject: Re: [PATCH] big endian patch against =
netfilter after PPTP NAT patch</FONT>
</P>

<P><FONT SIZE=3D2>I don't like this patch because:</FONT>
</P>

<P><FONT SIZE=3D2>1) there are non-64bit big endian machines, that =
don't need the padding</FONT>
<BR><FONT SIZE=3D2>2) we should be able to have those structures and =
the respective</FONT>
<BR><FONT SIZE=3D2>&nbsp;&nbsp; functions working in a portable way, =
with no #ifdef's all over the place.</FONT>
<BR><FONT SIZE=3D2>&nbsp;&nbsp; Why is this so difficult? If all empty =
(padding) space is initialized</FONT>
<BR><FONT SIZE=3D2>&nbsp;&nbsp; to zero, and the fields addressed only =
by the member names, the mask</FONT>
<BR><FONT SIZE=3D2>&nbsp;&nbsp; compare should still work. Or am I =
missing something?</FONT>
</P>

<P><FONT SIZE=3D2>I have now added this whole issue to the bugtracking =
system, see</FONT>
<BR><FONT SIZE=3D2><A =
HREF=3D"https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=3D=
41" =
TARGET=3D"_blank">https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_b=
ug.cgi?id=3D41</A></FONT>
</P>

<P><FONT SIZE=3D2>&gt; Enjoy</FONT>
</P>

<P><FONT SIZE=3D2>-- </FONT>
<BR><FONT SIZE=3D2>- Harald Welte / =
laforge@gnumonks.org&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <A HREF=3D"http://www.gnumonks.org/" =
TARGET=3D"_blank">http://www.gnumonks.org/</A></FONT>
<BR><FONT =
SIZE=3D2>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D</FONT>
<BR><FONT SIZE=3D2>&quot;If this were a dictatorship, it'd be a heck of =
a lot easier, just so long</FONT>
<BR><FONT SIZE=3D2>&nbsp;as I'm the dictator.&quot;&nbsp; --&nbsp; =
George W. Bush Dec 18, 2000</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C2CBAD.8877F1AF--
