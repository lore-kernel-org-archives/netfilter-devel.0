From: Philip Ho <cbho@ie.cuhk.edu.hk>
Subject: Re: How to change a match options
Date: Wed, 09 Apr 2003 09:45:38 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E937B42.7E239980@ie.cuhk.edu.hk>
References: <000001c2fdc3$fd33ddc0$0300000a@juan>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------51687A9E8C0455E5FDD1B262"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Juan Torres <islero77@telefonica.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--------------51687A9E8C0455E5FDD1B262
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by eng.ie.cuhk.edu.hk id h391iv701494

Dear Juan

I am also a beginner on developing an iptables extension. I guess you
can add options by modifying struct option. In my dscp match file, I
have this struct.

static struct option opts[] =3D {
 { "dscp", 1, 0, 'F' },
 { "dscp-class", 1, 0, 'G' },
 { 0 }
};

Got it?

Regards,
philip



Juan Torres wrote:

> Hi, I want to make my own match, but before, to understand how it
> works, I=92m modifying an existing match, ipt_multiport to be precise,
> so, I have changed the ipt_multiport.c file. But now I want to change
> the match writing options (for example, to add a new option similar
> than =96dport, or to make that it wouldn=92t be necessary to write any
> option) So I need to know which file I have to modify to change the
> =93writing options=94 of a match.
>
> Thanks a lot.
>
>         Juan
>

--------------51687A9E8C0455E5FDD1B262
Content-Type: text/html; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by eng.ie.cuhk.edu.hk id h391iv701494

<!doctype html public "-//w3c//dtd html 4.0 transitional//en">
<html>
Dear Juan
<p>I am also a beginner on developing an iptables extension. I guess you
can add options by modifying struct option. In my dscp match file, I have
this struct.
<p>static struct option opts[] =3D {
<br>&nbsp;{ "dscp", 1, 0, 'F' },
<br>&nbsp;{ "dscp-class", 1, 0, 'G' },
<br>&nbsp;{ 0 }
<br>};
<p>Got it?
<p>Regards,
<br>philip
<br>&nbsp;
<br>&nbsp;
<p>Juan Torres wrote:
<blockquote TYPE=3DCITE><!-- Converted from text/rtf format -->
<p><span LANG=3D"en-gb"><font face=3D"Arial"><font size=3D-1>Hi,</span><s=
pan LANG=3D"es"></span><span LANG=3D"es"></span><span LANG=3D"en-gb"></fo=
nt></font>
<font face=3D"Arial"><font size=3D-1>I want to make my own match, but bef=
ore,
to understand how it works,</span><span LANG=3D"es"></span><span LANG=3D"=
es"></span><span LANG=3D"en-gb"></font></font>
<font face=3D"Arial"><font size=3D-1>I</span><span LANG=3D"es"></span><sp=
an LANG=3D"es"></span><span LANG=3D"en-gb">=92</span><span LANG=3D"es"></=
span><span LANG=3D"es"></span><span LANG=3D"en-gb">m
modifying</span><span LANG=3D"es"></span><span LANG=3D"es"></span><span L=
ANG=3D"en-gb"></font></font>
<font face=3D"Arial"><font size=3D-1>an existing</span><span LANG=3D"es">=
</span><span LANG=3D"es"></span><span LANG=3D"en-gb">
match,</span><span LANG=3D"es"></span><span LANG=3D"es"></span><span LANG=
=3D"en-gb"></font></font>
<font face=3D"Arial"><font size=3D-1>ipt_multiport to be precise</span><s=
pan LANG=3D"es"></span><span LANG=3D"es"></span><span LANG=3D"en-gb">,</s=
pan><span LANG=3D"es"></span><span LANG=3D"es"></span><span LANG=3D"en-gb=
"></span><span LANG=3D"es"></span><span LANG=3D"es"></span><span LANG=3D"=
en-gb"></font></font>
<font face=3D"Arial"><font size=3D-1>s</span><span LANG=3D"es"></span><sp=
an LANG=3D"es"></span><span LANG=3D"en-gb">o,
I have changed</span><span LANG=3D"es"></span><span LANG=3D"es"></span><s=
pan LANG=3D"en-gb"></font></font>
<font face=3D"Arial"><font size=3D-1>the ipt_multiport.c file. But now I =
want
to change</span><span LANG=3D"es"></span><span LANG=3D"es"></span><span L=
ANG=3D"en-gb"></font></font>
<font face=3D"Arial"><font size=3D-1>the match writing options (for examp=
le,</span><span LANG=3D"es"></span><span LANG=3D"es"></span><span LANG=3D=
"en-gb"></font></font>
<font face=3D"Arial"><font size=3D-1>to add a new option similar than</sp=
an><span LANG=3D"es"></span><span LANG=3D"es"></span><span LANG=3D"en-gb"=
></font></font>
<font face=3D"Arial"><font size=3D-1>=96</span><span LANG=3D"es"></span><=
span LANG=3D"es"></span><span LANG=3D"en-gb">dport</span><span LANG=3D"es=
"></span><span LANG=3D"es"></span><span LANG=3D"en-gb">,
or to make that it wouldn</span><span LANG=3D"es"></span><span LANG=3D"es=
"></span><span LANG=3D"en-gb">=92</span><span LANG=3D"es"></span><span LA=
NG=3D"es"></span><span LANG=3D"en-gb">t
be nece</span><span LANG=3D"es"></span><span LANG=3D"es"></span><span LAN=
G=3D"en-gb">s</span><span LANG=3D"es"></span><span LANG=3D"es"></span><sp=
an LANG=3D"en-gb">sary
to write any option</span><span LANG=3D"es"></span><span LANG=3D"es"></sp=
an><span LANG=3D"en-gb">)
So I need to know which file I have to modify</span><span LANG=3D"es"></s=
pan><span LANG=3D"es"></span><span LANG=3D"en-gb">
to change the</span><span LANG=3D"es"></span><span LANG=3D"es"></span><sp=
an LANG=3D"en-gb"></font></font>
<font face=3D"Arial"><font size=3D-1>=93</span><span LANG=3D"es"></span><=
span LANG=3D"es"></span><span LANG=3D"en-gb">writing</span><span LANG=3D"=
es"></span><span LANG=3D"es"></span><span LANG=3D"en-gb"></font></font>
<font face=3D"Arial"><font size=3D-1>options</span><span LANG=3D"es"></sp=
an><span LANG=3D"es"></span><span LANG=3D"en-gb">=94</span><span LANG=3D"=
es"></span><span LANG=3D"es"></span><span LANG=3D"en-gb">
of a match</span><span LANG=3D"es"></span><span LANG=3D"es"></span><span =
LANG=3D"en-gb">.</font></font></span>
<p><span LANG=3D"en-gb"><font face=3D"Arial"><font size=3D-1>Thanks a lot=
.</font></font></span>
<p><span LANG=3D"en-gb">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <font =
face=3D"Arial"><font size=3D-1>Juan</font></font></span><span LANG=3D"es"=
></span><span LANG=3D"es"></span><span LANG=3D"en-gb"></span>
<br>&nbsp;</blockquote>
</html>

--------------51687A9E8C0455E5FDD1B262--
