From: Ranjeet Shetye <ranjeet.shetye2@zultys.com>
Subject: Re: Reg Connection Tracking
Date: 16 Jan 2003 22:54:45 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1042754086.1677.29.camel@knoppix>
References: <20030117034912.25371.qmail@web41503.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030117034912.25371.qmail@web41503.mail.yahoo.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Things to verify:
1. Do you have local NAT on i.e. NAT for traffic from the machine itself
?
2. Is your ping packet being created in the proper manner ?

Sounds like your request packets and reply packets are being seen by the
netfilter on two different interface. or the ping packet contents that
are used by conntrack are not being created correctly. e.g type, id and
code. If any of those are messed up, your conntrack will start going
beserk cos the replies cannot be matched back to the original traffic. 

Look at the CONFIG_IP_NF_LOCAL_NAT option and your routing tables. Do
you have any static routes or other conditions that can asymmetric
routing ?

Ranjeet.
