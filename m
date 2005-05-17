From: Patrick McHardy <kaber@trash.net>
Subject: Re: quake3 pom module minor warning
Date: Tue, 17 May 2005 17:08:07 +0200
Message-ID: <428A08D7.8040209@trash.net>
References: <20050511115152.GA1942@helminth.linuxhacker.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Anatoly Pugachev <mator@rootshell.ru>
In-Reply-To: <20050511115152.GA1942@helminth.linuxhacker.ru>
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

Anatoly Pugachev wrote:
> Hello.
> 
> If you're selected to use "quake3 connection tracking and NAT helper" POM
> "extra repository" module with recent 2.6.x kernel, then in stage of compiling
> 2.6.x kernel, you'll get following warning (i'm tryed with kernel version
> 2.6.11.8) :
> 
>   CC      net/ipv4/syncookies.o
> scripts/Makefile.build:48: kbuild: net/ipv4/netfilter/Makefile - Usage of
> export-objs is obsolete in 2.6. Please fix!
> 
> last time i was tryed to compile it with patch-o-matic-ng-20050414.
> anyone cares to fix this simple warning? :)

Done, thanks.
