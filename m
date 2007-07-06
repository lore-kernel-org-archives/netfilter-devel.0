From: Christian Gorecki <christian.gorecki@post.rwth-aachen.de>
Subject: Re: ipq_get_packet receives proper TCP and IP headers but the rest
	of payload is junk
Date: Fri, 06 Jul 2007 15:00:48 +0200
Message-ID: <468E3D00.9070604@post.rwth-aachen.de>
References: <9010780e0707060538r3c754988ibebe5fa7d0c11ff2@mail.gmail.com>
	<9010780e0707060539y7623fbfgf2bd899a8b2f8162@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@lists.netfilter.org
To: Nick Landry <nick.landry@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <9010780e0707060539y7623fbfgf2bd899a8b2f8162@mail.gmail.com>
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

Recently I have had some similar observations. For me the solution was
to disable the Accept-Encoding header field the browser had set.

So I guess on your first configuration the browser did not accept
encoding and in the second scenario the browser does.

Cheers,
Christian

Nick Landry schrieb:
> I have a simple program that just reads packets off of ip_queue and
> dumps them.  I setup my rules as follows:
> 
> Chain FORWARD (policy ACCEPT)
> target     prot opt source               destination
> QUEUE      tcp  --  anywhere             anywhere
> QUEUE      udp  --  anywhere             anywhere
> 
> Everything runs fine on my 32-bit RHEL4 box and on another 64-bit
> RHEL4 box.  However, when running on (yet another) 64-bit RHEL4 box I
> notice that that TCP and IP header part of the payload is the same,
> but the rest of the payload looks like junk (mostly null, even though
> this is HTTP GET messages).
> 
> I realize I'm using an older version of iptables:
> iptables-1.2.11-3.1.RHEL4
> iptables-devel-1.2.11-3.1.RHEL4
> 
> But I don't see any mention of this problem for any version of iptables.
> 
> Any help would be greatly appreciated.
> 
> Nick
> 
