From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM [2.4.x]
Date: Wed, 22 Jun 2005 11:10:34 +0200
Message-ID: <42B92B0A.2000802@tac.ch>
References: <42A57FC4.7010508@tac.ch>
	<42A5B144.3090005@tac.ch>	<42A625DA.7090807@eurodev.net>
	<42A6AB19.2040106@tac.ch>	<42A6E685.3060408@eurodev.net>	<42AEF774.8060300@tac.ch>
	<42B67BEC.1090105@tac.ch>	<20050621003441.GI8335@postel.suug.ch>	<42B76474.8080209@eurodev.net>
	<20050621111328.GK8335@postel.suug.ch>	<42B81D75.8090205@trash.net>
	<42B82177.5010101@tac.ch>	<42B8288C.9030004@trash.net>
	<42B82F29.40307@tac.ch>
	<Pine.LNX.4.58.0506220859360.5627@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Pablo Neira <pablo@eurodev.net>, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0506220859360.5627@blackhole.kfki.hu>
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

Hello Jozsef,

I'm not running a 2.6.x kernel for the reasons explained below:

> Are you running a recent kernel from the 2.6 tree? A lot of improvements
> had been submitted in in spring and since then I have practically not
> received any reports on window tracking problems.

I know, however it's completely impossible for us to run 2.6.x kernels, too many
subtle changes are happening between new releases (ACPI routing, interrupt
mitigation in e1000, NAPI, and other subsystems besides networking) and some
features, like for example ipsec have changed fundamentally in the way they work
with regard to filtering or packet traversal. We unfortunately don't have enough
people to track and verify those changes regarding QA.

<off-topic>
A differnet point of view: I don't have the time nor do I get the money to
change our firewall software to be compatible with 2.6.x kernels. Also some
people's quest in trying to optimize latency (see RT threads on LKML) and tuning
mm/* for smoother desktop performance has a negative tendancy on network server
performance.
</off-topic>

Where would I best start to find out about differences between the 2.4.x and
2.6.x version of the tcp window tracking code? Do you remember when you stopped
backporting fixes?

Thanks for your interest,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
