From: Illes Marton <illes.marton@balabit.hu>
Subject: PATCH: u32 match patch errors
Date: Mon, 28 Jul 2003 00:08:14 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030727220814.GA928@c3.hu>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Resent-Message-Id: <E19hMqa-0000X6-00@octane>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline

Hi,

In the POM the u32 match misses some files:
u32.patch.config.in
u32.patch.configure.help
u32.patch.makefile

Please find them attached

Marton
-- 

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="u32.patch.config.in"

  dep_tristate '  LENGTH match support' CONFIG_IP_NF_MATCH_LENGTH $CONFIG_IP_NF_IPTABLES
  dep_tristate '  U32 match support' CONFIG_IP_NF_MATCH_U32 $CONFIG_IP_NF_U32

--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="u32.patch.configure.help"

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


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="u32.patch.makefile"

obj-$(CONFIG_IP_NF_MATCH_LENGTH) += ipt_length.o

obj-$(CONFIG_IP_NF_MATCH_U32) += ipt_u32.o


--ibTvN161/egqYuK8--
