From: "ihira" <ihira@rain.amath.nchu.edu.tw>
Subject: A proble about using libiptc function
Date: Fri, 11 Apr 2003 22:24:16 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <002201c30036$08793120$7d08788c@ihira>
Mime-Version: 1.0
Content-Type: multipart/alternative;
	boundary="----=_NextPart_000_001F_01C30079.1691C2C0"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "netfilter-devel" <netfilter-devel@lists.netfilter.org>
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

------=_NextPart_000_001F_01C30079.1691C2C0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

Dear all :

I have a proble about using libiptc function "iptc_append_entry".
When use this function, we should pass an argument *ipt_enrty.
This argument include the IP header information!
But where we pass the other information like tcp port to the function =
for appending a rule to netfilter?

I hope somebody can give me an example code for adding a rule to =
netfilter !

I am sorry about my poor English and thank for everyone spending time =
and pations to read my letter!
Good luck for everyone and everyone's family=20

------=_NextPart_000_001F_01C30079.1691C2C0
Content-Type: text/html;
	charset="big5"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD>
<META http-equiv=3DContent-Type content=3D"text/html; charset=3Dbig5">
<META content=3D"MSHTML 6.00.2800.1141" name=3DGENERATOR>
<STYLE></STYLE>
</HEAD>
<BODY bgColor=3D#ffffff>
<DIV>
<DIV><FONT size=3D2>Dear all :</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>I have a proble about using libiptc function=20
"iptc_append_entry".</FONT></DIV>
<DIV><FONT size=3D2>When use this function, we should pass an argument=20
*ipt_enrty.</FONT></DIV>
<DIV><FONT size=3D2>This argument include the IP header =
information!</FONT></DIV>
<DIV><FONT size=3D2>But where we pass the other information like tcp =
port to the=20
function for appending a rule to netfilter?</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV><FONT size=3D2>I hope somebody can give me an example code for =
adding a rule=20
to netfilter !</FONT></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV>
<DIV>
<DIV><FONT size=3D2>I am sorry about my poor English and thank =
for&nbsp;everyone=20
spending time and pations to read my letter!</FONT></DIV>
<DIV><FONT size=3D2>Good&nbsp;luck for&nbsp;everyone and&nbsp;everyone's =

family</FONT>&nbsp;</DIV></DIV></DIV>
<DIV><FONT size=3D2></FONT>&nbsp;</DIV></BODY></HTML>

------=_NextPart_000_001F_01C30079.1691C2C0--
