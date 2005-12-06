From: "Pieter De Wit" <pieter@vodacom.co.za>
Subject: Proper detection of FTP-DATA
Date: Tue, 6 Dec 2005 16:48:33 +0200
Message-ID: <C3FA62B1A90D7440B9B6C7C31895994F016C6D7A@zadbn02100.vodacom.corp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello Guys,
=20
How would you properly match FTP-DATA connections? I have tried the
following and after checking the man pages, this should work ?!?
=20
iptables -A INPUT -p tcp -m tcp --dport=3D21 # For FTP-CTRL
iptables -A INPUT -m state --state ESTABLISHED -j ACCEPT
iptables -A INPUT -m state --state RELATED -j ACCEPT

Let's just say outbound is ACCEPT *
=20
For passive FTP that should work, since the firewall (which is on the
FTP Server) can match that ? Or can it ?
=20
Thanks,
=20
Pieter
=93This e-mail is sent on the Terms and Conditions that can be accessed b=
y Clicking on this link http://www.vodacom.net/legal/email.aspx "
