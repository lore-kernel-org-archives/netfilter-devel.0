From: Ozgur AKAN <akan@aiqa.com>
Subject: Re: mask for interface
Date: Fri, 26 Mar 2004 16:40:51 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <406440F3.8010203@aiqa.com>
References: <40629EB1.4080005@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------010902040402090801000903"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <40629EB1.4080005@aiqa.com>
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
--------------010902040402090801000903
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

In the manual of iptables there is nothing about the mask value of an 
interface. + sign at the end of a few characters of an interface means 
any interface which begins with this name will match.

Again what I wonder is the why iniface_mask value is used???

thanks,
Ozgur AKAN

---------------------------------------------------------------------
*-i, --in-interface *[!] [/name/]
    Optional name of an interface via which a packet is received (for
    packets entering the *INPUT*, *FORWARD* and *PREROUTING* chains).
    When the "!" argument is used before the interface name, the sense
    is inverted. If the interface name ends in a "+", then any interface
    which begins with this name will match. If this option is omitted,
    the string "+" is assumed, which will match with any interface name.
*-o, --out-interface *[!] [/name/]
    Optional name of an interface via which a packet is going to be sent
    (for packets entering the *FORWARD*, *OUTPUT* and *POSTROUTING*
    chains). When the "!" argument is used before the interface name,
    the sense is inverted. If the interface name ends in a "+", then any
    interface which begins with this name will match. If this option is
    omitted, the string "+" is assumed, which will match with any
    interface name.
------------------------------------------------------------------------


--------------010902040402090801000903
Content-Type: text/html; charset=us-ascii
Content-Transfer-Encoding: 7bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-9">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
Hi,<br>
<br>
In the manual of iptables there is nothing about the mask value of an
interface. + sign at the end of a few characters of an interface means
any
interface which begins with this name will match.<br>
<br>
Again what I wonder is the why iniface_mask value is used???<br>
<br>
thanks,<br>
Ozgur AKAN<br>
<br>
---------------------------------------------------------------------<br>
<dt><b>-i, --in-interface </b>[!] [<i>name</i>]
</dt>
<dd>Optional name of an interface via which a packet is received (for
packets entering the <b>INPUT</b>,
  <b>FORWARD</b>
and
  <b>PREROUTING</b>
chains). When the "!" argument is used before the interface name, the
sense is inverted. If the interface name ends in a "+", then any
interface which begins with this name will match. If this option is
omitted, the string "+" is assumed, which will match with any
interface name.<br>
</dd>
<dt><b>-o, --out-interface </b>[!] [<i>name</i>]
</dt>
<dd>Optional name of an interface via which a packet is going to
be sent (for packets entering the
  <b>FORWARD</b>,
  <b>OUTPUT</b>
and
  <b>POSTROUTING</b>
chains). When the "!" argument is used before the interface name,
the sense is inverted. If the interface name ends in a "+", then any
interface which begins with this name will match. If this option is
omitted, the string "+" is assumed, which will match with any
interface name.</dd>
<br>
------------------------------------------------------------------------<br>
<dd><br>
</dd>
</body>
</html>

--------------010902040402090801000903--
