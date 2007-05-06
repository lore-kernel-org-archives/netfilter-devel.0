From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ANNOUNCE] new match extension about Port Knocking and SPA
Date: Sun, 06 May 2007 17:37:03 +0200
Message-ID: <463DF61F.50509@netfilter.org>
References: <7e36c7130705021606kcbae516g1e34adabd3b441f@mail.gmail.com>	<4639C110.6000407@trash.net>	<7e36c7130705031101i636da079k8077da93ebe1f29a@mail.gmail.com>	<463B3515.9090207@trash.net>
	<7e36c7130705050036w75e63294jed76f68b87b77e41@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Patrick McHardy <kaber@trash.net>
To: fender <frozenspot@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <7e36c7130705050036w75e63294jed76f68b87b77e41@mail.gmail.com>
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
> On 5/4/07, Patrick McHardy <kaber@trash.net> wrote:
>> Nothing, just set up the repository and send me the link.
>
> I'm sorry, I don't know what link of these will be the necessary:
> 
> 1) http://portknocko.berlios.de/  ---> (project home page)
> 
> 2) http://developer.berlios.de/project/showfiles.php?group_id=7093  --->
> (.tar.gz files to download)
> 
> 3) http://svn.berlios.de/svnroot/repos/portknocko/trunk

No, Patrick means a link to your repository in pom-ng format. So
everybody can get external patchlets via ./runme --download.

1) Create a tarball with your project in pom-ng format [1].
2) Create a file called "index" that contains the name of your extension
 in the same directory where you have put the tarball
3) Send us the URL to add it to our sources.list file.

[1] http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
