From: Nick Pasich <NewsLetters@NickAndBarb.net>
Subject: Problems With Geoip and linux-2.6.16 .....
Date: Sat, 25 Mar 2006 05:22:28 -0800
Message-ID: <20060325132228.GA23471@69.17.112.251>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="YiEDa0DAkWCtVeE4"
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


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline


Email doesn't get through to either Samuel Jean or Nickolas Boulain, at
<nib@cookinglinux.org> or <sjean@cookinglinux.org> ..... so I thought
I would try posting here......



Samuel and Nicolas,


I just got Linux Kernel 2.6.16 and am trying to add geoip.

I'm using the latest patch-o-matic-ng-20060322.

I get the following error:


unable to find ladd slot in src \
/tmp/pom-10459/net/ipv4/netfilter/Makefile \
(./patchlets/geoip/linux-2.6/./net/ipv4/netfilter/Makefile.ladd)


Makefile.ladd shows:

obj-$(CONFIG_IP_NF_MATCH_LIMIT) += ipt_limit.o
obj-$(CONFIG_IP_NF_MATCH_GEOIP) += ipt_geoip.o


There is no ipt_limit.c in /usr/src/linux-2.6.16/net/ipv4/netfilter/
There was one on the linux-2.6.15 but not in linux-2.6.16

There is a xt_limit.c in /usr/src/linux-2.6.16/net/netfilter.
In xt_limit.c there is a MODULE_ALIAS("ipt_limit").

I use geoip continuously and can't use the new kernel without it.



       Thanks for a great module...


               ---( Nick Pasich )---

            NewsLetters@NickAndBarb.net



--YiEDa0DAkWCtVeE4--
