From: xubh0660 <xubh0660@sina.com>
Subject: Time match problem
Date: Thu, 19 Jun 2003 18:01:34 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030619100134.5419.qmail@sina.com>
Mime-Version: 1.0
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

Hi,
When I am using the time match ,I have the following command:

 iptables -A FORWARD -m time --timestart 08:00 --timestop 18:00 \
  --days Mon -j ACCEPT

This works well,but when i delete the rule,I have the following command:

 iptables -D FORWARD -m time --timestart 08:00 --timestop 18:00 \
  --days Mon -j ACCEPT

It does not work,and display:

 iptables: Bad rule (Does a matching rule exist in that chain?)

I change the FORWARD chain to INPUT chain or OUTPUT chain,it could work.
Does anyone help me? I'm RH 8.0 + iptables 1.2.8

best regards
  BenH



===================================================================
