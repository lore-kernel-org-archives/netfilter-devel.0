From: Kiran Kumar Immidi <immidi@spymac.com>
Subject: Re: NAT question
Date: Wed, 30 Jun 2004 07:25:11 -0600 (MDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040630132511.BC8004C079@spy10.spymac.net>
Reply-To: immidi@spymac.com
Mime-Version: 1.0
Content-Type: text/html;
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: Kiran Kumar Immidi <immidi@spymac.com>,
	netfilter-devel@lists.netfilter.org,
	Henrik Nordstrom <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

<B>On Wed, 30 Jun 2004 13:55 , Henrik Nordstrom &lt;hno@marasystems.com&g=
t; sent:<BR>
</B>&gt;By it's ip:port tuple (both source and destination).<BR>
&gt;<BR>
<FONT color=3Dred>&gt;&gt; So, if we have (identical, as regards port num=
bers and dest ip address)</FONT><BR>
<FONT color=3Dred>&gt;&gt; packets from A and B snatted at C, how is the =
reply (to C) identified as</FONT><BR>
<FONT color=3Dred>&gt;&gt; belonging to either A or B?</FONT><BR>
&gt;<BR>
&gt;By which port on C the reply traffic is addressed to.<BR>
<BR>
&nbsp; Suppose I have connections&nbsp;from A and B (both with coincident=
ally the same local port, say 3000), <BR>
both connecting to the same dest ip, port (say D:80). Now both are SNATte=
d at C. Firstly, Is this possible?<BR>
If it is the reply in both cases would be fro source D:80 to C:3000,&nbsp=
;an apparent problem.<BR>
<BR>
&gt;The NAT engine always guarantees that at least one field in the addre=
ss <BR>
&gt;tuple (source ip,port destination ip,port) is different as required t=
o <BR>
&gt;correctly identify individual connections for all involved.<BR>
<BR>
&nbsp; Then how about ICMP, suppose A and B send ICMP echo request to a m=
achine D, and the <BR>
requests are NATted at C, the reply in both cases would be from D to C. T=
hen would this be <BR>
allowed?<BR>Cool Things Happen When Mac Users Meet! Join the community in=
 Boston this July: www.macworldexpo.com
