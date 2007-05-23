From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnfnetlink_conntrack performance
Date: Wed, 23 May 2007 15:04:01 +0200
Message-ID: <46543BC1.8090106@netfilter.org>
References: <7194302c0705221402k14bfe9eco7ecc98910eaa1c87@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Morten Isaksen <misak@misak.dk>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <7194302c0705221402k14bfe9eco7ecc98910eaa1c87@mail.gmail.com>
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

Morten Isaksen wrote:
> Do anyone have som experience with the performance of libnfnetlink_conntrack?
> 
> I am using it to track and log NFCT_T_NEW and NFCT_T_DESTROY events. I
> am testing it on a firewall with about 15 Mbit/s traffic and 18-22K
> entries in ip_conntrack. The only difference I can spot so far is 300
> more context switches pr. sec than usual.

Using conntrack_events example available under utils/ with a little hack 
(removed the counter).

$ ./bench 192.168.1.2 10000 # generate 10000 HTTP GET requests
time taken: 19.613752000 seconds
request per seconds: 509.846344

Cyclesoak says:
System load: 10.1%
System load:  1.6%
System load:  3.4%
System load:  6.8%
System load: 13.7%
System load: 23.2%
System load:  4.2%
System load:  1.7%
System load:  3.5%
System load:  6.8%
System load: 13.6%
System load: 20.8%
System load:  6.8%
System load:  1.7%
System load:  3.4%
System load:  7.0%
System load: 14.1%
System load: 22.5%
System load:  5.4%
System load:  1.7%
System load:  2.1%

processor       : 1
vendor_id       : AuthenticAMD
cpu family      : 15
model           : 33
model name      : Dual Core AMD Opteron(tm) Processor 275
stepping        : 2
cpu MHz         : 2210.189
cache size      : 1024 KB

One optimization that we can apply here is that libnetfilter_conntrack 
listen to update events even if you don't want to do it. These 
introduces an extra cost, of course. I have a patch somewhere to improve 
this, even I plan to introduce more fine grain events groups like 
protocol/state specific, eg. only listen to TCP syn_sent events.

> The events are collected in batches of 7 and then sent in an UDP
> packet to a log server.

Did you ever have a look at conntrackd? It is available in the 
conntrack-tools package that I'll release today. It has a statistics 
mode that still needs some work, this option that you have implemented 
could be quite interesting for it.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
