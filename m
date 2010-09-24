From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 5/6] conntrack: export lsm context rather than internal
 secid via netlink
Date: Fri, 24 Sep 2010 23:08:00 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009242307310.3599@obet.zrqbmnf.qr>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com> <20100924204545.28355.92767.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
	netfilter-devel@vger.kernel.org, jmorris@namei.org,
	sds@tycho.nsa.gov, paul.moore@hp.com, casey@schaufler-ca.com,
	linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
	mr.dash.four@googlemail.com
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100924204545.28355.92767.stgit@paris.rdu.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Friday 2010-09-24 22:45, Eric Paris wrote:
>+#ifdef CONFIG_NF_CONNTRACK_SECMARK
>+static int ctnetlink_nlmsg_secctx_size(const struct nf_conn *ct)
>+{
>+	int len;
>+
>+	security_secid_to_secctx(ct->secmark, NULL, &len);
>+
>+	return sizeof(char) * len;
>+}
>+#endif

sizeof(char) is defined to be 1, so it's a little redundant.
