From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Problems with autotools
Date: Tue, 23 Jan 2007 13:49:45 +0100
Message-ID: <45B60469.2020305@netfilter.org>
References: <200701231224.43655.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Victor Stinner <victor.stinner@inl.fr>
In-Reply-To: <200701231224.43655.victor.stinner@inl.fr>
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

Hi Victor,

Victor Stinner wrote:
> I noticed minor problems with autotools:
> 
> - conntrack: autoheader 2.60 fails because location of config.h is missing 
>    ~~> add « AM_CONFIG_HEADER(config.h) » in configure.in

Actually, the conntrack tool does not require any config.h in order to
compile so the autoheader thing is not required AFAIK. Just committed a
patch to remove the invocation of autoheader.

> - libnfnetlink, libnetfilter_conntrack, libnetfilter_queue autogen.sh use "==" 
> to compare string whereas sh only accepts "=" 
>    ~~> use « [ "x$1" = "xdistrib" ] && include »

Fixed in SVN

> - libtoolize may use option --force and --automake

Just read the docs but unsure about when to use one or another.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
