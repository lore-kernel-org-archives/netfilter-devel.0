From: "Marcelo Barbosa Lima" <mlima@cpqd.com.br>
Subject: ICMP NDISC: fake message with non-255 Hop Limit received: 254 - error message
Date: Thu, 3 Apr 2003 16:58:46 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <D49EA2F934FFAD45B337C07A9753C00E01B3C25B@MAILSRV1.aquarius.cpqd.com.br>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Cc: <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

	We were doing tests with Ip6tables and we noticed a curious event after =
that rules are created and loaded. After some few minutes,  the messages =
"ICMP NDISC: fake message with non-255 Hop Limit received: 254" are =
shown in display. If I do "ip6tables -F" after some few seconds this =
messages are not printed in the screen again. Is there any bug regarding =
to Neighbor Discovery Protocol and Ip6tables?=20
Thanks and Regards,

		Marcelo.
