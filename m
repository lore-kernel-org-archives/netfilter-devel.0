From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] new match extension about Port Knocking and SPA
Date: Wed, 30 May 2007 17:11:04 +0200
Message-ID: <465D9408.5010102@netfilter.org>
References: <7e36c7130705021606kcbae516g1e34adabd3b441f@mail.gmail.com>	
	<463B3515.9090207@trash.net>	
	<7e36c7130705050036w75e63294jed76f68b87b77e41@mail.gmail.com>	
	<463DF61F.50509@netfilter.org>	
	<7e36c7130705081207l5c14807cr1bf715748b1975eb@mail.gmail.com>	
	<46432820.8040602@trash.net>	
	<7e36c7130705110600l35d6af11m3247eabd22621439@mail.gmail.com>	
	<7e36c7130705211244i45ad22depc62e476dff5f30ce@mail.gmail.com>	
	<465227A8.8030105@netfilter.org>	
	<7e36c7130705230626j1de7a1day8c616c37defaf70a@mail.gmail.com>
	<7e36c7130705300630o5850cc15g45fbe5d9628821ba@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
To: fender <frozenspot@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <7e36c7130705300630o5850cc15g45fbe5d9628821ba@mail.gmail.com>
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

fender wrote:
> The tarball link is:
> 
> http://svn.berlios.de/svnroot/repos/portknocko/trunk/pom/

Problems again, pknock.tar.gz seems to be a bzip2 file while
patch-o-matic expects a gzip file. Please, fix it.

$ file pknock.tar.gz
pknock.tar.gz: bzip2 compressed data, block size = 900k

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
