From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: ip_conntrack_tuple and marks
Date: Tue, 26 Sep 2006 00:02:05 +0200
Message-ID: <451851DD.7060609@gmx.net>
References: <451448A9.6000407@gmx.net>	<4515F7F8.9030000@netfilter.org>	
	<4516C70A.3050502@gmx.net>	<451700B1.7070103@rtij.nl>	
	<4517E205.8090807@gmx.net> <45182332.8090303@rtij.nl>
	<1159221370.18152.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Martijn Lievaart <m@rtij.nl>, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1159221370.18152.7.camel@localhost.localdomain>
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

Eric Leblond wrote:
> Hi,
> 
> Le lundi 25 septembre 2006 à 20:42 +0200, Martijn Lievaart a écrit :
>> Carl-Daniel Hailfinger wrote:
>>
>>> No, they are not. Let me explain:
>>> The box in question has two pairs of interfaces.
>>> eth0: 10.0.0.254/24   eth1: 10.0.1.254/24
>>> eth2: 10.0.0.254/24   eth3: 10.0.1.254/24
>>> I want to do routing and firewalling between eth0 and eth1. That's
>>> simple. However, I also want to do routing and filtering between
>>> eth2 and eth3. Although eth0 and eth2 have the same subnet, they
>>> are NOT the same network, they just happen to have identical
>>> configurations. Same goes for eth1 and eth3.
> 
> It is more an on iproute problem.
> You could do that by using two dedicated routing tables and by setting
> carefully routing table :
> [...]

Yes, routing has been running here for a while and works perfectly
(with a similar iproute2 setup as you suggested).
Only connection tracking is giving me problems.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
