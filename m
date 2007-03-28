From: "Jay Manni" <JManni@FireEye.com>
Subject: RE: unregister_netdevice with negative refcnt error while using
	NFQUEUE with ebtables mark
Date: Wed, 28 Mar 2007 01:42:26 -0700
Message-ID: <74ECB30468A30A4DA2BD88DA5387CAE3508A49@fempexch.FireEye.com>
References: <74ECB30468A30A4DA2BD88DA5387CAE3508835@fempexch.FireEye.com>
	<46093551.2060906@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-class: urn:content-classes:message
In-Reply-To: <46093551.2060906@trash.net>
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

Kernel version - 2.6.15.4
I am using the nfnetlink_queue and haven't been able to reproduce =
without queueing.

-jay

-----Original Message-----
From: Patrick McHardy [mailto:kaber@trash.net]=20
Sent: Tuesday, March 27, 2007 8:17 AM
To: Jay Manni
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: unregister_netdevice with negative refcnt error while using =
NFQUEUE with ebtables mark

Jay Manni wrote:
> I am using iptables to queue packets to an NFQUEUE from a tap =
interface (attached to a VM). It works fine, except that I get an =
unregister_netdevice error with a negative refcnt, while freeing the tap =
devices.
>=20
>  unregister_netdevice: waiting for tap3 to become free. Usage count =
=3D -50
>=20
> I noticed some posts about the negative refcnt issue but that was =
related to appletalk.
> Anybody know whats happening here?


Something very broken obviously, the reference count should never
drop below zero. What kernel version are you running, and what
are you using as queuing backend (ip_queue, nfnetlink_queue)?
Can you also reproduce the problem without queueing?

--=20
Internal Virus Database is out-of-date.
Checked by AVG Free Edition.
Version: 7.5.432 / Virus Database: 268.16.7/619 - Release Date: 1/7/2007 =
6:29 PM
=20

--=20
Internal Virus Database is out-of-date.
Checked by AVG Free Edition.
Version: 7.5.432 / Virus Database: 268.16.7/619 - Release Date: 1/7/2007 =
6:29 PM
=20
