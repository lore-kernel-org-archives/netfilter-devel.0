From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH pom-ng] string match on 2.6 kernel
Date: Wed, 06 Apr 2005 20:12:00 +0200
Message-ID: <42542670.7010000@eurodev.net>
References: <20050406151645.GA3921@helminth.linuxhacker.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Anatoly Pugachev <mator@rootshell.ru>
In-Reply-To: <20050406151645.GA3921@helminth.linuxhacker.ru>
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

Hi,

Anatoly Pugachev wrote:
> This kernel-2.6 patch is over cvs version of patch-o-matic, i'm used patch-o-
> matic-ng-20050316. Since i'm not a kernel programmer, this patch isn't SMP
> clean - noticed this in string/linux-2.6/info. 

Current string matching support in pom-ng has several problems:

o Boyer-Moore shifts are calculated every time a packets hits the match, 
this is not necessary. This increases the constants hidden in the O-big 
notation.
o As you pointed out, it's neither SMP nor preemptible safe. Per-cpu 
stuff is not the way to do this.

I've got a brand new infrastructure for string matching that I posted 
during xmas. As soon as I get some spare time I'll be back on it.

--
Pablo
