From: Kiran Kumar Immidi <immidi@spymac.com>
Subject: Re: NAT question
Date: Wed, 30 Jun 2004 07:28:29 -0600 (MDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040630132829.9B5144C0DC@spy10.spymac.net>
Reply-To: immidi@spymac.com
Mime-Version: 1.0
Content-Type: text/html;
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Content-Disposition: inline
To: immidi@spymac.com, netfilter-devel@lists.netfilter.org,
	Vijaya Chandra Vupputuri <vijay@tachyontech.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

<BR>
<BR>
Regards, <BR>
Kiran Kumar Immidi <BR>
<BR>
<B>On Wed, 30 Jun 2004 17:56 , Vijaya Chandra Vupputuri &lt;vijay@tachyon=
tech.net&gt; sent:<BR>
<BR>
</B>&gt;If A and B send packets to a server, say google.com:80 using the =
local<BR>
&gt;port 10000, when the pkts get SNATed on C, the source ports would be<=
BR>
&gt;different from 10000 (21000 and 32000 for example) and when google.co=
m<BR>
&gt;sends back the packets to those new port numbers, conntrack would cha=
nge<BR>
&gt;the dst-port numbers to 10000 along with the dst-ip address.<BR>
<BR>
&nbsp; Oh yes, this answers my question. But how about ICMP which does no=
t have a concept of port? <BR>
I have asked this in another mail.<BR>
<BR><hr>Cool Things Happen When Mac Users Meet! Join the community in Bos=
ton this July: www.macworldexpo.com
