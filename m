From: Roberto Nibali <ratz@drugphish.ch>
Subject: Re: when IPVS into netfilter?
Date: Sat, 10 May 2003 13:29:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EBCE288.5020801@drugphish.ch>
References: <3EB44BE7.3070602@wanadoo.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Xose Vazquez Perez <xose@wanadoo.es>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I hope the netfilter people do not mind if I answer this on behalf of 
the LVS project.

> Are there some possibility to IPVS Netfilter
> ( http://www.linuxvirtualserver.org )
> module for it can go into iptable 2.4.xx code?

I think not for 2.4.x because we're changing too much of the 
netfilter/routing code to make it a smooth and acceptable merge. There 
is also some code most people use which is completely not acceptable 
within the scope of routing extensions (like the hidden patch or some 
DGD code).

For 2.5 it is already too late, feature freeze was already called in and 
we haven't talked to the netfilter people anyways ;).

I'm going to talk to Harald about it this coming OLS (once again), 
provided he's got enough time. It's on my BoF list actually; for more 
information please check out the .plan:

http://marc.theaimsgroup.com/?l=linux-virtual-server&m=104756133813089&w=2

Another point is that we (Wensong the most) never felt the urge to 
submit the code to the networking maintainers for approval and 
inclusion. At OLS 2000, Wensong, Horms, Rusty, me and some others talked 
about a possible inclusion of LVS into netfilter. It simply never 
happened because noone felt about doing more than talking of it.

Yet another point is that we never really agreed on having someone being 
the lead developer and responsible for a possible kernel inclusion and 
most of us simply do not have the time to be a maintainer. It's a tough 
and time consuming job even if the code works for 99.999% of the people.

You have to talk to other involved parties, you have to monitor API 
changes and you will need to be responsive to an increasing amount of 
emails addressed directly to you (for example package responsibles for a 
distribution), because you're in the MAINTAINERS list.

Last but not least it is pretty easy to patch your kernel with LVS, 
There are as few as possible changes to the existing code, most of the 
patch is in form of additional code.

 > --
 > Galiza nin perdoa nin esquence. Governo demision!

:) Fair enough.

Best regards,
Roberto Nibali, ratz
-- 
echo '[q]sa[ln0=aln256%Pln256/snlbx]sb3135071790101768542287578439snlbxq'|dc
