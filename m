From: "Jay Manni" <JManni@FireEye.com>
Subject: libnetfilter_queue man page
Date: Thu, 1 Mar 2007 13:00:47 -0800
Message-ID: <74ECB30468A30A4DA2BD88DA5387CAE348E8C4@fempexch.FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: quoted-printable
Cc: dhersin@gmail.com
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

Are you referring to the documentation posted by brad abt a year ago? Is =
there an updated version of that documentation?

- j

-------------------------------------------------------------------------=

>From dhersin at gmail.com

Hi,

First, thanks for the documentation. It was helpful for me to understand =
the
code.

But, I still have a question : I would like to add an extension in =
filtered IPv6
multicast packets headers. Do you think, I can do this in the userspace
using libnetfilter queue ? And, how precisely does it work ? Is it =
something
like this :

1. Activate the hook NF_IP6_LOCAL_OUT with an iptables rule
2. Launch my software with libnetfilter_queue
3. Modify the header
4. Return the whole packet to netfilter

Do I have tocreate a specific kernel module ?

Thanks for your responses.

Regards,
Julien



--=20
Internal Virus Database is out-of-date.
Checked by AVG Free Edition.
Version: 7.5.432 / Virus Database: 268.16.7/619 - Release Date: 1/7/2007 =
6:29 PM
=20
