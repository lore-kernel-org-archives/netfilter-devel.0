From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [RFC] [PATCH] ctnetlink updates
Date: Mon, 02 May 2005 01:49:38 +0200
Message-ID: <42756B12.4090705@eurodev.net>
References: <424747E3.7000300@eurodev.net> <42502F8D.5030504@trash.net>
	<4254258E.5000204@eurodev.net> <42627BC4.8070103@trash.net>
	<Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0504290904450.8609@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> Looking at the last changes, I think it'd be much more better to port
> ip_queue to nfnetlink than to reserve another netlink ID: the hooks in
> nfnetlink are already there. I know that'd create backward compatibility
> issues at the existing queue applications, though... :-(

I was playing around with an experimental port of ip_queue to 
nf_queue/nfnetlink during xmas holidays, it is crap. So I probably start 
it from scratch.

In this specific case where we can break third party applications, to 
ensure backward compatibility, I think that we can keep both ip_queue 
and nf_queue in kernel tree for quite some time.

--
Pablo
