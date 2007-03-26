From: "Jay Manni" <JManni@FireEye.com>
Subject: unregister_netdevice with negative refcnt error while using NFQUEUE
	with ebtables mark
Date: Sun, 25 Mar 2007 22:25:38 -0700
Message-ID: <74ECB30468A30A4DA2BD88DA5387CAE3508835@fempexch.FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
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

I am using iptables to queue packets to an NFQUEUE from a tap interface =
(attached to a VM). It works fine, except that I get an =
unregister_netdevice error with a negative refcnt, while freeing the tap =
devices.

=A0unregister_netdevice: waiting for tap3 to become free. Usage count =
=3D -50

I noticed some posts about the negative refcnt issue but that was =
related to appletalk.
Anybody know whats happening here?

-jay

--=20
Internal Virus Database is out-of-date.
Checked by AVG Free Edition.
Version: 7.5.432 / Virus Database: 268.16.7/619 - Release Date: 1/7/2007 =
6:29 PM
=20
