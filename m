From: "Pieter De Wit" <pieter@vodacom.co.za>
Subject: Problem compiling iptables with gcc 3.3.1
Date: Mon, 15 Sep 2003 08:06:54 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <93C53436ECB2B94BAE3A4958AE886F0209198B@zadbn02001.vodacom.corp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
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

Hello Guys,

I am currently running Gentoo 1.4rc4 with the "test portage". Basically
when I enable iptables in the kernel (2.4.20 - with a bunch of patches)
I get a compile error in ip_nat_core at line 854. If I take this line
and put it all on one line it works fine. Is this something that you
guys would maintain?

Thanks,

Pieter De Wit
=93This e-mail is sent on the Terms and Conditions that can be accessed b=
y Clicking on this link http://www.vodacom.net/legal/email.asp "
