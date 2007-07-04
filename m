From: "Fabrice Triboix" <Fabrice.Triboix@imgtec.com>
Subject: How to remove TCP options when doing NAT?
Date: Wed, 4 Jul 2007 13:59:41 +0100
Message-ID: <917D8AC5A524D343B28848D8BBFFEC0701C07F1F@klmail1.kl.imgtec.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
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

Hi,=0D=0A=0D=0AI have noticed that to handle masquerading, linux adds some =
TCP options=0D=0Ato the output packets (for a TCP stream, of course).=0D=0A=0D=
=0AI would like to know if there is a way to avoid that=3F Or more=0D=0Aacc=
urately: is it possible to tell the linux kernel to do the=0D=0Amasqueradin=
g without adding these TCP options=3F=0D=0A=0D=0AI am using Linux 2.6.18 (c=
ustom build from original sources) on an Intel=0D=0Aarchitecture.=0D=0A=0D=0A=
I have tried to ask this question on netfilter@lists.netfilter.org, but=0D=0A=
nobody was able to answer me...=0D=0A=0D=0AThank you very much for any help=
,=0D=0A=0D=0A  Fabrice Triboix=0D=0A-=0D=0AThis message is subject to Imagi=
nation Technologies' e-mail terms: http://www.imgtec.com/e-mail.htm=0D=0A-=0D=
=0A
