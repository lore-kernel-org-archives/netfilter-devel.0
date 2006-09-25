From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: ip_conntrack_tuple and marks
Date: Tue, 26 Sep 2006 00:23:56 +0200
Message-ID: <451856FC.9050408@gmx.net>
References: <451448A9.6000407@gmx.net>	<4515F7F8.9030000@netfilter.org>	<4516C70A.3050502@gmx.net>	<451700B1.7070103@rtij.nl>	<4517E205.8090807@gmx.net>
	<45182332.8090303@rtij.nl>	<1159221370.18152.7.camel@localhost.localdomain>
	<1159222083.18152.12.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Martijn Lievaart <m@rtij.nl>, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1159222083.18152.12.camel@localhost.localdomain>
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
> 
> In the setup you describe and in almost all cases. The differences is in
> the interfaces.
>  
> Could it be a a way to differentiate the connection tracking entries ?

I first hoped so. Then I thought about expectation setup and how messy
it would get to guess the incoming interface for a packet in the opposite
direction. And it would also break some cases of load balancing where
packets may leave and/or enter through multiple interfaces. That's where
I gave up on the idea to base this on incoming interface.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
