From: Kim Jensen <kimj@dawn.dk>
Subject: NAT/MASQUERADING conntrack problem
Date: Mon, 24 Mar 2003 21:38:33 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200303242138.33213.kimj@dawn.dk>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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

Hello gods,

Sorry for sending a mail like this, but I'm desperate. I have read all=20
faqs/howtos I could find and tried the LARTC & Netfilter lists without a=20
solution to my problem. I have a setup with two internet connections, one=
=20
fast with 32 static IP's and one slow dynamic, default route is through t=
he=20
slow dynamic source.

My problem is that in my setup I keep loosing control over packets from=20
external origin to my internal servers, it seems like they are getting lo=
st=20
in the connection tracking part. so my question is - is there a problem i=
n=20
combining MASQUERADING & [S,D]NAT rules with iptables?

Regards
Kim
