From: "Sneppe Filip" <Filip.Sneppe@cronos.be>
Subject: RE: Security flaw in Stateful filtering ??????
Date: Thu, 6 Jun 2002 21:29:16 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <E131E9F1848D0148813EAF06A846608F615D9E@w2ks-e2k.iconos.be>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----_=_NextPart_001_01C20D90.72502F00"
Return-path: <netfilter-devel-admin@lists.samba.org>
content-class: urn:content-classes:message
To: "Emmanuel Fleury" <fleury@cs.auc.dk>,
	<netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C20D90.72502F00
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Yes, it's that time of the month again :-)=20

Emmanuel Fleury [mailto:fleury@cs.auc.dk] wrote:
>
>Patrick Schaaf wrote:
>
>> The behaviour is intentional. The reason is "connection pickup". =
Imagine
>> a situation where the firewall reboots. All active conntracking =
information
>> will be lost. With the observed behaviour, connections are =
"relearned"
>> on the fly as they create new traffic.
>
>I simply disagree with you on this point (sorry :-/).
>
>I wouldn't accept to have such a flaw in my firewall just because of
>an hypothetic reboot of one of my gateway !!!!
>
>Of course, I could be wrong, but in this case this 'feature' should be
>highly documented and be disabled as default. IMHO.

Hi Emmanuel,

Please note that connection tracking doesn't just pick up connections
based on ACK packets willy-nilly after hypothetical reboots. So there
really is no security problem whatsoever.

It's all a matter of the policy set by the admin. If you have rules
that say to accept ESTABLISHED packets, and to accept tcp connections
to port 25 of your mailserver's IP address, and if your firewall =
reboots,
it's not like all of a sudden other ports to the mailserver will open=20
automagically!

If the mailserver sends a packet with sourceip=3Dit's IP, source =
port=3D25,
destip=3Dremote IP, destport=3D > 1023, it will get dropped, and if=20
the other end sends a non-SYN packet to port 25, it goes through and the =

connection picks up, just like you specified in the rules.=20

It's a feature I want, and I assume a lot of people want it, since
Checkpoint has been behaving exactly like this for many years.

If you're worried about weird scans, just specify tighter rules
and combine the ESTABLISHED and NEW states with additional checking
of TCP flags.

iptables offers flexibility, not a policy, and one should tailor=20
netfilter/iptables to one's needs/policy.

Regards,
Filip





------_=_NextPart_001_01C20D90.72502F00
Content-Type: text/html;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN">
<HTML>
<HEAD>
<META HTTP-EQUIV=3D"Content-Type" CONTENT=3D"text/html; =
charset=3DWindows-1252">
<META NAME=3D"Generator" CONTENT=3D"MS Exchange Server version =
6.0.5762.3">
<TITLE>RE: Security flaw in Stateful filtering ??????</TITLE>
</HEAD>
<BODY>
<!-- Converted from text/plain format -->

<P><FONT SIZE=3D2>Yes, it's that time of the month again :-)<BR>
<BR>
Emmanuel Fleury [<A =
HREF=3D"mailto:fleury@cs.auc.dk">mailto:fleury@cs.auc.dk</A>] wrote:<BR>
&gt;<BR>
&gt;Patrick Schaaf wrote:<BR>
&gt;<BR>
&gt;&gt; The behaviour is intentional. The reason is &quot;connection =
pickup&quot;. Imagine<BR>
&gt;&gt; a situation where the firewall reboots. All active conntracking =
information<BR>
&gt;&gt; will be lost. With the observed behaviour, connections are =
&quot;relearned&quot;<BR>
&gt;&gt; on the fly as they create new traffic.<BR>
&gt;<BR>
&gt;I simply disagree with you on this point (sorry :-/).<BR>
&gt;<BR>
&gt;I wouldn't accept to have such a flaw in my firewall just because =
of<BR>
&gt;an hypothetic reboot of one of my gateway !!!!<BR>
&gt;<BR>
&gt;Of course, I could be wrong, but in this case this 'feature' should =
be<BR>
&gt;highly documented and be disabled as default. IMHO.<BR>
<BR>
Hi Emmanuel,<BR>
<BR>
Please note that connection tracking doesn't just pick up =
connections<BR>
based on ACK packets willy-nilly after hypothetical reboots. So =
there<BR>
really is no security problem whatsoever.<BR>
<BR>
It's all a matter of the policy set by the admin. If you have rules<BR>
that say to accept ESTABLISHED packets, and to accept tcp =
connections<BR>
to port 25 of your mailserver's IP address, and if your firewall =
reboots,<BR>
it's not like all of a sudden other ports to the mailserver will =
open<BR>
automagically!<BR>
<BR>
If the mailserver sends a packet with sourceip=3Dit's IP, source =
port=3D25,<BR>
destip=3Dremote IP, destport=3D &gt; 1023, it will get dropped, and =
if<BR>
the other end sends a non-SYN packet to port 25, it goes through and =
the<BR>
connection picks up, just like you specified in the rules.<BR>
<BR>
It's a feature I want, and I assume a lot of people want it, since<BR>
Checkpoint has been behaving exactly like this for many years.<BR>
<BR>
If you're worried about weird scans, just specify tighter rules<BR>
and combine the ESTABLISHED and NEW states with additional checking<BR>
of TCP flags.<BR>
<BR>
iptables offers flexibility, not a policy, and one should tailor<BR>
netfilter/iptables to one's needs/policy.<BR>
<BR>
Regards,<BR>
Filip<BR>
<BR>
<BR>
<BR>
</FONT>
</P>

</BODY>
</HTML>
------_=_NextPart_001_01C20D90.72502F00--
