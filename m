From: Eicke Friedrich <tady@gmx.net>
Subject: input/output interface on a bridging firewall
Date: Mon, 08 Mar 2004 17:43:09 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <404CA29D.80808@gmx.net>
References: <404C7DBB.3000508@aiqa.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <404C7DBB.3000508@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I've been using a bridging firewall running 2.4.x kernel series. A 
couple of days ago I started to migrate to kernel 2.6.3. Since you can 
enable netfilter for a bridge directly in kernelconfig there is no 
need to get the ebtables patches anymore. Some POM-ng patches were 
applied (CONNMARK) and kernel compilation went well.

One thing does _not_ work anymore: I can't match the incoming (-i 
ethX) or outgoing (-o ethX) interface anymore if the interface is a 
port of a bridge interface (brX). I've to match the outgoing interface 
for -j CLASSIFY to sort packets in htb classes. Using kernel 2.4.x 
this was possible. Any hints or comments for me?

Thanks in advance,
Eicke.
