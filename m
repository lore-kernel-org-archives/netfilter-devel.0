From: Ozgur AKAN <akan@aiqa.com>
Subject: inner structure of iptables
Date: Tue, 16 Mar 2004 17:12:34 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40571962.5070701@aiqa.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------040705000105070805070801"
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

This is a multi-part message in MIME format.
--------------040705000105070805070801
Content-Type: text/plain; charset=ISO-8859-9; format=flowed
Content-Transfer-Encoding: 7bit

I included some simple code to express myself clearly.

I have a problem with the 4th line. When we execute the code for the 
first time these happen (I wrote down)

In the 1st line we create the pointer to the structure of the table
In the 2nd and 3rd line we get the adress of first chain and print its 
name to screen.
In the 4th line "e = iptc_first_rule(chain, &h)" we get the adress of 
the first  rule of the first chain and by the loop it goes to next rule 
until there is no next rule. How does it know that it is the last rule 
of this chain? Why doesn`t it continue to read the first rule of next 
chain? (Because there is no chain information here -> e = 
iptc_next_rule(e, &h))

 1    h = iptc_init(tablename);
 2    for ( chain = iptc_first_chain(&h); chain; chain = 
iptc_next_chain(&h)) {
 3        printf("%s\n", chain);
 4        for ( e = iptc_first_rule(chain, &h); e; e = iptc_next_rule(e, 
&h)) {
 5            printf("n. -%u- i. -%u-\n", e->ip.invflags, e->ip.invflags 
& IPT_INV_SRCIP);
 6        }
 7    }

I hope my question is clear enough.

thanks,
Ozgur AKAN

--------------040705000105070805070801
Content-Type: text/html; charset=ISO-8859-9
Content-Transfer-Encoding: 8bit

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html;charset=ISO-8859-9">
  <title></title>
</head>
<body text="#000000" bgcolor="#ffffff">
<font face="microsoft-verdana-iso10646-1">I included some simple code
to express myself clearly. <br>
<br>
I have a problem with the 4th line. When we execute the code for the
first time these happen (I wrote down)<br>
<br>
In the 1st line we create the pointer to the structure of the table<br>
In the 2nd and 3rd line we get the adress of first chain and print its
name to screen.<br>
In the 4th line "</font><font face="microsoft-verdana-iso10646-1">e =
iptc_first_rule(chain, &amp;h)" we get the adress of the first  rule of
the first chain and by the loop it goes to next rule until there is no
next rule. How does it know that it is the last rule of this chain? Why
doesn`t it continue to read the first rule of next chain? (Because </font><font
 face="microsoft-verdana-iso10646-1">there is no chain information here
-&gt; e = iptc_next_rule(e, &amp;h)</font><font
 face="microsoft-verdana-iso10646-1">)<br>
</font><font face="microsoft-verdana-iso10646-1"><br>
 1    h = iptc_init(tablename);<br>
 2    for ( chain = iptc_first_chain(&amp;h); chain; chain =
iptc_next_chain(&amp;h)) {<br>
 3        printf("%s\n", chain);<br>
 4        for ( e = iptc_first_rule(chain, &amp;h); e; e =
iptc_next_rule(e, &amp;h)) {<br>
 5            printf("n. -%u- i. -%u-\n", e-&gt;ip.invflags,
e-&gt;ip.invflags &amp; IPT_INV_SRCIP);<br>
 6        }<br>
 7    }<br>
<br>
I hope my question is clear enough.<br>
<br>
thanks,<br>
Ozgur AKAN<br>
</font>
</body>
</html>

--------------040705000105070805070801--
