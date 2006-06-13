From: =?ISO-8859-1?Q?Bj=F6rn_Lindstr=F6m?= <bjorn.mailinglist@gmail.com>
Subject: writing iptables match
Date: Tue, 13 Jun 2006 09:19:07 +0200
Message-ID: <448E66EB.2050706@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Im trying to create a new iptables match. I have writen and compiled the=20
kernel module and iptables library. Is it possible to use the new match=20
by inserting the module with insmod and copying the library file to=20
/lib/iptables/ ?
If I do this I get Segmantation fault when trying to use the match with=20
iptables -m.

Bj=F6rn
