From: "=?big5?B?p06k6Q==?=" <raykey@dinyi.com.tw>
Subject: How to bind 2 WAN 1LAN on iptables?
Date: Thu, 24 Oct 2002 13:37:02 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <004a01c27b1f$7954d300$5101a8c0@dinyi.com.tw>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0026_01C27B62.6F655AC0"
Cc: <netfilter-devel@lists.samba.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-announce@lists.netfilter.org>
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

------=_NextPart_000_0026_01C27B62.6F655AC0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_0027_01C27B62.6F655AC0"


------=_NextPart_001_0027_01C27B62.6F655AC0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

Dear all...

I'm a Chinese and I don't think that my English is well .
But I have a big problem in use IPTABLES .
I've looked all the documents and FAQs , but I can't find a solution to =
solve my problem .
At last I decide to ask you in my poor English ...^^||

I have a Linux server (Turbo Linux7.0 in kernel 2.4.9-3) to be my NAT =
server .
I have make it running iptables-1.2.2-6 .
It have 3 NIC(Network interface Card) eth0.eth1.eth2 .
I have 1 LAN and 2 WAN interface they are 192.168.1.0/255.255.255.0 and =
2 ADSL (one of my ADSL is pppoe another one is static IP) .
Now I want to bind thy all in my NAT server .
I rty to cut my LAN to 4 part are 192.168.1.0/255.255.255.192 & =
192.168.1.64/255.255.255.192 & 192.168.1.128/255.255.255.192 & =
192.168.1.192/255.255.255.192 .

That I wish the preceding 3 part go out and in with the pppoe ADSL =
(ppp0) and the final part go through with static IP(because they are my =
servers) .

The following diagram would illustrate it quite well if I had any =
artistic talent:

My biggest problem is in Linux I can't set the default gateway otherwise =
the ppp0 will not work .
But if ppp0 is working I can't find who to make my final part =
(192.168.1.192/26) go through the eth0 out or come in ...-.-"

At last , I'll sorry for all who read this mail .
I have do my best to explain my problem .
If you can't understand my question maybe can find somebody who know my =
English or can talk in Chinese will better .

Sincerely yours
thanks a lot... ^.^

--------------------------------------------------
Dinyi Printing CO. LTD
RaykeySu
raykey@dinyi.com.tw
--------------------------------------------------
=B9=A9=A9=F6=A6L=A8=EA=B8=EA=B0T=AB=C7
mis@dinyi.com.tw
--------------------------------------------------
------=_NextPart_001_0027_01C27B62.6F655AC0
Content-Type: text/html;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dbig5">
<META content=3D"MSHTML 6.00.2800.1106" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV><FONT size=3D2>Dear all...</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2>I'm a Chinese and I don't think that my English is =
well=20
.<BR>But I have a big problem in use IPTABLES .<BR>I've looked all the =
documents=20
and FAQs , but I can't find a solution to solve my problem .<BR>At last =
I decide=20
to ask you in my poor English ...^^||</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2>I have a Linux server (Turbo Linux7.0 in kernel =
2.4.9-3) to be=20
my NAT server .<BR>I have make it running iptables-1.2.2-6 .<BR>It have =
3=20
NIC(Network interface Card) eth0.eth1.eth2 .<BR>I have 1 LAN and 2 WAN =
interface=20
they are 192.168.1.0/255.255.255.0 and 2 ADSL (one of my ADSL is pppoe =
another=20
one is static IP) .<BR>Now I want to bind thy all in my NAT server =
.<BR>I rty to=20
cut my LAN to 4 part are 192.168.1.0/255.255.255.192 &amp;=20
192.168.1.64/255.255.255.192 &amp; 192.168.1.128/255.255.255.192 &amp;=20
192.168.1.192/255.255.255.192 .</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2>That I wish the preceding 3 part go out and in with =
the pppoe=20
ADSL (ppp0) and the final part go through with static IP(because they =
are my=20
servers) .</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2>The following diagram would illustrate it quite well =
if I had=20
any artistic talent:</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2>My biggest problem is in Linux I can't set the =
default gateway=20
otherwise the ppp0 will not work .<BR>But if ppp0 is working I can't =
find who to=20
make my final part (192.168.1.192/26) go through the eth0 out or come in =

...-.-"</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2>At last , I'll sorry for all who read this mail =
.<BR>I have do=20
my best to explain my problem .<BR>If you can't understand my question =
maybe can=20
find somebody who know my English or can talk in Chinese will better=20
.</FONT></DIV>
<DIV>&nbsp;</DIV>
<DIV><FONT size=3D2>Sincerely yours<BR>thanks a =
lot...&nbsp;^.^</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>----------<FONT size=3D2>----------<FONT =
size=3D2>----------<FONT=20
size=3D2>----------<FONT=20
size=3D2>----------</FONT></FONT></FONT></FONT></FONT></DIV>
<DIV><FONT size=3D2>Dinyi Printing CO. LTD</FONT></DIV>
<DIV><FONT size=3D2>RaykeySu</FONT></DIV>
<DIV><FONT size=3D2><A=20
href=3D"mailto:raykey@dinyi.com.tw">raykey@dinyi.com.tw</A></FONT></DIV>
<DIV><FONT size=3D2>
<DIV><FONT size=3D2>----------<FONT size=3D2>----------<FONT =
size=3D2>----------<FONT=20
size=3D2>----------<FONT=20
size=3D2>----------</FONT></FONT></FONT></FONT></FONT></DIV>
<DIV>=B9=A9=A9=F6=A6L=A8=EA=B8=EA=B0T=AB=C7</DIV>
<DIV><A href=3D"mailto:mis@dinyi.com.tw">mis@dinyi.com.tw</A></DIV>
<DIV>
<DIV><FONT size=3D2>----------<FONT size=3D2>----------<FONT =
size=3D2>----------<FONT=20
size=3D2>----------<FONT=20
size=3D2>----------</FONT></FONT></FONT></FONT></FONT></DIV></DIV></FONT>=
</DIV></BODY></HTML>

------=_NextPart_001_0027_01C27B62.6F655AC0--

------=_NextPart_000_0026_01C27B62.6F655AC0
Content-Type: text/plain;
	name="iptable_question_mail.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="iptable_question_mail.txt"

Dear all...

I'm a Chinese and I don't think that my English is well .
But I have a big problem in use IPTABLES .
I've looked all the documents and FAQs , but I can't find a solution to =
solve my problem .
At last I decide to ask you in my poor English ...^^||

I have a Linux server (Turbo Linux7.0 in kernel 2.4.9-3) to be my NAT =
server .
I have make it running iptables-1.2.2-6 .
It have 3 NIC(Network interface Card) eth0.eth1.eth2 .
I have 1 LAN and 2 WAN interface they are 192.168.1.0/255.255.255.0 and =
2 ADSL (one of my ADSL is pppoe another one is static IP) .
Now I want to bind thy all in my NAT server .
I rty to cut my LAN to 4 part are 192.168.1.0/255.255.255.192 & =
192.168.1.64/255.255.255.192 & 192.168.1.128/255.255.255.192 & =
192.168.1.192/255.255.255.192 .

That I wish the preceding 3 part go out and in with the pppoe ADSL =
(ppp0) and the final part go through with static IP(because they are my =
servers) .

The following diagram would illustrate it quite well if I had any =
artistic talent:

	|------------------|
	| 192.168.1.0 ~ 63 |----+					   (ppp0)
	|------------------|	|	|-----------------------|	|-----------|
				|>......|...........>DHCP (eth2)|-------|ADSL modem |------WAN (Just =
NAT)
	|------------------|	|	|			|	|-----------|
	|192.168.1.64 ~ 128|----+	|			|
	|------------------|	|	|			|	|-----------|
				|	|     61.aa.bb.cc (eth0)|-------|61.aa.bb.cd|------WAN (NAT + PAT)
	|------------------|	|	|			|	|-----------|
	|192.168.1.129~ 191|----+-------|192.168.1.254	(eth1)	|	  (Gateway)
	|------------------|		|-----------------------|		|
						|<>...........................<>|
	|------------------|			|
	|192.168.1.192~ 254|--------------------+
	|------------------|

My biggest problem is in Linux I can't set the default gateway otherwise =
the ppp0 will not work .
But if ppp0 is working I can't find who to make my final part =
(192.168.1.192/26) go through the eth0 out or come in ...-.-"

At last , I'll sorry for all who read this mail .
I have do my best to explain my problem .
If you can't understand my question maybe can find somebody who know my =
English or can talk in Chinese will better .

Sincerely yours
thanks a lot...	^.^
------=_NextPart_000_0026_01C27B62.6F655AC0--
