From: "Robert Iakobashvili" <roberti@GoNetworks.com>
Subject: Matching 10000's of IP ranges (solution) (Brian Gunlogson)
Date: Thu, 6 Jan 2005 08:37:51 +0200
Message-ID: <699F7BBB368A10479166148511F524177A023F@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: jsullivan@opensourcedevelopmentcorp.com
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

You may wish to consider ipset-2, a really good netfilter extention:
http://people.netfilter.org/kadlec/ipset/

Sincerely,
Robert Iakobashvili
roberti@gonetworks.com

>Your solutions were way too slow. So I wrote a module that does a
binary search to find ip ranges in a sorted list. Would netfilter be
interested in the source code? I don't have the desire to put it into
patch-o-matic format, but that shouldn't be hard to do. Also, It was
built to read the ranges from a file, but I don't know how to pass a
dynamic ammount of memory from iptables to the kernel module so they
must be hardcoded into the module.
>Brian G.
--- "John A. Sullivan III" <jsullivan@opensourcedevelopmentcorp.com>
wrote:

> > What is a reasonable way to match around 80000 IP ranges with
iptables?
> The iprange patch will enable you to define ranges in iptables.  If=20
> you do not want to patch, you can use SubnetCreator=20
> (http://subnetcreator.sourceforge.net).
