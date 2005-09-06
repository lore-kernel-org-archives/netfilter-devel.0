From: Oscar Mateo <omateo@gmail.com>
Subject: unable to apply PPTP patches
Date: Tue, 6 Sep 2005 18:02:04 +0200
Message-ID: <a8a372c050906090246fa43b1@mail.gmail.com>
References: <365871C49598504A9481DDBEC3EB495512322D@MAIL.InfraSupportEtc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <365871C49598504A9481DDBEC3EB495512322D@MAIL.InfraSupportEtc.com>
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

Hi all,

As suggested somewhere in the netfilter list, I'm moving this
"question/help request" from the netfilter to the netfilter-developer
list:

I have been trying to apply the pptp patches (pom-ng-20050905,
iptables-1.3.3) to the kernel source (kernels 2.6.9.x, 2.6.11.x and
2.6.12.x) and I have found the same error that populates the August
2005 netfilter Archives:

- If I only apply the pptp/gre patches I get
`__ip_conntrack_expect_find' undefined (when compiling either in the
kernel or as a module).
- If I try to apply nfnetlink and ctnetlink patches, ctnetlink is
rejected (6 rejects out of 48 hunks).
- If I force the ctnetlink patch, I get `__ip_conntrack_hash_insert'
undeclared.

Did someone get the patch working with kernels >=3D 2.6?
Does anyone have any ideas how to deal with this problem?

Thanks in advance for your help ^_^
Oscar
