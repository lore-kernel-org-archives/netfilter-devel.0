From: "Yong Li" <sdssly@sina.com>
Subject: ipq_set_verdict problem in bridge+iptables
Date: Sun, 13 Jul 2003 11:11:16 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <001901c348ec$6dbbc5d0$e84ce9db@win2ken>
References: <20030712222620.28732.48265.Mailman@kashyyyk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
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

Hello All,

I encountered a problem with the ipq_set_verdict function. I want to modify
the packet content and size using the ipq_set_verdict function. However, I
found I cannot change the IP packet size more than 400+ bytes. Is it a known
issue?

Thanks in advance!

Yong
