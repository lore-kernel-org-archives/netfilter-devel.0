From: "Yong Li" <sdssly@sina.com>
Subject: bridge+netfilter+libipq questions
Date: Tue, 8 Jul 2003 22:35:14 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <000901c3455e$28825ba0$8725e9db@win2ken>
References: <20030707222621.16976.2349.Mailman@kashyyyk>
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

I have set up a bridge+Iptables on Linux. I use this rule:

iptables -A FORWARD ... -j QUEUE

I found the packet IN/OUT device are the same: our bridge port br0. I want
to recognize the IN and OUT packet in the userspace application using the
IN/OUT device in libipq, how to set the iptables rule?

Thank you!
