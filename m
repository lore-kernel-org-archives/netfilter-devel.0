From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: script for stopping sshd attacks
Date: Thu, 16 Jun 2005 15:51:22 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0506161549420.27104@yvahk01.tjqt.qr>
References: <200506152338.j5FNcHZ04996@isis.cs3-inc.com>
	<17073.28398.666579.141388@isis.cs3-inc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Don Cohen <don-nfil1@isis.cs3-inc.com>
In-Reply-To: <17073.28398.666579.141388@isis.cs3-inc.com>
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


>I've noticed that the ssh attacks in particular tend to stop 
>after about 30 packets if you drop, whereas they sometimes go
>on for thousands if you mirror.  While this may be viewed as

How about using an expiring TARPIT? -j TARPIT -m expire
Better yet would be (that's what I am using) a general limiter:
 -m limit --limit-rate 2/minute -p tcp --dport 22 -j ACCEPT
 -j TARPIT

>bad for the machine running the script (wasting its bandwidth)

It's also bad for you, if you have a bandwidth quota.



Jan Engelhardt                                                               
--                                                                            
| Gesellschaft fuer Wissenschaftliche Datenverarbeitung Goettingen,
| Am Fassberg, 37077 Goettingen, www.gwdg.de
