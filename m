From: Patrick McHardy <kaber@trash.net>
Subject: Re: Multiport Module
Date: Fri, 29 Sep 2006 15:39:33 +0200
Message-ID: <451D2215.2000006@trash.net>
References: <c9961d450609280730l2176c0b5pdbf1c0c3efdf52f5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter <netfilter-devel@lists.netfilter.org>,
	netfilter@lists.netfilter.org
Return-path: <netfilter-bounces@lists.netfilter.org>
To: Rajesh Mahajan <rajeshmahajan09@gmail.com>
In-Reply-To: <c9961d450609280730l2176c0b5pdbf1c0c3efdf52f5@mail.gmail.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Rajesh Mahajan wrote:
> How can i use both source and destination ports in multiport module of
> iptable 1.5
> 
> I m geting error when i apply a explample rule
> 
> iptables -D post-ids  -d 192.168.10.1 -p tcp -m multiport --sport
> 10002:10005 -m multiport--dport 50:80 -j QUEUE;
> *** glibc detected *** double free or corruption (!prev): 0x08056148 ***
> Aborted

This is fixed in iptables 1.3.6.
