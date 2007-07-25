From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH IPTABLES 0/13]: Unifies rest of ip[6]tables
	matches/targets
Date: Wed, 25 Jul 2007 15:56:13 +0200
Message-ID: <46A7567D.10202@trash.net>
References: <200707240657.l6O6vfKE018716@toshiba.co.jp>
	<46A6A11B.4060206@trash.net>
	<Pine.LNX.4.64.0707251030350.18990@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707251030350.18990@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> On Jul 25 2007 03:02, Patrick McHardy wrote:
> 
>>Which reminds me how nice it would be to replace SVN by git ...
>>does anyone know how well the git import works? I recall
>>seeing some people reporting problems on the git list.
> 
> 
> Well, I always recommand "add; commit" instead of "import" (at least
> for cvs and svn, but I suppose it applies to every SCM) - because
> importing does not automatically put the files in your WC like add;ci does.
> (And if you don't know how to import - there's add;ci :-))


I'm talking about a repository including history, not single files.
Ideally with SVN "branches" as real branches.
