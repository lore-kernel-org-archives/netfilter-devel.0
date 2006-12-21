From: "xlz" <xlz@netarchlab.tsinghua.edu.cn>
Subject: A problem of tunnel and netfilter
Date: Thu, 21 Dec 2006 11:40:14 +0800
Message-ID: <200612211140095153132@netarchlab.tsinghua.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1422645AbWLUDkz@vger.kernel.org>
To: "linux-kernel" <linux-kernel@vger.kernel.org>,
	"netfilter-devel" <netfilter-devel@lists.netfilter.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

 Hi,
	I find that the ipip_tunnel_xmit() funtion is called before NF_HOOK(...NF_IP_LOCAL...), but I can't understand the reason. Why isn't the ipip_tunnel_xmit() funtion called after NF_HOOK(...NF_IP_LOCAL...)?

	Thanks in advance for any answers!

xlz
2006-12-21
