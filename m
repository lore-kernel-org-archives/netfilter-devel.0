From: Herve Eychenne <rv@wallfire.org>
Subject: iptables-save counters on builtin chains not restored?
Date: Tue, 17 Aug 2004 23:18:21 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040817211821.GE23109@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
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

Seems like I'm studying iptables-save too much tonight...

When fed with the result of iptables-save -c, iptables-restore -c
does not seem to restore counters on chains (I'm not talking about
rules), as I simply cannot find any parsing code for that.

Note that it would make sense only on builtin chains, but not
user-chains, because only builtin chains have a policy, and the
counters are about packets that hit the policy.

Anyway, it doesn't seem to be restored at all, and I suspect an
omission, so... a bug. Can someone confirm?

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
