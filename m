From: Raghuveer Reddy <raghurecw@gmail.com>
Subject: is netfilter hook and iptables rule are same
Date: Wed, 31 Aug 2005 12:47:40 +0530
Message-ID: <d1b64d7d05083100171fa3ea5b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

hi=20

is netfilter hook and the rules added by netfilter are same or not?

if they are equivalant what will be order of execution is iptable rule
(let say NAT table rule in     PRE_ROUTING) or the netfilter hooks (in
PRE_ROUTING) ?

lets say iptables rule is excecuted first and which says drop the
packet and hook function which says allow (if excuted second) what
happen to the packet?

if we add the hook using the insmod (LKM) , will netfilter framework
check for confilts?

Anybody please clarify this.

Thanks in advance

Raghuveer
