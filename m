From: "Paul Albert" <palbert@rovingplanet.com>
Subject: Ctnetlink?
Date: Wed, 29 Oct 2003 18:10:15 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <661F9268BBA8CB4EB92CC12B8C42F06901F6AE@pluto.rovingplanet.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all -=20

I'm quite interested in removing some or all of the connection tracking
entries at various times while iptables is in operation.  My searching
around the archives had led me to a mysterious piece of code, ctnetlink.
I can see it listed in the POM, however, the patch link isn't valid.

My questions: =20

Will this provide me a command-line interface to remove connections from
ip_conntrack?
Is there more documentation on this?

>From looking through the code, it appears that I could call
ip_conntrack_cleanup in ip_conntrack_core.c to remove all of the
entries.  Would this work or is there a better way?

Thanks much,
Paul
