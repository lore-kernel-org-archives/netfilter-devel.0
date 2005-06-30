From: Pablo Neira <pablo@eurodev.net>
Subject: ctnetlink attributes [was: Re: [PATCH 1/2] updates for
 [nf|ct]netlink and event API]
Date: Thu, 30 Jun 2005 19:06:58 +0200
Message-ID: <42C426B2.6030907@eurodev.net>
References: <42C03F2E.30706@eurodev.net> <42C0806E.3010400@trash.net>
	<20050628071308.GE13239@sunbeam.de.gnumonks.org>
	<42C1747A.3010703@trash.net> <42C2F2DF.7070301@eurodev.net>
	<42C2FC14.80609@trash.net> <42C33E33.7090908@eurodev.net>
	<42C34445.9020709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42C34445.9020709@trash.net>
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

Hi,

Here below a candidate of attributes for ctnetlink. As you could see 
some attributes are still missing, for example, those to modify internal 
helper structures like ip_ct_ftp... but that would be easy to add later.

enum ctattr_type {
	CTA_UNSPEC,
	CTA_TUPLE,
	CTA_STATUS,
	CTA_PROTOINFO,
	CTA_HELP,
	CTA_NAT,
	CTA_TIMEOUT,
	CTA_MARK,
	CTA_COUNTERS,
	CTA_EXPECT,
	__CTA_MAX
};

enum ctattr_tuple {
	CTA_TUPLE_DIR,
	CTA_TUPLE_IP,
	CTA_TUPLE_PROTO,
	__CTA_TUPLE_MAX
};

enum ctattr_ip {
	CTA_IP_V4_SRC,
	CTA_IP_V4_DST,
	CTA_IP_V6_SRC,
	CTA_IP_V6_DST,
	__CTA_IP_MAX
};

enum ctattr_l4proto {
	CTA_PROTO_NUM,
	CTA_PROTO_TCP_SRC,
	CTA_PROTO_TCP_DST,
	CTA_PROTO_UDP_SRC,
	CTA_PROTO_UDP_DST,
	CTA_PROTO_ICMP_TYPE,
	CTA_PROTO_ICMP_CODE,
	CTA_PROTO_SCTP_CODE,
	__CTA_PROTO_MAX
};

enum ctattr_protoinfo {
	CTA_PROTOINFO_TCP,
	__CTA_PROTOINFO_MAX
};

enum ctattr_protoinfo_tcp {
	CTA_TCP_STATE,
	__CTA_TCP_MAX
};

enum ctattr_counters {
	CTA_COUNTERS_PACKETS,
	CTA_COUNTERS_BYTES,
	__CTA_COUNTERS_MAX
};

enum ctattr_nat {
	CTA_NAT_MINIP,
	CTA_NAT_MAXIP,
	CTA_NAT_PROTO,
	__CTA_NAT_MAX
};

enum ctattr_protonat {
	CTA_PROTONAT_MINIP,
	CTA_PROTONAT_MAXIP,
	CTA_PROTONAT_TCP,
	CTA_PROTONAT_UDP,
	__CTA_PROTONAT_MAX
};

enum ctattr_expect {
	CTA_EXPECT_TUPLE,
	CTA_EXPECT_MASK,
	CTA_EXPECT_TIMEOUT,
	__CTA_EXPECT_MAX
};

enum ctattr_help {
	CTA_HELP_NAME,
	__CTA_HELP_MAX
};

Comments welcome.

--
Pablo
