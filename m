From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Clearcase conntrack module
Date: Tue, 24 Aug 2004 10:22:48 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408241019060.4945@filer.marasystems.com>
References: <1430199393@web.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Lars Lockenvitz <L.Locke@web.de>
In-Reply-To: <1430199393@web.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 24 Aug 2004, Lars Lockenvitz wrote:

> I=B4ve written an extension for the clearcase protocol. It based on the=
 ip_conntrack_rpc modules.
> Now I will contribute it, but I don=B4t know how I make this as a patch.

See patch-o-matic-ng/README.newpatches

Then make a diff -ruN compared to patch-o-matic-ng without your additions=
=20
and send the diff here to the mailinglist.

Regards
Henrik
