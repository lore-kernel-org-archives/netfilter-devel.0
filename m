From: Fabrice MARIE <fabrice@netfilter.org>
Subject: Fwd: [PATCH] u32 pom errors
Date: Sat, 2 Aug 2003 17:31:13 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200308021731.13212.fabrice@netfilter.org>
Reply-To: fabrice@netfilter.org
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_hT4K/dcNwNKdGGz"
Cc: Illes Marton <illes@c3.hu>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--Boundary-00=_hT4K/dcNwNKdGGz
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


Hello,

You should post your patches to netfilter-devel if you expect the developers
to look at it. I forward for you this time, but please bookmark the address for later ;-)

Have a nice day,

Fabrice.
--
Fabrice MARIE

"Silly hacker, root is for administrators"
       -Unknown

--Boundary-00=_hT4K/dcNwNKdGGz
Content-Type: message/rfc822;
  name="forwarded message"
Content-Transfer-Encoding: 7bit
Content-Description: Illes Marton <illes@c3.hu>: u32 pom errors

Return-Path: <netfilter-admin@lists.netfilter.org>
Received: from fma ([unix socket]) (authenticated user=fabrice bits=0)
	by fma (Cyrus v2.1.14-Mandrake-RPM-2.1.14-3mdk) with LMTP; Fri, 01 Aug 2003 00:02:04 -0400
X-Sieve: CMU Sieve 2.2
Received: from kashyyyk.netfilter.org (netfilter-sponsored-by.noris.net [62.128.28.62])
	by fma.homelinux.com (Postfix) with ESMTP id D5FE66EB58
	for <fabrice@fma.homelinux.com>; Fri,  1 Aug 2003 00:02:03 -0400 (EDT)
Received: from kashyyyk ([127.0.0.1])
	by kashyyyk.netfilter.org with esmtp (Exim 4.20 #1 (Debian))
	id 19iaxx-0005fU-Lh; Fri, 01 Aug 2003 16:33:09 +0200
Received: from catv-5062609a.bp01catv.broadband.hu ([80.98.96.154] helo=octane)
	by kashyyyk.netfilter.org with esmtp (Exim 4.20 #1 (Debian))
	id 19hvff-0002s0-VA
	for <netfilter@lists.netfilter.org>; Wed, 30 Jul 2003 20:27:32 +0200
Received: from marci by octane with local (Exim 3.35 #1 (Debian))
	id 19hhqO-0000El-00
	for <netfilter@lists.netfilter.org>; Wed, 30 Jul 2003 05:41:40 +0200
From: Illes Marton <illes@c3.hu>
To: netfilter@lists.netfilter.org
Subject: u32 pom errors
Message-ID: <20030730034140.GA867@c3.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
  boundary="OXfL5xGRrasGEqWY"
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -1.6 (-)
Sender: netfilter-admin@lists.netfilter.org
Errors-To: netfilter-admin@lists.netfilter.org
X-BeenThere: netfilter@lists.netfilter.org
X-Mailman-Version: 2.0.11
Precedence: bulk
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Id: General discussion and user questions <netfilter.lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
Date: Wed, 30 Jul 2003 05:41:40 +0200
X-UID: 3144


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Subject: 

Hi,

I tried to post it once, but got lost. :(

In the POM the u32 match misses some files:
u32.patch.config.in
u32.patch.configure.help
u32.patch.makefile

Please find them attached

Marton

-- 

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="u32.patch.config.in"
Subject: 

  dep_tristate '  LENGTH match support' CONFIG_IP_NF_MATCH_LENGTH $CONFIG_IP_NF_IPTABLES
  dep_tristate '  U32 match support' CONFIG_IP_NF_MATCH_U32 $CONFIG_IP_NF_U32

--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="u32.patch.configure.help"
Subject: 

CONFIG_IP_NF_MATCH_LENGTH
U32 patch support
CONFIG_IP_NF_MATCH_U32
  U32 allows you to extract quantities of up to 4 bytes from a packet,
  AND them with specified masks, shift them by specified amounts and
  test whether the results are in any of a set of specified ranges.
  The specification of what to extract is general enough to skip over
  headers with lengths stored in the packet, as in IP or TCP header
  lengths.

  Details and examples are in the kernel module source.


--OXfL5xGRrasGEqWY
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="u32.patch.makefile"
Subject: 

obj-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_length.o

obj-$(CONFIG_IP_NF_MATCH_U32) += ipt_u32.o


--OXfL5xGRrasGEqWY--



--Boundary-00=_hT4K/dcNwNKdGGz--
