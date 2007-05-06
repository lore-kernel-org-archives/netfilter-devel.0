From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [ANNOUNCE] new match extension about Port Knocking and SPA
Date: Sun, 6 May 2007 18:37:44 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0705061836320.18384@yvahk01.tjqt.qr>
References: <7e36c7130705021606kcbae516g1e34adabd3b441f@mail.gmail.com>
	<4639C110.6000407@trash.net>
	<7e36c7130705031101i636da079k8077da93ebe1f29a@mail.gmail.com>
	<463B3515.9090207@trash.net>
	<7e36c7130705050036w75e63294jed76f68b87b77e41@mail.gmail.com>
	<463DF61F.50509@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>, fender <frozenspot@gmail.com>,
	netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <463DF61F.50509@netfilter.org>
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


On May 6 2007 17:37, Pablo Neira Ayuso wrote:
>fender wrote:
>> On 5/4/07, Patrick McHardy <kaber@trash.net> wrote:
>>> Nothing, just set up the repository and send me the link.
>>
>> I'm sorry, I don't know what link of these will be the necessary:
>> 
>> 1) http://portknocko.berlios.de/  ---> (project home page)
>> 
>> 2) http://developer.berlios.de/project/showfiles.php?group_id=7093  --->
>> (.tar.gz files to download)
>> 
>> 3) http://svn.berlios.de/svnroot/repos/portknocko/trunk
>
>No, Patrick means a link to your repository in pom-ng format. So
>everybody can get external patchlets via ./runme --download.

What bugs me with those external repositories is that there is no
version control behind it. What's more, they can just "disappear"
and in the worst case a module disappears (as in: web hoster killed
the user), which is kinda sad. Not that it happened to me yet,
but the chance is there.

>1) Create a tarball with your project in pom-ng format [1].
>2) Create a file called "index" that contains the name of your extension
> in the same directory where you have put the tarball
>3) Send us the URL to add it to our sources.list file.
>
>[1] http://svn.netfilter.org/cgi-bin/viewcvs.cgi/trunk/patch-o-matic-ng/
>
>-- 
>The dawn of the fourth age of Linux firewalling is coming; a time of
>great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
>

Jan
-- 
