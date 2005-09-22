From: "Greg Scott" <GregScott@InfraSupportEtc.com>
Subject: FW: ip_conntrack_pptp: error during exp_gre - what does this mean
	and how do I fix it?
Date: Thu, 22 Sep 2005 13:47:19 -0500
Message-ID: <365871C49598504A9481DDBEC3EB49551232E3@MAIL.InfraSupportEtc.com>
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

Does anyone know what this error means?

Sep 12 00:50:16 xxxxx-fw kernel: ip_conntrack_pptp: error during exp_gre

These ocassionally show up in /var/log/messages on one of my firewalls.

I am using kernel 2.4.27 from kernel.org, iptables 1.2.11, and
patch-o-matic-20040621.

I would love to use the latest and greatest PPTP patch with a new 2.6
kernel, and I will as soon as I can get one to to compile.  Meanwhile, I
have to stick with this older version until I can get the newer stuff to
work. =20

Thanks

- Greg Scott
