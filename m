From: =?ISO-8859-1?Q?S=EDlvia?= Andreia Oliveira Rocha <srocha@ncc.up.pt>
Subject: Netfilter Question - NF_QUEUE
Date: Fri, 09 Jul 2004 18:44:40 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1089395079.2776.73.camel@khocegas>
Reply-To: srocha@ncc.up.pt
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
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

Hi,

My name is S=EDlvia and I'm beginning to study the NetFilter Architecture=
.

I've got a very simple question, I'd like to know more about the
NF_QUEUE hook.

It is said that this hook is usually used to pass information to
UserSpace, my question is, if somewhere a package is "popped" from the
skb and a NF_QUEUE isn't invoked afterwords is the package lost? I guess
it isn't, because a package is only drops on a NF_DROP verdict, but I'm
getting rather confused studying an application that uses NetFilter.

Thank U a lot for your attention,
S=EDlvia
