From: "Ravi Saxena" <rsaxena@networkprograms.com>
Subject: Redirect problem in bridge
Date: Tue, 22 Jul 2003 14:10:52 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <00c301c3502c$f6cae120$33c909c0@rsaxena>
Mime-Version: 1.0
Content-Type: multipart/related;
	type="multipart/alternative";
	boundary="----=_NextPart_000_00BF_01C3505B.0F543A10"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "NetFilter" <netfilter-devel@lists.netfilter.org>
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

------=_NextPart_000_00BF_01C3505B.0F543A10
Content-Type: multipart/alternative;
	boundary="----=_NextPart_001_00C0_01C3505B.0F543A10"


------=_NextPart_001_00C0_01C3505B.0F543A10
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

BlankHello All,

I'm using bridge-nf-0.0.7-against-2.4.19.diff patch for bridge =
firewalling.

But I am facing a problem in adding this rule.

iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports =
8080
it always give error as invalid arguments.

Can anyone suggest the reason.

regards
Ravi Saxena







------=_NextPart_001_00C0_01C3505B.0F543A10
Content-Type: text/html;
	charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML><HEAD><TITLE>Blank</TITLE>
<META http-equiv=3DContent-Type content=3D"text/html; =
charset=3Dwindows-1252"><BASE=20
href=3D"file://C:\Program Files\Common Files\Microsoft =
Shared\Stationery\">
<STYLE>BODY {
	MARGIN-TOP: 25px; FONT-SIZE: 10pt; MARGIN-LEFT: 25px; COLOR: #000000; =
FONT-FAMILY: Arial, Helvetica
}
P.msoNormal {
	MARGIN-TOP: 0px; FONT-SIZE: 10pt; MARGIN-LEFT: 0px; COLOR: #ffffcc; =
FONT-FAMILY: Helvetica, "Times New Roman"
}
LI.msoNormal {
	MARGIN-TOP: 0px; FONT-SIZE: 10pt; MARGIN-LEFT: 0px; COLOR: #ffffcc; =
FONT-FAMILY: Helvetica, "Times New Roman"
}
</STYLE>

<META content=3D"MSHTML 5.50.4807.2300" name=3DGENERATOR></HEAD>
<BODY bgColor=3D#ffffff =
background=3Dcid:00be01c3502c$f59bfe10$33c909c0@rsaxena>
<DIV>Hello All,</DIV>
<DIV>&nbsp;</DIV>
<DIV>I'm using bridge-nf-0.0.7-against-2.4.19.diff patch for bridge=20
firewalling.</DIV>
<DIV>&nbsp;</DIV>
<DIV>But I am facing a problem in adding this rule.</DIV>
<DIV>&nbsp;</DIV>
<DIV>iptables -t nat -A PREROUTING&nbsp;-p tcp --dport 80 -j REDIRECT =
--to-ports=20
8080</DIV>
<DIV>it always give error as invalid arguments.</DIV>
<DIV>&nbsp;</DIV>
<DIV>Can anyone suggest&nbsp;the reason.</DIV>
<DIV>&nbsp;</DIV>
<DIV>regards</DIV>
<DIV>Ravi Saxena</DIV>
<DIV>&nbsp;</DIV>
<DIV>&nbsp;</DIV>
<P>&nbsp;</P>
<P>&nbsp;</P></BODY></HTML>

------=_NextPart_001_00C0_01C3505B.0F543A10--

------=_NextPart_000_00BF_01C3505B.0F543A10
Content-Type: image/bmp;
	name="nice.bmp"
Content-Transfer-Encoding: base64
Content-ID: <00be01c3502c$f59bfe10$33c909c0@rsaxena>

Qk0KOgAAAAAAAEIAAAAoAAAAVgAAAFYAAAABABAAAwAAAMg5AAAAAAAAAAAAAAAAAAAAAAAAAPgA
AOAHAAAfAAAAPOc857rW+9661jznutb73vve+9661jznPOd97zznfe99733vPOf73jznPOf73jzn
+9485/ve+9773jznfe99733v//++9773vvf//33vvvd97773fe///773POd97773POd9733vvve+
9773vve+9773vvd97773fe885zznfe88533vfe99733vfe99733vfe99733vfe997zznPOc85zzn
fe/73n3vPOc8533v+9773rrW+9661vveutb73rrW+9773jznPOd97zznvvd97zzn+9485zznPOf7
3jzn+9485/vePOc8533vfe997773//997///vve+933vvve+9773vve+9zznvvc8533vfe++933v
//997773fe///33vvvd9733vPOd97zznfe88533vfe++933vvvd97773POe+933vvvc85zzn+959
7zznPOc85773+9485zzn+9661vve+9773rrW+9773vve+9485zznfe99733vfe885/vePOc85/ve
POf73vve+9773vvePOd9733vfe//////vve+9///vve+933vvvd97///vvc8533vfe99733vvve+
9773vve+9773vve+933vvvd97zznPOd97zznfe99733vfe99733vvvd9733vfe++933vfe885zzn
POd97/vefe885zznfe/73vveutb73vve+9661vveutY85/vePOc85773POe+933vfe/73jznPOc8
5/vePOe61jznutY85/vevvc8533vvvf//33v//++9773fe++9773vve+9///POe+933vfe997773
vve+933vvvd97///fe++933vfe88533vfe997zznvvd97773fe++933vvvc85773fe++9/vefe/7
3n3vPOc8533vfe/73jznPOf73vve+9773vve+9773vve+9773jznfe88533vfe997zzn+9485zzn
+9485/ve+9773vve+9485zznfe997///vve+9773//997773fe///773//++933vfe++933vfe++
9773vve+9773vve+9773fe++933vPOc8533vPOd9733vvvd97773fe++933vfe99733vfe997zzn
POc8533v+9597zznPOd97zzn+9661jzn+9773rrW+9661vve+9485zznfe885773fe885/vePOc8
5zzn+94857rW+9661jzn+9597zznvve+9///fe///773vvd97773vve+9773//885773fe++933v
//++9///fe++933v//997773fe997zznfe88533vfe99733vvvd97773vve+9zznvvd97773POc8
5/vefe885zznPOe+9/vePOc85/ve+9773vve+9773vve+9773vve+959733vfe99733vPOf73jzn
POf73jzn+9773vve+9773n3vfe99733vvvf/////vve+9773vve+9773vvf//773fe997773POd9
733vvve+9773fe++9773vvd9733vfe997zznfe88533vvve+933vfe997773fe99733vvvd9733v
POc85zznPOc8533vPOc8533vPOc857rWPOf73jzn+9773rrW+9773jznPOe+9zznfe997zzn+948
5/vePOf73jzn+9773rrWPOf73r73fe++933v//++9773vvf//773vvd97///vvf//33vvvd9733v
fe++9773vvd97773fe///33vvvd9733vPOe+9zznfe885773fe++933vvve+9773fe++933vfe88
533vPOd97/vefe88533v+9485zzn+9773vvePOf73vve+9773vve+9773n3vPOd9733vfe885/ve
POc85/vePOf73vve+9773vvePOd9733vfe++9///vve+9773vve+9773vve+9773vvd9733vvvc8
533vfe++9773vvd97773vve+933vfe997zznPOd97zznfe997773fe99733vvvd9733vfe++933v
fe/73jznPOc85zznPOd97zznfe885zznutY85/vePOf73jznutb73vvefe88533vPOd9733vPOf7
3n3vPOc85/vePOe61vveutY85/vefe997773fe///773//++9773fe///33v//++9773fe++933v
vvc85773vvf//33vvvd97///fe++9zznvvc8533vPOd97zznvvd97773fe++933vvvd97773fe++
9zznfe88533v+9597zznfe885zznPOf73vve+9485/vePOf73vve+9773vvePOd9733vPOd97/ve
+9485zznPOc857rW+9773vve+9485zznfe997773//++9773vve+9773vve+9773vve+933vfe++
9zznfe997773vve+933vvve+933vfe99733vPOc8533vPOd9733vfe997773vve+933vfe997773
fe997zznPOc85zznPOd97zznPOd97zznPOf73jzn+9485/vePOf73vve+9485zznfe88533vPOd9
77rWPOc85zznPOf73rrW+9661jzn+9597zznvvd97///vve+933v//997773fe///773vvd9733v
fe997zznvve+9773fe++933v//997773fe997zznfe88533vPOe+933vvvd97773fe++933vvvd9
7773POd97zznfe/73n3vPOd97/vePOc85/ve+9773jznPOc85/vePOf73vvePOc85zznPOc8533v
+9773jznfe/73jzn+9773vve+9773jznPOd9733vvve+9773vve+9773vve+9773vve+9773fe99
733vfe99733vvve+9773fe++9773fe99733vfe885zznfe99733vfe99733vvvd97773fe++933v
vve+933vPOc85zznPOc8533vPOc8533v+9485/vePOf73jzn+9485/ve+9773jznPOd97zznfe88
5zzn+9597zznPOf73jznutb73vvePOc8533vPOe+933v//++9773fe///33vvvd97773vve+933v
fe997773POe+9773//997773fe///33vfe88533vPOd97zznfe88533vfe++933vvvd97773fe++
933vvvc8533vPOd97/vefe88533vPOc85zzn+9773vvePOf73jzn+9485/ve+9773jznPOc85zzn
fe885/vePOc85/vePOf73vve+9773vvePOc8533vPOe+9773vvd97773fe++9773fe997773fe99
733vfe88533vvve+9773fe997773fe++933vfe99733vPOc85zznfe997773vve+9773vvd9733v
fe++933vfe88533vPOd97zznfe997zznfe885zzn+9485/vePOf73jzn+9485/vePOc8533vPOd9
7zznfe/73n3v+9485/ve+9661jznutY85zznfe99733vfe///33vvvd97773fe++933vvvd97773
POe+9zznfe885///vve+9zznvvd97773fe++9zznvvc8533v+9597zznfe997773fe///33vvvd9
7773fe++9zznfe88533vPOd97zznfe885zznPOf73jzn+9485zznPOf73jzn+9773vvefe885zzn
POd97zznPOc85zzn+9773vve+9773vve+948533vfe997773vve+933vfe997773fe++933vvvd9
733vPOd97zznfe++9773vvd9733vvve+9773fe88533vfe/73n3vPOd9733vfe++9773vve+933v
vvd97773fe997zznPOd97zznPOd9733vPOd97zznPOf73jzn+9485/vePOf73jzn+9485zznfe/7
3n3vPOd97/vefe885zznutY857rWPOe61jznPOd97zznvvd97///fe++933vvvd97773fe99733v
vvc8533vfe997zznvve+9///POe+933vvvd9733vPOe+9zznPOc8533vPOd9733vvve+9773vve+
9zznvvd97773POd97zznfe88533vPOe+9zznPOc85zznPOf73jznPOc85/vePOc85/ve+9485zzn
POc8533vPOc85zznPOf73vve+9773vve+9773jznfe99733vvve+9773fe99733vvvd9733vfe++
933vfe88533vPOd97773vve+933vfe++933vvvd97zznfe997zznPOc8533vfe++9773vve+9773
fe++933vvvd9733vPOd97zznfe88533vfe99733vPOc85/vePOf73n3v+9485/vePOf73jznPOd9
7/vePOc8533v+9597zznPOf73jznutY85/vePOc8533vfe99733v//997773POe+933vvvd97773
fe++9zznfe88533vPOf//773vvc85773fe++933vvvc8533vPOc85zznfe88533vfe++933v//99
7773POe+933vvvc8533vPOd97zznfe997773POc8533v+9485/vePOc85zzn+9485/ve+9773jzn
POc85zznfe885zznPOc85/ve+9773vve+9773vvePOd9733vfe++9773vvd9733vfe99733vfe99
733vfe997zznfe88533vvve+9773fe997773fe++933vPOd9733v+9485zznfe997773vve+9773
vvd9733vfe99733vfe885zznfe997zznfe99733vfe885zzn+9485/vePOc85zzn+9485/vePOc8
5zzn+9485zznfe/73n3vPOc857rWPOf73vve+9485zznfe99733vfe///33vvvd9733vfe++933v
fe997773POd97zznfe885773vvf//zznvvd97773fe997zznfe885zzn+9597zznfe997773vve+
9773vvc85773fe++9zznPOc8533vPOd9733vvvc85zznPOc85zzn+9485zznPOc85zzn+9773vve
POc85zznPOd97zznPOc85zzn+9773jzn+9773jznPOc8533vfe997773vvd9733vfe99733vfe99
733vvvd9733vfe997zznfe997773vve+933vfe++933vPOc85zznfe885zznPOd9733vvve+9773
vve+933vvvd97773fe997zznPOc8533vfe99733vvvc85zznfe/73jzn+9597zznPOf73jznutY8
5/vefe/73n3vPOd97/vefe885zznutY85/ve+9773n3vPOe+933vvvd97///fe99733vvvd97773
fe++933vvvc85773POd97zzn//++9773fe++933vvvd9733vPOd97zznfe/73n3vPOe+933vvve+
9773vve+933vvvd9733vPOd97/vefe885773fe++933vPOc85zznPOc85zzn+9597zznPOf73jzn
+9485zznPOc8533vPOc85zznPOf73vvePOf73vve+948533vPOd9733vvvd9733vfe99733vfe99
7773fe99733vfe88533vPOd9733vvve+9773fe997773fe885zznPOd97zznPOc8533vfe++9773
vve+9773fe++933vfe99733vPOc85zznfe99733vfe++933vPOd97/vePOf73n3vPOc85zznPOe6
1jznPOc85/vefe88533v+9597zznPOe61n3v+9773vvefe88533vfe++933vvvc8533vPOe+9zzn
vvd97773fe99733vfe88533vfe++9773vvd9733vPOf//33vfe/73n3vPOd97/vefe885773fe//
/33vvvd97773fe++933vfe885zzn+96+9zznvvd97773fe885zznPOc85zznPOc85zznPOc85zzn
+9773jznPOc85zznfe885zznPOc85/ve+9485/ve+9485zznfe99733vfe99733vfe88533vfe99
733vfe997773fe997zznfe88533vvve+9773vvd9733vvvd97zznPOc8533vPOc85zznfe997773
fe++9773vvd97773fe++933vfe885zznPOd9733vvve+9773fe88533v+9485/vefe88533v+948
5/vePOf73n3v+9597zznfe/73n3vPOc857rWfe/73vve+9485zznfe997773fe++9zznPOc85773
POe+9zznvvd9733vfe997zznfe997773vve+933vfe885///fe997zznfe88533v+9597zznvvd9
7773fe++933vvvd97773fe997zznPOf73r73POe+933vvvd97zznfe885zzn+9485zznPOc85zzn
POf73vvePOc85zznPOd97zznPOc85zzn+9773jzn+9773jznPOd9733vfe99733vfe885zznPOd9
733vfe99733vfe99733vPOd97zznvve+9773vvd9733vPOe+933vPOc85zznfe885zznfe99733v
vvd97773fe99733vvvd9733vfe997zznPOc8533vfe++9773vvd97zznfe/73n3v+9597zznfe88
5zzn+9485zznPOf73n3vPOd97/vefe885zznutZ97/ve+9773n3vPOd9733vvvd9733vPOd97zzn
fe885773fe99733vfe88533vPOe+933vvve+9773fe997zzn//99733v+9597zznfe/73n3vfe99
733vvvd97773fe++933vvvd9733vPOd97/vevvd97773fe++9773POd9733vPOc85zznPOd97zzn
POf73vve+9485zznPOc8533vPOc85zznPOf73jzn+9485/vePOc85zznfe997zznfe885zzn+948
533vfe99733vfe99733vfe885zznfe997773vve+933vfe99733vfe885zznPOc85zzn+959733v
fe++933vfe99733vfe++9773vvd9733vPOf73n3vfe997773vve+933vPOd97zznPOc8533vfe99
7/vefe/73jznPOd97/vefe/73n3vPOc85/vePOf73jzn+9485/vePOc8533vfe997zznfe/73jzn
+959733vfe885773POd97zznfe88533vfe///773vvd9733vPOe+9zznfe/73n3v+9485/vefe88
5773fe++933vfe88533vfe++933vfe88533v+9597zznvvd97773fe88533vfe885zznPOc85773
POd97/ve+9773jznPOc85zznfe885zznPOc85/ve+9485zzn+9485zznPOc8533vPOd97zznPOf7
3jznPOd9733vfe99733vfe997zznPOd97773vve+9773fe997zznfe997zznPOc85zznPOc8533v
fe99733vfe99733vfe99733vfe++933vfe885/vefe99733vvvd97773fe885773POd97/vefe99
733vPOc85/vePOc8533v+9597zznfe88533v+9485/vePOf73jzn+9485zznfe88533vPOc85/ve
POf73jznPOe+9zznfe885773POc85zznfe997///vve+933vfe885773POc85/vefe/73jzn+96+
933vfe997773fe997zznfe997773fe997zznfe/73n3vPOe+9zznvvd97zznfe99733vPOc8533v
fe88533v+9773vvefe885zznPOc85zznPOc85zzn+9485zznPOc85zznPOc8533vfe885zznPOf7
3vve+948533vPOd9733vfe88533vPOc8533vfe++9773vvd9733vPOd97zznPOc85/vePOc85zzn
POd9733vfe99733vfe997zznfe99733vfe997zznPOc8533vPOd9733vfe997zznvvd9733vPOd9
733vfe88533v+9485zznfe/73n3vPOd97zznPOf73jzn+9597/vefe/73jznPOd97zznPOf73jzn
+9773vvePOc8533vPOd97zznfe88533v+959733v//++9773fe997zznvvc85zzn+9485zznPOf7
3r73POe+933vfe99733vPOd97zznfe99733vPOd97/vefe88533vPOd97zznPOd9733vfe997zzn
fe99733vPOc85/vePOc85zznPOc8533vPOc85zznPOf73vvePOc85zznPOc85zznPOd97zznPOf7
3vve+9773vvefe88533vPOd97zznPOc85zznfe++9773vve+933vPOd97zznPOf73jznPOc85zzn
POc8533vfe99733vfe88533vPOd9733vfe99733vPOf73jznfe885zznPOd9733vfe++9zznfe88
533vfe997zznPOf73jznPOd97/vefe88533v+9597/vePOf73n3vPOc85/vefe88533vPOd97/ve
POe61jznutY85zznfe88533vPOd97zznPOf73r73fe++9773vvd9733vPOd97zznPOf73jznPOc8
5/vevvc8533vfe99733vfe885zznPOe+9zznvvc8533v+9597zznfe88533vPOc8533vvve+9zzn
fe99733vfe997zznPOc85zznPOc85zznfe99733vPOc85/vePOc85zznPOc85zznPOf73jzn+977
3vve+9661vve+9485zznPOc85zznPOd97zznPOd97773vve+9773fe99733vPOd97zznfe885zzn
POd97zznfe99733vfe99733vfe/73jzn+9485zznfe885zznPOc85zznPOc85zznfe885773fe99
7zznvvd9733vPOc85/vefe88533vPOd97zznfe88533v+9485/vefe/73jzn+9485/vefe/73jzn
+94857rW+9661jzn+9597zznfe/73n3v+9597zznfe997773vve+933vfe88533vPOd97zznPOf7
3n3vPOd97zznfe885773POe+9zznPOf73n3vPOd97/vefe885zznPOc85zznfe/73jznfe997773
fe99733vfe88533vPOc85zznfe88533vPOd9733vfe885zznPOf73jznfe885zznPOc85/ve+977
3jzn+9773rrW+9773jznPOc85zznPOc85zznPOc8533vvve+9773vvd9733vPOc8533vPOd97zzn
POc8533vfe997zznfe99733vfe997/vePOf73n3vPOd97zznPOc85zznPOc85zznPOd97zznvvd9
7773POe+933vfe885zznPOd97zznfe88533vPOe+9zznfe885zznPOd97zznPOc85zzn+9485/ve
POf73jznutb73rrWPOf73n3v+9485/vePOf73jznPOd9733vvvd97773POd97zznfe88533vPOd9
7/vefe88533vPOd97zznvvc8533vPOc85/vefe88533vPOd97zznPOc85zznPOc85zznPOc8533v
vvd9733vvvd97zznPOc85zznPOd9733vfe88533vfe997zznfe885zznPOd97zznPOc85zzn+977
3vve+9773vveutb73vvePOc85zzn+9485/ve+9485zznPOe+933vvvd9733vPOc85zznfe99733v
POc85zznfe88533vfe99733vfe99733v+9485/vePOc8533vPOc85/vePOc8533vPOc8533vPOe+
933vvvd97///fe885zznfe885zznPOe+933vfe885773fe997zznfe88533vPOd97zznfe/73jzn
utY85/vePOe61vveutb73vvePOf73jznutY85/vePOf73n3vPOe+933vvvc8533v+9597zznfe88
533vPOd97zznfe88533vPOe+9zznfe885zzn+9597zznfe/73n3vPOc85/vefe885zzn+9485zzn
fe++9773vve+933vPOc85zznPOd9733vfe++933vfe99733vfe997zznfe99733vPOc85zznPOf7
3vve+9773vve+9661vve+9485zznPOf73vve+9773vvePOc8533vfe++933vfe885zznPOd9733v
fe885zznPOd97zznfe88533vfe99733vfe/73jzn+9597zznfe885zzn+9485zznfe/73jznfe88
533vfe++933v//885zznPOd97/vefe885773fe997zznvvd97773POd97zznvvc8533vPOd97/ve
POe61jzn+9773rrW+9661jzn+9485/vePOe61jzn+9773vvefe885773fe997zznPOf73n3vPOe+
9zznfe88533vPOd97zznfe885773POe+9zznPOf73n3vPOd97zznfe885/ve+9597zznfe/73jzn
POd97773vve+9773fe885zznPOd97zznfe++9773fe99733vfe99733vfe99733vfe99733vPOc8
5zzn+9773vve+9773rrWutb73jzn+9773vve+9773vve+9485/vePOd9733vfe997zznfe88533v
POd97zznfe88533vfe885zznvvc85773fe885/vePOc85zznPOd97zznPOc85zznfe997/vePOd9
7/vevvd97773vve+9zznfe88533vPOd9733vvve+933vfe99733vfe99733vfe997zznvvc8533v
+9485/vePOf73jznutb73rrW+9773jzn+9773rrW+9661jzn+9773vvefe99733vPOd97zznfe88
533vPOd97zznfe88533vPOe+933vfe885773POc85/vefe885zznPOd97/vePOf73r73POc85/ve
POc8533vvve+9773vvd97zznPOc8533vfe99733vvvd9733vfe99733vfe99733vfe99733vfe88
5zzn+9773vvePOf73vveutb73vve+9773jzn+9773vve+9773vve+9485zznfe88533vPOc8533v
fe88533vPOd97zznfe885zznPOd9733vfe997zzn+9485zznPOc8533vPOc85zznPOd9733vPOf7
3n3v+959733vvve+9773POd97zznfe885773fe++9773vvd97773fe++933vvvd9733vPOd97zzn
fe/73jzn+9485/vePOe61vveutb73vve+9661vveutY857rWPOe61jzn+9597zznfe88533vPOd9
7zznfe885773POd97zznvvc8533vfe99733vvvc85zznPOd97zznfe88533v+9485/vefe885zzn
+9485zznfe++933vvve+933vPOd97zznfe99733vvve+933vfe99733vfe99733vfe99733vfe99
7zznPOc85/ve+9485/ve+9661rrW+9773vve+9773vveutb73vve+9773vve+9485zznPOc8533v
POd9733vfe88533vfe997zznPOd9733vfe99733vPOf73jznPOc85zznfe885zznPOc8533vfe/7
3jznfe/73r73fe++933v//885zznPOd9733vfe997773vve+933vvvd97773fe++933vfe885773
POd97/vePOf73jzn+9485/ve+9661vveutb73rrW+9661vve+9773vve+9661jzn+9597zznfe/7
3n3vPOd97zznfe88533vPOe+9zznfe99733vfe++9zznPOf73n3vPOc85zznfe/73jzn+9597zzn
POe61jznPOc8533vfe++9773fe885zznfe99733vvvd97773fe++933vvvd97773fe++933vfe99
733vPOc85/ve+9773jzn+94857rWuta61vveuta61rrW+9661vve+9773rrW+9773vvePOd97zzn
POd9733vfe99733vfe99733vPOc85zznvvc8533vfe885/vePOc85zznPOd97zznPOf73jznfe99
7/ve+9597/vefe997773fe++9zznfe88533vfe++933vvve+9773fe++933vvvd97773fe++9zzn
fe88533v+9485/vePOf73jzn+9773rrW+9661vveutb73rrW+9661vveutb73rrW+9773n3vPOc8
5zznfe88533vPOd97zznfe885773POd9733vfe99733vPOc85zznfe88533vPOd97/vePOf73n3v
POc85/vePOc8533vvvd9733vvvd97zznfe99733vfe++9773//997773fe++933vfe99733vPOe+
933vfe885zznPOc85zznPOf73vve+9661rrWuta61rrW+9773vve+9773vve+9773vve+9485zzn
fe88533vPOd9733vPOd9733vfe99733vfe99733vfe99733v+9485zznPOc8533vPOc85/vePOc8
5zznPOf73n3v+959733vfe997773POd97zznvvd97773fe++9773vvd97773fe997zznvvd9733v
POe+933vfe/73n3vPOc85/vePOf73vveutb73nnO+9661vveutb73vvePOf73vveutY85/vefe88
533vPOe+9zznfe997zznPOe+9zznfe885773fe99733vfe885zzn+9597zznfe88533vPOc85zzn
POc8533vutY85zznPOe+933vfe99733vPOd9733vfe997773vvf//33vvvd9733vfe99733vfe99
733vfe997zznPOc85zznPOc85zzn+9773vveuta61rrWuta61vve+9773vve+9773vve+9773jzn
POc8533vfe997zznfe88533vfe99733vfe99733vfe99733vfe/73n3vPOc85zznfe885zzn+959
7/vePOc85/vefe/73n3vfe++933vvvc8533vPOe+933vvvd97773vve+933vvvd9733vPOd9733v
fe997773fe997zznPOc8533vPOc85/vePOe61vveec773rrW+9661jzn+9773vve+9661vve+959
7zznfe885773POd97zznfe885773POe+9zznvvd97773POd97zznPOc8533vPOd97zznfe/73jzn
POc85zznfe+61jznPOc8533vPOd97773fe88533vfe++933vvve+9///fe++933vfe88533vfe99
733vfe99733vPOc85zznPOc8533vPOc85/ve+9661rrWutb73rrW+9773vve+9773rrW+9773jzn
POc8533vPOd97zznfe997zznfe99733vfe99733vfe99733vfe997zznfe88533vPOd97zznPOf7
3jznPOc85zzn+9597/vefe99733vfe++9zznfe885773fe++933v//++9773fe++9zznfe885773
fe99733vvvd9733vPOc85zznfe88533vPOc857rW+955zrrWutb73vvePOf73jzn+9773rrWPOf7
3jznPOd97zznvvc85773POd97zznvvc8533vPOe+933vvvc85773POd97zznfe88533vPOd97/ve
POc85zznPOc857rWPOc85zznfe88533vfe997zznfe99733vfe++9773//++9773fe997zznfe88
533vfe99733vvvc8533vPOc8533vfe997zznPOf73rrWuta61rrW+9773vvePOf73vve+9773vve
+948533vPOd9733vfe88533vPOd9733vfe99733vfe99733vfe88533vPOd9733vPOc8533vPOc8
5/vePOf73n3vPOf73n3v+9597zznfe997773POd97zznvvd97773fe++9773vvd97773POd97zzn
fe99733vfe++933vfe885zznPOd97zznfe88533vutb73nnO+9661vve+9485/vePOe61jznutb7
3vvefe88533vPOe+9zznfe88533vPOe+9zznvvc85773POe+9zznvvc8533vPOd97zznfe88533v
+9485zznPOc8533vutY8533vPOd97zznfe99733vfe99733vfe997773vvf//33vvvd97zznPOc8
5zznfe99733vfe997zznPOd9733vfe99733vfe/73vveuta61rrW+9773vve+9773vve+9773rrW
+9485zznPOc8533vfe99733vfe885zznfe99733vfe++9773fe997zznfe88533vfe88533vfe88
5zzn+9773jznPOc85/vefe/73n3vPOd97zznfe99733vPOe+9zznvvd97///vve+9773vvf73n3v
POd9733vfe997773POd97zznfe885773fe++9zznPOe61vveec773rrWPOf73jznutY857rW+966
1vve+9597zznfe885773POe+933vPOc8533vPOd9733vvvd9733vPOd97zznfe885773POd97zzn
fe885zzn+9485zznfe+61jznfe885zznfe99733vfe99733vfe99733vvve+9773fe++933vPOc8
5zznPOd9733vfe99733vPOc85zznfe997773fe997zzn+9661rrWutb73vvePOf73jzn+9773vve
+9773jznPOc85zznfe++933vfe997zznPOd9733vPOd9733vfe99733vPOd97zznfe997zznfe99
7zznfe/73jznPOc85zzn+9597zznPOf73n3vPOd9733vvvc85773POe+933v//++9773vvd97/ve
fe885zznfe99733vvvc8533vPOd97zznvvd97773POd97/ve+955zvve+9773vvePOf73jzn+948
57rWPOf73n3v+9597zznvvc85773POd97/vevvc8533vfe++933vfe88533vfe997zznfe885773
POc85zznPOf73jznPOc857rWPOc85zznPOc8533vPOd9733vfe99733vfe++9773vvd97773fe88
5zznfe88533vfe99733vfe88533vPOd9733vvve+933vPOf73rrWuta61vve+9485zznPOc85zzn
+9773vvePOc85zznPOd97773fe99733vPOc8533vPOc8533vfe99733vfe88533vPOd9733vfe99
733vPOd97/vePOc85zznPOf73jznPOc85/vePOc8533vPOd97zznfe885773fe++9773vve+9773
+9597/vefe99733vPOe+9zznfe88533vfe++933vvvd9733v+9773rrW+9661jzn+9485zznfe/7
3jzn+9773vvePOf73n3vPOe+9zznvvd97zznPOd97zznfe885773fe997zznvvd9733vPOe+9zzn
vvc85zznPOd97/vefe885zznutY85zzn+9773jznPOc8533vfe99733vfe997773vve+933vvvd9
7zznPOd97zznfe99733vfe997zznfe88533vvve+9773fe885zznutb73rrW+9773jznPOc85zzn
POc85/ve+9485/vePOc8533vvvd9733vfe885zznfe885zznfe99733vfe997zznfe99733vPOd9
7773fe88533vPOc85zznPOc85/vefe/73jzn+9485zznfe885773POd97zznvvd97773vve+9773
fe/73n3vPOd9733vfe885773POd97zznfe997773vve+933vfe/73vveutb73rrWPOf73n3vPOd9
7zznPOf73jzn+9485/vePOc85///fe++9zznfe/73n3vPOc85zznfe99733vPOe+933vfe88533v
fe++9zznPOd9733vPOc85zznPOe61jznfe/73jzn+9485zznPOc8533vPOd97zznvve+9773fe++
933vPOc85zznPOd97zznfe99733vPOd9733vfe997///vvd97zznPOe61vveutY85/vePOc85zzn
POd97/vePOc85zznPOf73jznfe99733vfe885zznPOc8533vPOd9733vfe885zznfe997zznvvd9
733vfe997zznPOf73jznPOc85/ve+9597/vePOf73jzn+9597zznfe88533vPOd9733vvve+933v
vvd97/vefe88533vfe997zznvvc8533vPOe+933vvve+9773fe997/ve+9661jznutY85/vePOf7
3n3vPOc85/vePOc85zzn+9597zznvvd9733vPOc85/vefe885zznPOd9733vfe88533vfe997zzn
vvc85773POd97zznPOf73n3vPOf73rrWPOd97/ve+9773jznPOc85zznfe88533vPOe+9773vvd9
7773fe885zznPOc85773POd97zznfe88533vfe99733v//++933vfe8857rW+9773vvePOc85zzn
POc8533vPOc85zznPOc85zznPOd9733vfe99733vPOc85zznfe88533vfe997zznfe885773POd9
733vfe++933vPOc85/vePOc85zznPOf73n3v+9485/vePOf73n3v+9597zznfe/73n3vfe++933v
vvd9733v+9597zznfe88533vPOd97zznfe885773fe++9773vvd97773+9773vve+9773jzn+959
7zznfe885zzn+9597zznfe/73n3vfe++933vfe885zzn+9597zznfe88533vPOd97zznfe99733v
fe997zznvvc85zznPOc85zznfe/73jznutY85zzn+9773vvePOc85zznPOc85zznPOc85773fe++
933vvvd97zznPOc85zznvvc85zznPOd97zznfe997773fe///773fe997zzn+9485/ve+9485zzn
POc8533vfe885zznPOd97zznPOc8533vfe++933vfe885zznPOd97/vefe99733vPOc85zznfe88
533vfe99733vfe885zzn+9485zznPOf73vvePOf73jzn+9773vvePOf73jzn+9597/vefe885773
fe++933vfe/73n3vPOd97zznPOc8533vPOd97zznvvd97773fe///33vvvf73jzn+9485/vePOc8
5zznPOd9733vPOc8533vfe997zznfe997773POe+9zznPOc8533vfe885zznfe88533v+96+933v
POd9733vPOe+9zznfe885zzn+9597zzn+9661jznPOf73vve+9485zznPOc85zznPOc85zznfe99
733vfe++933v+9485zznPOd97zznPOc85zznPOd9733vvvd97///vvd9733vPOf73jzn+9485zzn
POc8533vPOd97zznPOc8533vfe997zznfe++9773fe885zznPOc8533vPOd97zznfe885zznPOd9
7zznfe99733vfe997/vePOf73jznPOc85zzn+9485/ve+9661jzn+9485/vePOc85zzn+9597zzn
vvd9733vfe997/vefe88533vPOd97/vefe88533vPOe+933vvve+9///fe++9zznPOf73jzn+948
5zznfe88533vfe885zznfe99733vPOd9733vvvd97773POd97/vefe997zznPOd97zznfe88533v
fe88533vfe885773POc85zznPOf73n3v+94857rWPOf73vve+9661vve+9485/vePOf73jznPOd9
733vfe99733vPOc85zznPOc8533v+9485zznPOc8533vfe++933vvve+9773POd97zznPOf73jzn
+9597zznPOd9733vPOc8533vfe99733vfe99733vvvd9733vPOc85zznfe/73jznfe997zznPOd9
733vPOd97zznfe99733vPOc85zznPOc85zznPOf73jzn+9773rrW+9661jzn+9485/vePOf73jzn
POe+933vfe99733v+9485/vePOc85zznPOd97zznfe885773vve+9773//99733v+9597/vePOf7
3jznPOd97/vevvd97zznPOe+933vfe88533vfe++933vvvc8533vPOd97zznPOc8533vPOd97zzn
fe99733vPOd97zznvvc8533vPOc85/vefe885zznutY85zznuta61rrW+9773jzn+9485/vePOc8
5zznfe99733vfe885zznPOc85zznfe/73jznPOc85zznfe997773fe++9773vvd9733vPOc85zzn
POf73n3vfe88533vfe88533vPOe+933vfe99733vvve+933vfe88533vPOd97/vefe88533vPOc8
5zznfe99733vPOd9733vfe885zznPOc85zznPOc85/vePOf73vveutb73rrW+9773jzn+9485/ve
fe88533vfe99733vPOf73jzn+9485zznPOf73n3v+9597zznvvd97773vvf//33vvvc8533vPOc8
5zznPOc85773POe+933vfe885773fe++9zznvvd97773fe++9zznfe88533vPOd97/vefe88533v
POd9733vvvc8533vPOe+9zznPOc8533v+9597/vefe/73jznPOe61vveutb73vve+9773vve+948
5/vePOd9733vfe997zzn+9485/ve+9485/vePOc85zznPOc8533vvvd97///vve+933vfe99733v
POd97/vefe997zznfe997zznfe997773fe99733vvve+9773fe997zznfe88533v+959733vfe88
533vPOe+9zznfe88533vvvd97/vefe/73jznPOd97zzn+9597/vePOe61rrWutb73rrWPOe61jzn
+9485zznvvd9733vPOd97/vePOf73jznPOc85/vePOf73jznPOd9733vvvd97///vve+933vvvc8
533vfe99733vvvc85773fe997zznvve+9773fe++933vvvd97773fe997zznfe997zznPOd97zzn
fe/73r73fe++933vfe885773POd97/vefe/73n3vPOd977rWPOc857rWuta61vveutb73vve+977
3vve+9597zznfe99733vPOf73jzn+9773jzn+9485zznPOc85zznfe99733v//++9773fe++933v
fe99733vPOd97773fe99733vPOd9733vvve+933vfe++9773vvd9733vfe997zznfe88533vfe99
7zznfe99733vfe++9zznfe++933v+9485zznPOc85zznPOc8533v+9773rrWuta61vveutb73rrW
+9773jznPOd9733vfe997zznutY85/ve+9773jzn+9485/vePOc8533vfe++933v//++9773fe++
933vfe99733vfe++9zznvvd9733vfe++933v//997773fe///33vvvc8533vPOd97zznPOc8533v
POd97zznfe997773fe997zznvvc85zzn+9597/vefe885zzn+94=

------=_NextPart_000_00BF_01C3505B.0F543A10--
