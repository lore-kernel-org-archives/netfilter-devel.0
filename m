From: "time" <time@mail.phinny.net>
Subject: Recoed destination IP in userspace before DNAT ??
Date: Tue, 20 May 2003 23:37:27 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001d01c31ee5$b9cba160$3702a8c0@MICROSOFT>
Reply-To: "time" <time@mail.phinny.net>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_001A_01C31F28.C61E4010"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_001A_01C31F28.C61E4010
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

Hi my dear friend,
    I am an engineer , and I am developing a special system need to =
record the destination IP before doing DNAT, and the Application will =
use the destination IP to do something in user space.
I have choose the ip_queue to mangle the packet to userspace, And use =
the sharememory to record all destination IP of the connections( sync ).
I hvave tried to extend my netlink recieve buffer, I have tried to copy =
a shorter length to userspace, I also tried to minize my userspace =
application to handle the packet from kernel.....
In a normal condition ( not too many connections ) , it works, and the =
flow just like this ( I use printk and printf )

1. nf_hook: Verdict =3D QUEUE.
2. enqueue!
3. going to send=20
4. status > 0=20
5. ipq receive
6. com!
7. Dequeue a packet if matched by cmp!
8. user space receive here

But when I use some test tool to make a lot of connections in a short =
time ( maybe 500 or 1000 connections ), I found that the flow changed. =
It looks like this

1. nf_hook: Verdict =3D QUEUE.
2. enqueue!
3. going to send
4. nf_hook: Verdict =3D QUEUE.
5. enqueue!
6. going to send
7.  ....
8.  ....
9.  .... (all the same as 1->2->3)
....
n.  user space receive here
n+1. read(): Failed to receive netlink message: No buffer space =
available

the queue will not send one by one ..... and will send at one time to =
make my netlink buffer full ....
I have setsockoption  to  655350, <- it's quite huge !

May I ask you.... Is the ip_queue working like this ?
Where can I tune in the ip_queue ?
Or, is there any other method to record the destination IP before DNAT =
in userspace ?

If I parse the /proc/net/ip_conntrack, will it make sense ?

I hope someone can help me, My god, It makes me mad !

By the way, thanks you at first , when you can be patient to read this =
letter. Thanks !!

                                                                         =
                                                                       =
time



------=_NextPart_000_001A_01C31F28.C61E4010
Content-Type: text/html;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dbig5">
<META content=3D"MSHTML 6.00.2722.900" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT size=3D2>Hi my dear friend,</FONT></DIV>
<DIV><FONT size=3D2>&nbsp;&nbsp;&nbsp; I am an engineer , and I am =
developing a=20
special system need to record the destination IP before doing DNAT, and =
the=20
Application will use the destination IP to do something in user=20
space.</FONT></DIV>
<DIV><FONT size=3D2>I have choose the ip_queue to mangle the packet to =
userspace,=20
And use the sharememory to record all destination IP of the connections( =
sync=20
).</FONT></DIV>
<DIV><FONT size=3D2>I hvave tried to extend my netlink recieve buffer, I =
have=20
tried to copy a shorter length to userspace, I also tried to minize my =
userspace=20
application to handle the packet from kernel.....</FONT></DIV>
<DIV><FONT size=3D2>In a normal condition (&nbsp;not too many =
connections )&nbsp;,=20
it works, and the flow&nbsp;just like this ( I use printk and printf=20
)</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>1. nf_hook: Verdict =3D QUEUE.<BR>2. enqueue!<BR>3. =
going to=20
send <BR>4. status &gt; 0 <BR>5. ipq receive<BR>6. com!<BR>7. Dequeue a =
packet=20
if matched by cmp!<BR>8. user space receive here</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>But when I use some test tool to make a lot of =
connections in=20
a short time ( maybe 500 or 1000 connections ), I found that the flow =
changed.=20
It looks like this</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>1. nf_hook: Verdict =3D QUEUE.<BR>2. enqueue!<BR>3. =
going to=20
send<BR>4. nf_hook: Verdict =3D QUEUE.<BR>5. enqueue!<BR>6. going to=20
send<BR>7.&nbsp; ....</FONT></DIV>
<DIV><FONT size=3D2>8.&nbsp; ....</FONT></DIV>
<DIV><FONT size=3D2>9.&nbsp; .... (all the same as =
1-&gt;2-&gt;3)</FONT></DIV>
<DIV><FONT size=3D2>....</FONT></DIV>
<DIV><FONT size=3D2>n.&nbsp; </FONT><FONT size=3D2>user space receive =
here<BR>n+1.=20
read(): Failed to receive netlink message: No buffer space=20
available</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>the queue will not send one by one ..... and will =
send at one=20
time to make my netlink buffer full ....</FONT></DIV>
<DIV><FONT size=3D2>I have&nbsp;setsockoption &nbsp;to&nbsp; 655350, =
&lt;- it's=20
quite huge&nbsp;!</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>May I ask you.... Is the&nbsp;ip_queue&nbsp;working =
like this=20
?</FONT></DIV>
<DIV><FONT size=3D2>Where can I tune&nbsp;in the ip_queue ?</FONT></DIV>
<DIV><FONT size=3D2>Or, is there any other method to record the =
destination IP=20
before DNAT in userspace ?</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>If I parse the /proc/net/ip_conntrack, will it make =
sense=20
?</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>I hope someone can help me, My god, It makes me mad=20
!</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>By the way, thanks you at first , when you can be =
patient to=20
read this letter. Thanks !!</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; =
&nbsp;&nbsp;&nbsp;=20
&nbsp;&nbsp;&nbsp; time</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_001A_01C31F28.C61E4010--
